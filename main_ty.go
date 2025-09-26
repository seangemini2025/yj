//go:build ty

package main

import (
	"fmt"
	"io"
	"os"
	"strings"
)

var Version = "0.0.0"

const TyHelpMsg = `Usage: %s [-][ytjcrneikhv]

Convert between YAML, TOML, JSON, and HCL.
Preserves map order.

-x[x]  Convert using stdin. Valid options:
          -ty, -t = TOML to YAML (default)
          -yj, -y = YAML to JSON
          -yy     = YAML to YAML
          -yt     = YAML to TOML
          -yc     = YAML to HCL
          -tj     = TOML to JSON
          -tt     = TOML to TOML
          -tc     = TOML to HCL
          -jj     = JSON to JSON
          -jy, -r = JSON to YAML
          -jt     = JSON to TOML
          -jc     = JSON to HCL
          -cy     = HCL to YAML
          -ct     = HCL to TOML
          -cj, -c = HCL to JSON
          -cc     = HCL to HCL
-n     Do not covert inf, -inf, and NaN to/from strings (YAML or TOML only)
-e     Escape HTML (JSON out only)
-i     Indent output (JSON or TOML out only)
-k     Attempt to parse keys as objects or numeric types (YAML out only)
-h     Show this help message
-v     Show version

`

func main() {
	os.Exit(RunTy(os.Stdin, os.Stdout, os.Stderr, os.Args))
}

func RunTy(stdin io.Reader, stdout, stderr io.Writer, osArgs []string) (code int) {
	config, err := parseWithDefault(osArgs[1:], "ty")
	if err != nil {
		fmt.Fprintf(stderr, TyHelpMsg, os.Args[0])
		fmt.Fprintf(stderr, "Error: %s\n", err)
		return 1
	}
	if config.Help {
		fmt.Fprintf(stdout, TyHelpMsg, os.Args[0])
		return 0
	}
	if config.Version {
		fmt.Fprintln(stdout, "v"+Version)
		return 0
	}

	rep, err := config.From.Decode(stdin)
	if err != nil {
		// TODO: I forget if there's a reason this isn't io.EOF
		if err.Error() == "EOF" {
			return 0
		}
		fmt.Fprintf(stderr, "Error parsing %s: %s\n", config.From, err)
		return 1
	}
	if err := config.To.Encode(stdout, rep); err != nil {
		fmt.Fprintf(stderr, "Error writing %s: %s\n", config.To, err)
		return 1
	}
	return 0
}

func parseWithDefault(args []string, defaultConversion string) (*Config, error) {
	// If no arguments provided, use the default conversion
	if len(args) == 0 || (len(args) == 1 && strings.TrimSpace(args[0]) == "") {
		args = []string{defaultConversion}
	}
	return Parse(args...)
}
