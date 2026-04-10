package helpers

import (
	"fmt"
	"os/exec"
	"runtime"
	"strconv"
	"strings"

	"github.com/rotisserie/eris"
)

func IsValidPort(port string) bool {
	p, err := strconv.Atoi(port)
	if err != nil {
		return false
	}
	return p > 0 && p <= 65535
}
func KillPort(port string) error {
	if !IsValidPort(port) {
		return eris.Errorf("invalid port number: %s (must be between 1-65535)", port)
	}
	switch runtime.GOOS {
	case "linux":
		if _, err := exec.LookPath("fuser"); err == nil {
			err := exec.Command("fuser", "-k", port+"/tcp").Run()
			if err != nil && !strings.Contains(err.Error(), "exit status") {
				return eris.Wrapf(err, "failed to kill port %s using fuser", port)
			}
			return nil
		}
		return killWithLsof(port)
	case "darwin":
		return killWithLsof(port)
	case "windows":
		psCmd := fmt.Sprintf("(Get-NetTCPConnection -LocalPort %s).OwningProcess", port)
		out, err := exec.Command("powershell", "-Command", psCmd).Output()
		if err != nil {
			return nil
		}

		pids := strings.Fields(string(out))
		for _, pid := range pids {
			err := exec.Command("taskkill", "/F", "/PID", pid).Run()
			if err != nil {
				return eris.Wrapf(err, "failed to taskkill PID %s on Windows", pid)
			}
		}
		return nil
	default:
		return eris.Errorf("unsupported OS: %s", runtime.GOOS)
	}
}

func killWithLsof(port string) error {
	out, err := exec.Command("lsof", "-t", "-i", "tcp:"+port).Output()
	if err != nil {
		return nil
	}
	pids := strings.FieldsSeq(string(out))
	for pid := range pids {
		err := exec.Command("kill", "-9", pid).Run()
		if err != nil {
			return eris.Wrapf(err, "failed to kill PID %s using lsof", pid)
		}
	}
	return nil
}
