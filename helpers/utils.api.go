// Package helpers provides utilities for extracting standardized request information
// such as client IP, device type, location, and fingerprinting for rate limiting,
// idempotency, and logging purposes.
package helpers

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"net"
	"net/http"
	"net/url"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/google/uuid"
)

type DeviceType string

type DeviceOS string

const (
	DeviceDesktop DeviceType = "desktop"
	DeviceMobile  DeviceType = "mobile"
	DeviceTablet  DeviceType = "tablet"
	DeviceBot     DeviceType = "bot"
	DeviceUnknown DeviceType = "unknown"
)

const (
	OSWindows  DeviceOS = "windows"
	OSMacOS    DeviceOS = "macos"
	OSLinux    DeviceOS = "linux"
	OSAndroid  DeviceOS = "android"
	OSIOS      DeviceOS = "ios"
	OSChromeOS DeviceOS = "chromeos"
	OSUnknown  DeviceOS = "unknown"
)

type DeviceInfo struct {
	Type DeviceType `json:"type"`
	OS   DeviceOS   `json:"os"`
}

type Location struct {
	Timezone  string  `json:"timezone"`
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
	Valid     bool    `json:"valid"`
}

type RequestInfo struct {
	ID             string     `json:"id"`
	Host           string     `json:"host"`
	Path           string     `json:"path"`
	ClientIP       string     `json:"client_ip"`
	UserAgent      string     `json:"user_agent"`
	IsSecure       bool       `json:"is_secure"`
	Protocol       string     `json:"protocol"`
	AcceptLanguage []string   `json:"accept_language"`
	RequestID      string     `json:"request_id"`
	IdempotencyKey string     `json:"idempotency_key"`
	Device         DeviceInfo `json:"device"`
	Location       Location   `json:"location"`
}

func GetRequestInfo(r *http.Request) RequestInfo {
	if r == nil {
		return RequestInfo{}
	}
	info := RequestInfo{
		Host:           GetHost(r),
		Path:           GetPath(r),
		ClientIP:       GetClientIP(r),
		UserAgent:      GetUserAgent(r),
		IsSecure:       IsSecure(r),
		Protocol:       GetProtocol(r),
		AcceptLanguage: GetAcceptLanguage(r),
		RequestID:      GetRequestID(r),
		IdempotencyKey: GetIdempotencyKey(r),
		Device:         GetDeviceInfo(r),
		Location:       GetLocation(r),
	}
	info.ID = GetFingerprint(r)
	return info
}

func GetHost(r *http.Request) string {
	if r == nil {
		return ""
	}
	if r.Host != "" {
		return SanitizeUntrustedText(r.Host, 255)
	}
	hostHeaders := []string{
		"X-Forwarded-Host",
		"X-Original-Host",
		"X-Host",
		"X-Forwarded-Server",
		"X-HTTP-Host-Override",
		"Forwarded",
	}
	for _, h := range hostHeaders {
		if val := r.Header.Get(h); val != "" {
			parts := strings.Split(val, ",")
			return SanitizeUntrustedText(parts[0], 255)
		}
	}

	urlHeaders := []string{"Origin", "Referer"}
	for _, h := range urlHeaders {
		if val := r.Header.Get(h); val != "" {
			if u, err := url.Parse(val); err == nil && u.Host != "" {
				return SanitizeUntrustedText(u.Host, 255)
			}
		}
	}
	return ""
}

func GetClientIP(r *http.Request) string {
	if r == nil {
		return ""
	}

	if forwarded := r.Header.Get("Forwarded"); forwarded != "" {
		if ip := parseForwardedForIP(forwarded); ip != "" {
			return ip
		}
	}
	ipHeaders := []string{
		"CF-Connecting-IP",
		"True-Client-IP",
		"Fly-Client-IP",
		"X-Real-IP",
		"X-Forwarded-For",
		"X-Client-IP",
		"X-Cluster-Client-IP",
		"X-ProxyUser-Ip",
		"Fastly-Client-IP",
		"Forwarded-For",
	}
	for _, header := range ipHeaders {
		if val := r.Header.Get(header); val != "" {
			for candidate := range strings.SplitSeq(val, ",") {
				if ip := strings.TrimSpace(candidate); ip != "" && net.ParseIP(ip) != nil {
					return ip
				}
			}
		}
	}
	if r.RemoteAddr != "" {
		host, _, err := net.SplitHostPort(r.RemoteAddr)
		if err != nil {
			return r.RemoteAddr
		}
		return host
	}
	return ""
}

func parseForwardedForIP(forwarded string) string {
	parts := strings.SplitSeq(forwarded, ";")
	for part := range parts {
		part = strings.TrimSpace(part)
		if after, ok := strings.CutPrefix(part, "for="); ok {
			ip := after
			ip = strings.Trim(ip, "\"")
			if strings.HasPrefix(ip, "[") && strings.Contains(ip, "]") {
				ip = strings.TrimSuffix(strings.TrimPrefix(ip, "["), "]")
			}
			if net.ParseIP(ip) != nil {
				return ip
			}
		}
	}
	return ""
}

