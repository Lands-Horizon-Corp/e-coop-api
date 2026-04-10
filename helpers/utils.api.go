package helpers

import (
	"context"
	"net"
	"net/http"
	"net/url"
	"strings"
)

type RequestInfo struct {
	Host      string
	Path      string
	ClientIP  string
	UserAgent string
	IsSecure  bool
	Protocol  string
}

func GetRequestInfo(ctx context.Context, r *http.Request) RequestInfo {
	return RequestInfo{
		Host:      GetHost(r),
		Path:      GetPath(r),
		ClientIP:  GetClientIP(r),
		UserAgent: GetUserAgent(r),
		IsSecure:  IsSecure(r),
		Protocol:  GetProtocol(r),
	}
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
			ips := strings.Split(ip, ",")
			if trimmed := strings.TrimSpace(ips[0]); trimmed != "" {
				return trimmed
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
