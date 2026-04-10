package helpers

import (
	"context"
	"time"

	"github.com/rotisserie/eris"
)

func Retry(ctx context.Context, maxAttempts int, delay time.Duration, op func() error) error {
	var err error
	for range maxAttempts {
		if err = op(); err == nil {
			return nil
		}
		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-time.After(delay):
		}
	}
	return eris.Wrapf(err, "after %d attempts", maxAttempts)
}