func GetProtocol(r *http.Request) string {
	if r == nil {
		return "http"
	}
	if forwarded := r.Header.Get("Forwarded"); forwarded != "" {
		parts := strings.SplitSeq(forwarded, ";")
		for part := range parts {
			part = strings.TrimSpace(part)
			if after, ok := strings.CutPrefix(part, "proto="); ok {
				proto := after
				proto = strings.Trim(proto, "\"")
				proto = strings.ToLower(strings.TrimSpace(proto))
				if proto == "https" || proto == "http" {
					return proto
				}
			}
		}
	}
	if proto := r.Header.Get("X-Forwarded-Proto"); proto != "" {
		return strings.ToLower(strings.TrimSpace(proto))
	}
	if r.TLS != nil {
		return "https"
	}
	return "http"
}

func IsSecure(r *http.Request) bool {
	return GetProtocol(r) == "https"
}

func GetUserAgent(r *http.Request) string {
	if r == nil {
		return ""
	}
	return SanitizeUntrustedText(r.UserAgent(), 512)
}

func GetPath(r *http.Request) string {
	if r == nil || r.URL == nil {
		return "/"
	}
	path := r.URL.Path
	if path == "" {
		return "/"
	}
	path = SanitizeUntrustedText(path, 2048)
	if path == "" {
		return "/"
	}
	if !strings.HasPrefix(path, "/") {
		path = "/" + path
	}
	for strings.Contains(path, "//") {
		path = strings.ReplaceAll(path, "//", "/")
	}
	return strings.TrimSpace(path)
}

func GetAcceptLanguage(r *http.Request) []string {
	if r == nil {
		return nil
	}
	header := strings.TrimSpace(r.Header.Get("Accept-Language"))
	if header == "" {
		return nil
	}
	type langQ struct {
		lang string
		q    float64
	}
	parts := strings.Split(header, ",")
	langs := make([]langQ, 0, len(parts))
	for _, part := range parts {
		part = strings.TrimSpace(part)
		if part == "" {
			continue
		}
		segments := strings.SplitN(part, ";", 2)
		lang := strings.TrimSpace(segments[0])
		if lang == "" || lang == "*" {
			continue
		}
		q := 1.0
		if len(segments) == 2 {
			qStr := strings.TrimSpace(strings.TrimPrefix(segments[1], "q="))
			if parsed, err := strconv.ParseFloat(qStr, 64); err == nil {
				q = parsed
			}
		}
		langs = append(langs, langQ{lang: lang, q: q})
	}
	sort.SliceStable(langs, func(i, j int) bool {
		return langs[i].q > langs[j].q
	})

	result := make([]string, len(langs))
	for i, l := range langs {
		result[i] = l.lang
	}
	return result
}

func GetRequestID(r *http.Request) string {
	if r == nil {
		return ""
	}
	headers := []string{
		"X-Request-ID", "Request-ID",
		"X-Correlation-ID", "Correlation-ID",
		"X-Trace-ID", "Trace-ID",
	}
	for _, h := range headers {
		if val := strings.TrimSpace(r.Header.Get(h)); val != "" {
			return SanitizeUntrustedText(val, 256)
		}
	}
	return ""
}

func GetIdempotencyKey(r *http.Request) string {
	key, _ := ValidateIdempotencyKey(r)
	return key
}

func ValidateIdempotencyKey(r *http.Request) (string, error) {
	if r == nil {
		return "", nil
	}
	var val string
	for _, header := range []string{"X-Idempotency-Key", "Idempotency-Key"} {
		if v := strings.TrimSpace(r.Header.Get(header)); v != "" {
			val = v
			break
		}
	}
	if val == "" {
		return "", nil
	}
	if _, err := uuid.Parse(val); err != nil {
		return "", fmt.Errorf("Idempotency-Key must be a valid UUID, got: %q", val)
	}
	return val, nil
}

func HashRequestKey(parts ...string) string {
	h := sha256.New()
	for _, p := range parts {
		p = sanitizeHashPart(p)
		if p == "" {
			continue
		}
		h.Write([]byte(p))
		h.Write([]byte("|"))
	}
	return hex.EncodeToString(h.Sum(nil))
}

func sanitizeHashPart(s string) string {
	s = SanitizeUntrustedText(s, 4096)
	s = strings.ToLower(s)
	return SanitizeUntrustedText(s, 256)
}

