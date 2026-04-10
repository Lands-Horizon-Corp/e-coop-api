package helpers

import (
	"net/mail"
	"regexp"
	"strings"

	"github.com/microcosm-cc/bluemonday"
)

var strictSanitizer = bluemonday.StrictPolicy()
var space = regexp.MustCompile(`\s+`)

func IsValidEmail(email string) bool {
	_, err := mail.ParseAddress(email)
	return err == nil
}

func Sanitize(input string) string {
	p := bluemonday.NewPolicy()
	p.AllowElements("style")
	p.AllowElements("html", "head", "body", "div", "span", "p", "br", "h1", "h2", "h3", "h4", "h5", "h6")
	p.AllowElements("table", "thead", "tbody", "tfoot", "tr", "th", "td")
	p.AllowAttrs("style").OnElements("div", "span", "p", "table", "td", "th", "tr", "body")
	anyValue := func(value string) bool { return true }
	p.AllowStyles("color").MatchingHandler(anyValue).Globally()
	p.AllowStyles("background").MatchingHandler(anyValue).Globally()
	p.AllowStyles("background-color").MatchingHandler(anyValue).Globally()
	p.AllowStyles("font-family").MatchingHandler(anyValue).Globally()
	p.AllowStyles("font-size").MatchingHandler(anyValue).Globally()
	p.AllowStyles("font-weight").MatchingHandler(anyValue).Globally()
	p.AllowStyles("text-align").MatchingHandler(anyValue).Globally()
	p.AllowStyles("width").MatchingHandler(anyValue).Globally()
	p.AllowStyles("height").MatchingHandler(anyValue).Globally()
	p.AllowStyles("margin").MatchingHandler(anyValue).Globally()
	p.AllowStyles("padding").MatchingHandler(anyValue).Globally()
	p.AllowStyles("border").MatchingHandler(anyValue).Globally()
	p.AllowStyles("border-collapse").MatchingHandler(anyValue).Globally()
	p.AllowStyles("display").MatchingHandler(anyValue).Globally()
	p.AllowStyles("flex").MatchingHandler(anyValue).Globally()
	p.AllowStyles("grid-template-columns").MatchingHandler(anyValue).Globally()
	p.AllowStyles("gap").MatchingHandler(anyValue).Globally()
	p.AllowStyles("justify-content").MatchingHandler(anyValue).Globally()
	p.AllowStyles("align-items").MatchingHandler(anyValue).Globally()
	return p.Sanitize(strings.TrimSpace(input))
}

func IsValidPhoneNumber(phone string) bool {
	return regexp.MustCompile(`^\+?(?:\d{1,4})?\d{7,14}$`).MatchString(phone)
}

func SanitizeUntrustedText(s string, maxLen int) string {
	if s == "" {
		return ""
	}
	if maxLen > 0 && len(s) > maxLen {
		s = s[:maxLen]
	}
	s = strings.ReplaceAll(s, "\x00", "")
	s = strictSanitizer.Sanitize(s)
	s = strings.Map(func(r rune) rune {
		if r < 32 || r == 127 {
			return -1
		}
		return r
	}, s)
	s = strings.TrimSpace(s)
	s = strings.Join(strings.Fields(s), " ")
	if maxLen > 0 && len(s) > maxLen {
		s = s[:maxLen]
	}
	return s
}

func CleanString(s string) string {
	s = strings.TrimSpace(s)
	s = strings.ToLower(s)

	s = space.ReplaceAllString(s, " ")
	return s
}

func IsSuspicious(path string) bool {
	path = strings.ToLower(path)
	for _, p := range SuspiciousPaths {
		if strings.Contains(path, strings.ToLower(p)) {
			return true
		}
	}
	return false
}
