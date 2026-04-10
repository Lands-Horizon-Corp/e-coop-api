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
	Type DeviceType
	OS   DeviceOS
}

type Location struct {
	Timezone  string
	Latitude  float64
	Longitude float64
	Valid     bool
}

type RequestInfo struct {
	ID             string
	Host           string
	Path           string
	ClientIP       string
	UserAgent      string
	IsSecure       bool
	Protocol       string
	AcceptLanguage []string
	RequestID      string
	IdempotencyKey string
	RequestHash    string
	Device         DeviceInfo
	Location       Location
}

func GetRequestInfo(r *http.Request) RequestInfo {
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
	// Use device fingerprint as ID for better rate limiting/idempotency
	// Resistant to VPN bypass and proxy changes
	info.ID = GetFingerprint(r)
	return info
}

func GetHost(r *http.Request) string {
	if r == nil {
		return ""
	}
	if r.Host != "" {
		return strings.TrimSpace(r.Host)
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
		if host := r.Header.Get(h); host != "" {
			parts := strings.Split(host, ",")
			return strings.TrimSpace(parts[0])
		}
	}
	urlHeaders := []string{"Origin", "Referer"}
	for _, h := range urlHeaders {
		if val := r.Header.Get(h); val != "" {
			if u, err := url.Parse(val); err == nil && u.Host != "" {
				return u.Host
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
		parts := strings.Split(forwarded, ";")
		for _, part := range parts {
			part = strings.TrimSpace(part)
			if strings.HasPrefix(part, "for=") {
				ip := strings.TrimPrefix(part, "for=")
				ip = strings.Trim(ip, "\"")
				if strings.HasPrefix(ip, "[") && strings.Contains(ip, "]") {
					ip = strings.TrimSuffix(strings.TrimPrefix(ip, "["), "]")
				}
				if net.ParseIP(ip) != nil {
					return ip
				}
			}
		}
	}
	headers := []string{
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
	for _, header := range headers {
		if ip := r.Header.Get(header); ip != "" {
			for _, candidate := range strings.Split(ip, ",") {
				trimmed := strings.TrimSpace(candidate)
				if trimmed != "" && net.ParseIP(trimmed) != nil {
					return trimmed
				}
			}
		}
	}
	if ip := r.RemoteAddr; ip != "" {
		host, _, err := net.SplitHostPort(ip)
		if err != nil {
			return ip
		}
		return host
	}
	return ""
}

func GetProtocol(r *http.Request) string {
	if r == nil {
		return "http"
	}
	// RFC 7239: Forwarded header (standard format)
	if forwarded := r.Header.Get("Forwarded"); forwarded != "" {
		parts := strings.Split(forwarded, ";")
		for _, part := range parts {
			part = strings.TrimSpace(part)
			if strings.HasPrefix(part, "proto=") {
				proto := strings.TrimPrefix(part, "proto=")
				proto = strings.Trim(proto, "\"")
				if proto = strings.ToLower(strings.TrimSpace(proto)); proto == "https" || proto == "http" {
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
	ua := r.UserAgent()
	if len(ua) > 512 {
		ua = ua[:512]
	}
	ua = strings.ReplaceAll(ua, "\x00", "")
	ua = strings.Map(func(r rune) rune {
		if r < 32 || r == 127 {
			return -1
		}
		return r
	}, ua)
	return strings.TrimSpace(ua)
}

func GetPath(r *http.Request) string {
	if r == nil || r.URL == nil {
		return "/"
	}
	path := r.URL.Path
	if path == "" {
		return "/"
	}
	if len(path) > 2048 {
		path = path[:2048]
	}
	path = strings.ReplaceAll(path, "\x00", "")
	path = strings.Map(func(r rune) rune {
		if r < 32 || r == 127 {
			return -1
		}
		return r
	}, path)
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
			qStr := strings.TrimSpace(strings.TrimPrefix(strings.TrimSpace(segments[1]), "q="))
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
	// Check both prefixed (X-) and non-prefixed variants
	for _, header := range []string{"X-Request-ID", "Request-ID", "X-Correlation-ID", "Correlation-ID", "X-Trace-ID", "Trace-ID"} {
		if val := strings.TrimSpace(r.Header.Get(header)); val != "" {
			return val
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
	// Check both prefixed and non-prefixed variants
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
		p = strings.TrimSpace(p)
		p = strings.ToLower(p)
		p = strings.Join(strings.Fields(p), " ")
		h.Write([]byte(p))
		h.Write([]byte("|"))
	}
	return hex.EncodeToString(h.Sum(nil))
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
	botSignals := []string{"bot", "crawler", "spider", "slurp", "facebookexternalhit", "googlebot", "bingbot", "yandex", "duckduckbot", "baidu", "sogou", "exabot", "curl", "wget", "python-requests", "go-http-client"}
	for _, sig := range botSignals {
		if strings.Contains(ua, sig) {
			return DeviceInfo{Type: DeviceBot, OS: OSUnknown}
		}
	}
	os := getOSFromUA(ua)
	var deviceType DeviceType
	switch {
	case strings.Contains(ua, "tablet") || strings.Contains(ua, "ipad") ||
		(strings.Contains(ua, "android") && !strings.Contains(ua, "mobile")):
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
	case strings.Contains(ua, "iphone") || strings.Contains(ua, "ipad") || strings.Contains(ua, "ipod"):
		return OSIOS
	case strings.Contains(ua, "cros"):
		return OSChromeOS
	case strings.Contains(ua, "windows"):
		return OSWindows
	case strings.Contains(ua, "macintosh") || strings.Contains(ua, "mac os x"):
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
		"X-Timezone",
		"X-TZ",
		"X-User-Timezone",
		"X-Client-Timezone",
		"CF-Timezone-ID",
		"X-Forwarded-Timezone",
	}
	timezone := ""
	for _, header := range timezoneHeaders {
		if tz := strings.TrimSpace(r.Header.Get(header)); tz != "" {
			timezone = tz
			break
		}
	}
	if timezone == "" {
		timezone = "UTC"
	}
	_, err := time.LoadLocation(timezone)
	valid := err == nil
	lat := getCoordinate(r, "X-Latitude", "Latitude")
	lng := getCoordinate(r, "X-Longitude", "Longitude")
	return Location{
		Timezone:  timezone,
		Latitude:  lat,
		Longitude: lng,
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

func GetFingerprint(r *http.Request) string {
	if r == nil {
		return ""
	}
	device := GetDeviceInfo(r)
	location := GetLocation(r)
	langStr := strings.Join(GetAcceptLanguage(r), "|")
	acceptTypes := []string{
		r.Header.Get("Accept"),
		r.Header.Get("Accept-Encoding"),
		r.Header.Get("Accept-Charset"),
	}
	acceptStr := strings.Join(acceptTypes, "|")
	fingerprint := strings.Join([]string{
		string(device.Type),
		string(device.OS),
		r.UserAgent(),
		langStr,
		location.Timezone,
		acceptStr,
		GetClientIP(r),
		r.Method,
		GetPath(r),
		GetRequestID(r),
		GetIdempotencyKey(r),
	}, "|")
	return HashRequestKey(fingerprint)
}
