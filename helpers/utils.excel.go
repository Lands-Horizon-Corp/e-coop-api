package helpers

import (
	"github.com/rotisserie/eris"
	"github.com/xuri/excelize/v2"
)

type ExcelRowMapper[T any] func(row []string) (T, error)

func ReadExcel[T any](filePath string, sheetName string, mapper ExcelRowMapper[T]) ([]T, error) {
	f, err := excelize.OpenFile(filePath)
	if err != nil {
		return nil, eris.Wrap(err, "failed to open excel")
	}
	defer f.Close()
	rows, err := f.GetRows(sheetName)
	if err != nil {
		return nil, eris.Wrap(err, "failed to get rows")
	}
	var results []T
	for i, row := range rows {
		if i == 0 || len(row) == 0 {
			continue
		}
		item, err := mapper(row)
		if err != nil {
			return nil, eris.Wrapf(err, "error at row %d", i+1)
		}
		results = append(results, item)
	}
	return results, nil
}
