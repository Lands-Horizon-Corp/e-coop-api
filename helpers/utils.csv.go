package helpers

import (
	"archive/zip"
	"encoding/csv"
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"

	"golang.org/x/text/encoding/japanese"
	"golang.org/x/text/transform"
)

type CSVEncoding string

const (
	EncodingShiftJIS CSVEncoding = "sjis"
	EncodingUTF8BOM  CSVEncoding = "utf8bom"
)

type ZipFile struct {
	Name    string
	Content []byte
}

type CSVExporter struct {
	DefaultEncoding CSVEncoding
}

func NewCSVExporter() *CSVExporter {
	return &CSVExporter{
		DefaultEncoding: EncodingUTF8BOM,
	}
}

func ParseCSVFile(fileBytes []byte) ([][]string, error) {
	reader := csv.NewReader(strings.NewReader(string(fileBytes)))
	return reader.ReadAll()
}

func (e *CSVExporter) setCSVHeaders(w http.ResponseWriter, filename string, encoding CSVEncoding) {
	if !strings.HasSuffix(filename, ".csv") {
		filename += ".csv"
	}
	w.Header().Set("Content-Disposition", fmt.Sprintf("attachment; filename=%s", filename))
	if encoding == EncodingShiftJIS {
		w.Header().Set("Content-Type", "text/csv; charset=Shift_JIS")
	} else {
		w.Header().Set("Content-Type", "text/csv; charset=utf-8")
	}
}

func WriteCSV[T any](w io.Writer, encoding CSVEncoding, headers []string, items []T, mapper func(T) []string) error {
	var out io.Writer = w

	switch encoding {
	case EncodingShiftJIS:
		encoder := japanese.ShiftJIS.NewEncoder()
		encWriter := transform.NewWriter(w, encoder)
		defer encWriter.Close()
		out = encWriter

	case EncodingUTF8BOM:
		if _, err := w.Write([]byte{0xEF, 0xBB, 0xBF}); err != nil {
			return fmt.Errorf("failed to write BOM: %w", err)
		}
	}

	writer := csv.NewWriter(out)
	writer.UseCRLF = true

	if err := writer.Write(headers); err != nil {
		return fmt.Errorf("failed to write headers: %w", err)
	}

	for _, item := range items {
		if err := writer.Write(mapper(item)); err != nil {
			return fmt.Errorf("failed to write record: %w", err)
		}
	}

	writer.Flush()
	return writer.Error()
}

func ExportCSV[T any](e *CSVExporter, w http.ResponseWriter, filename string, headers []string, items []T, mapper func(T) []string) error {
	encoding := e.DefaultEncoding
	e.setCSVHeaders(w, filename, encoding)
	return WriteCSV(w, encoding, headers, items, mapper)
}

func (e *CSVExporter) ExportZip(w http.ResponseWriter, zipFilename string, files []ZipFile) error {
	w.Header().Set("Content-Type", "application/zip")
	w.Header().Set("Content-Disposition", fmt.Sprintf("attachment; filename=%s.zip", zipFilename))

	zipWriter := zip.NewWriter(w)
	defer zipWriter.Close()

	for _, file := range files {
		f, err := zipWriter.Create(file.Name)
		if err != nil {
			return fmt.Errorf("failed to create zip entry %s: %w", file.Name, err)
		}
		if _, err = f.Write(file.Content); err != nil {
			return fmt.Errorf("failed to write content to %s: %w", file.Name, err)
		}
	}
	return nil
}

func (e *CSVExporter) ExportFiles(w http.ResponseWriter, baseFilename string, files []ZipFile) error {
	if len(files) == 0 {
		return fmt.Errorf("no files to export")
	}

	if len(files) == 1 {
		e.setCSVHeaders(w, files[0].Name, e.DefaultEncoding)
		_, err := w.Write(files[0].Content)
		return err
	}
	zipName := fmt.Sprintf("%s_%s", baseFilename, time.Now().Format("20060102150405"))
	return e.ExportZip(w, zipName, files)
}
