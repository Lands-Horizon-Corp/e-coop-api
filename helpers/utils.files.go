package helpers

import (
	"os"
	"strings"

	"github.com/rotisserie/eris"
)

func HasFileExtension(filename string) bool {
	return strings.Contains(filename, ".") && !strings.HasSuffix(filename, ".")
}

func GetExtensionFromContentType(contentType string) string {
	contentTypeMap := map[string]string{
		"audio/aac":    ".aac",
		"audio/midi":   ".mid",
		"audio/x-midi": ".midi",
		"audio/mpeg":   ".mp3",
		"audio/ogg":    ".oga",
		"audio/wav":    ".wav",
		"audio/webm":   ".weba",
		"audio/3gpp":   ".3gp",
		"audio/3gpp2":  ".3g2",
		"audio/flac":   ".flac",
		"audio/x-aiff": ".aiff",
		"audio/mp4":    ".m4a",

		"video/x-msvideo":  ".avi",
		"video/mp4":        ".mp4",
		"video/mpeg":       ".mpeg",
		"video/ogg":        ".ogv",
		"video/mp2t":       ".ts",
		"video/webm":       ".webm",
		"video/3gpp":       ".3gp",
		"video/3gpp2":      ".3g2",
		"video/quicktime":  ".mov",
		"video/x-matroska": ".mkv",
		"video/x-flv":      ".flv",

		"image/apng":               ".apng",
		"image/avif":               ".avif",
		"image/bmp":                ".bmp",
		"image/gif":                ".gif",
		"image/jpeg":               ".jpg",
		"image/png":                ".png",
		"image/svg+xml":            ".svg",
		"image/tiff":               ".tiff",
		"image/webp":               ".webp",
		"image/vnd.microsoft.icon": ".ico",
		"image/x-icon":             ".ico",
		"image/heic":               ".heic",
		"image/heif":               ".heif",

		"font/otf":        ".otf",
		"font/ttf":        ".ttf",
		"font/woff":       ".woff",
		"font/woff2":      ".woff2",
		"font/collection": ".ttc",
		"font/sfnt":       ".ttf",

		"application/x-abiword":        ".abw",
		"application/x-freearc":        ".arc",
		"application/vnd.amazon.ebook": ".azw",
		"application/octet-stream":     ".bin",
		"application/x-bzip":           ".bz",
		"application/x-bzip2":          ".bz2",
		"application/x-cdf":            ".cda",
		"application/x-csh":            ".csh",
		"application/msword":           ".doc",
		"application/vnd.openxmlformats-officedocument.wordprocessingml.document": ".docx",
		"application/vnd.ms-fontobject":                                           ".eot",
		"application/epub+zip":                                                    ".epub",
		"application/gzip":                                                        ".gz",
		"application/x-gzip":                                                      ".gz",
		"application/java-archive":                                                ".jar",
		"application/json":                                                        ".json",
		"application/ld+json":                                                     ".jsonld",
		"application/vnd.apple.installer+xml":                                     ".mpkg",
		"application/vnd.oasis.opendocument.presentation":                         ".odp",
		"application/vnd.oasis.opendocument.spreadsheet":                          ".ods",
		"application/vnd.oasis.opendocument.text":                                 ".odt",
		"application/ogg":                                                         ".ogx",
		"application/pdf":                                                         ".pdf",
		"application/x-httpd-php":                                                 ".php",
		"application/vnd.ms-powerpoint":                                           ".ppt",
		"application/vnd.openxmlformats-officedocument.presentationml.presentation": ".pptx",
		"application/vnd.rar":       ".rar",
		"application/rtf":           ".rtf",
		"application/x-sh":          ".sh",
		"application/x-tar":         ".tar",
		"application/vnd.visio":     ".vsd",
		"application/manifest+json": ".webmanifest",
		"application/xhtml+xml":     ".xhtml",
		"application/vnd.ms-excel":  ".xls",
		"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": ".xlsx",
		"application/xml":                         ".xml",
		"application/vnd.mozilla.xul+xml":         ".xul",
		"application/zip":                         ".zip",
		"application/x-zip-compressed":            ".zip",
		"application/x-7z-compressed":             ".7z",
		"application/x-rar-compressed":            ".rar",
		"application/x-www-form-urlencoded":       ".urlencoded",
		"application/vnd.android.package-archive": ".apk",
		"application/x-apple-diskimage":           ".dmg",
		"application/x-debian-package":            ".deb",
		"application/x-redhat-package-manager":    ".rpm",

		"text/css":           ".css",
		"text/csv":           ".csv",
		"text/html":          ".html",
		"text/javascript":    ".js",
		"text/calendar":      ".ics",
		"text/markdown":      ".md",
		"text/plain":         ".txt",
		"text/xml":           ".xml",
		"text/x-python":      ".py",
		"text/x-shellscript": ".sh",
		"text/vcard":         ".vcf",
		"text/yaml":          ".yaml",
		"text/x-yaml":        ".yml",

		"model/gltf+json":   ".gltf",
		"model/gltf-binary": ".glb",
		"model/obj":         ".obj",
		"model/stl":         ".stl",

		"text/vtt":             ".vtt",
		"application/x-subrip": ".srt",

		"application/x-msdownload":      ".exe",
		"application/x-shockwave-flash": ".swf",

		"application/sql": ".sql",

		"application/rss+xml":  ".rss",
		"application/atom+xml": ".atom",
		"application/wasm":     ".wasm",
	}
	cleanContentType := strings.Split(contentType, ";")[0]
	cleanContentType = strings.TrimSpace(cleanContentType)

	if ext, exists := contentTypeMap[cleanContentType]; exists {
		return ext
	}
	return ""
}

func IsValidFilePath(p string) error {
	info, err := os.Stat(p)
	if os.IsNotExist(err) {
		return eris.New("not exist")
	}
	if err != nil {
		return eris.Wrapf(err, "failed to stat path: %s", p)
	}
	if info.IsDir() {
		return eris.New("is dir not file")
	}
	return nil
}
