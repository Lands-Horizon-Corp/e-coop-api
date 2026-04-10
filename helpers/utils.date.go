package helpers

import "time"

func ToReadableDate(t time.Time) string {
	if t.IsZero() {
		return ""
	}
	if t.Hour() == 0 && t.Minute() == 0 && t.Second() == 0 {
		return t.Format("January 2, 2006")
	}
	return t.Format("January 2, 2006 3:04 PM")
}

func AddMonthsPreserveDay(t time.Time, months int) time.Time {
	year := t.Year()
	month := int(t.Month())
	day := t.Day()

	month += months
	year += (month - 1) / 12
	month = (month-1)%12 + 1

	loc := t.Location()
	firstOfTarget := time.Date(year, time.Month(month), 1, t.Hour(), t.Minute(), t.Second(), t.Nanosecond(), loc)
	lastOfTarget := firstOfTarget.AddDate(0, 1, -1).Day()
	if day > lastOfTarget {
		day = lastOfTarget
	}
	return time.Date(year, time.Month(month), day, t.Hour(), t.Minute(), t.Second(), t.Nanosecond(), loc)
}
