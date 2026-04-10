package helpers

import (
	"crypto/rand"
	"crypto/sha512"
	"encoding/hex"
	"fmt"
	"math/big"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/rotisserie/eris"
)

func GenerateToken() (string, error) {
	id, err := uuid.NewRandom()
	if err != nil {
		return "", eris.Wrap(err, "token generation failed")
	}
	return id.String(), nil
}

func GenerateDigitCode(digits int) (string, error) {
	if digits <= 0 {
		return "", eris.New("digits must be greater than 0")
	}
	n, err := rand.Int(rand.Reader, new(big.Int).Exp(big.NewInt(10), big.NewInt(int64(digits)), nil))
	if err != nil {
		return "", eris.Wrap(err, "digit code generation failed")
	}
	return fmt.Sprintf(fmt.Sprintf("%%0%dd", digits), n.Int64()), nil
}

func GeneratePassbookNumber() string {
	u := uuid.New()
	compact := strings.ReplaceAll(u.String(), "-", "")
	short := strings.ToUpper(compact[:12])
	year := time.Now().Year()
	return fmt.Sprintf("PB-%d-%s", year, short)
}

func GenerateLicenseKey() (string, error) {
	uuid := make([]byte, 16)
	if _, err := rand.Read(uuid); err != nil {
		return "", err
	}
	uuid[6] = (uuid[6] & 0x0f) | 0x40
	uuid[8] = (uuid[8] & 0x3f) | 0x80
	timestamp := time.Now().UTC().UnixNano()
	entropy := make([]byte, 64)
	if _, err := rand.Read(entropy); err != nil {
		return "", err
	}
	payload := fmt.Sprintf("%x:%d:%x", uuid, timestamp, entropy)
	hash := sha512.Sum512([]byte(payload))
	hashHex := strings.ToUpper(hex.EncodeToString(hash[:]))
	return hashHex[:127], nil
}