func GetDeviceInfo(r *http.Request) DeviceInfo {
	if r == nil {
		return DeviceInfo{Type: DeviceUnknown, OS: OSUnknown}
	}
	if deviceTypeStr := strings.TrimSpace(r.Header.Get("X-Device-Type")); deviceTypeStr != "" {
		deviceTypeStr = strings.ToLower(deviceTypeStr)
		switch DeviceType(deviceTypeStr) {
		case DeviceDesktop, DeviceMobile, DeviceTablet, DeviceBot:
			return DeviceInfo{Type: DeviceType(deviceTypeStr), OS: getOSFromUA(r.UserAgent())}
		}
	}
	ua := strings.ToLower(r.UserAgent())
	if ua == "" {
		return DeviceInfo{Type: DeviceUnknown, OS: OSUnknown}
	}
	botSignals := []string{
		"bot", "crawler", "spider", "slurp", "facebookexternalhit",
		"googlebot", "bingbot", "yandex", "duckduckbot", "baidu",
		"sogou", "exabot", "curl", "wget", "python-requests", "go-http-client",
	}
	for _, sig := range botSignals {
		if strings.Contains(ua, sig) {
			return DeviceInfo{Type: DeviceBot, OS: OSUnknown}
		}
	}
	os := getOSFromUA(ua)
	var deviceType DeviceType
	switch {
	case strings.Contains(ua, "tablet") || strings.Contains(ua, "ipad"):
		deviceType = DeviceTablet
	case strings.Contains(ua, "android") && !strings.Contains(ua, "mobile"):
		deviceType = DeviceTablet
	case strings.Contains(ua, "mobile") || strings.Contains(ua, "iphone") ||
		strings.Contains(ua, "ipod") || strings.Contains(ua, "blackberry") ||
		strings.Contains(ua, "windows phone"):
		deviceType = DeviceMobile
	default:
		deviceType = DeviceDesktop
	}
	return DeviceInfo{Type: deviceType, OS: os}
}

func getOSFromUA(ua string) DeviceOS {
	ua = strings.ToLower(ua)
	switch {
	case strings.Contains(ua, "android"):
		return OSAndroid
	case strings.Contains(ua, "iphone"), strings.Contains(ua, "ipad"), strings.Contains(ua, "ipod"):
		return OSIOS
	case strings.Contains(ua, "cros"):
		return OSChromeOS
	case strings.Contains(ua, "windows"):
		return OSWindows
	case strings.Contains(ua, "macintosh"), strings.Contains(ua, "mac os x"):
		return OSMacOS
	case strings.Contains(ua, "linux"):
		return OSLinux
	default:
		return OSUnknown
	}
}

func GetLocation(r *http.Request) Location {
	if r == nil {
		return Location{Timezone: "UTC", Valid: true}
	}
	timezoneHeaders := []string{
		"X-Timezone", "X-TZ", "X-User-Timezone",
		"X-Client-Timezone", "CF-Timezone-ID", "X-Forwarded-Timezone",
	}
	timezone := "UTC"
	for _, header := range timezoneHeaders {
		if tz := strings.TrimSpace(r.Header.Get(header)); tz != "" {
			timezone = tz
			break
		}
	}
	_, err := time.LoadLocation(timezone)
	valid := err == nil
	return Location{
		Timezone:  timezone,
		Latitude:  getCoordinate(r, "X-Latitude", "Latitude"),
		Longitude: getCoordinate(r, "X-Longitude", "Longitude"),
		Valid:     valid,
	}
}

func getCoordinate(r *http.Request, headers ...string) float64 {
	if r == nil {
		return 0
	}
	for _, header := range headers {
		if val := strings.TrimSpace(r.Header.Get(header)); val != "" {
			if coord, err := strconv.ParseFloat(val, 64); err == nil {
				return coord
			}
		}
	}
	return 0
}

// GetRequestTraceKey returns a per-request correlation key that may vary by request headers.
// Use for logging/tracing, not for stable rate limiting.
func GetRequestTraceKey(r *http.Request) string {
	if r == nil {
		return ""
	}
	return HashRequestKey(GetFingerprint(r), GetRequestID(r), GetIdempotencyKey(r))
}

// GetFingerprint builds a stable fingerprint for abuse/rate-limit controls.
// Deliberately excludes RequestID/IdempotencyKey because they can change per retry/request.
func GetFingerprint(r *http.Request) string {
	if r == nil {
		return ""
	}
	device := GetDeviceInfo(r)
	location := GetLocation(r)
	parts := []string{
		string(device.Type),
		string(device.OS),
		GetUserAgent(r),
		strings.Join(GetAcceptLanguage(r), "|"),
		location.Timezone,
		buildAcceptString(r),
		GetClientIP(r),
		r.Method,
		GetPath(r),
	}
	return HashRequestKey(parts...)
}
func buildAcceptString(r *http.Request) string {
	acceptTypes := []string{
		SanitizeUntrustedText(r.Header.Get("Accept"), 256),
		SanitizeUntrustedText(r.Header.Get("Accept-Encoding"), 128),
		SanitizeUntrustedText(r.Header.Get("Accept-Charset"), 128),
	}
	return strings.Join(acceptTypes, "|")
}
