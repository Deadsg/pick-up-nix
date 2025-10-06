.PHONY: all analyze-build-telemetry

all: analyze-build-telemetry

analyze-build-telemetry:
	echo "Building the analyze-build-telemetry Nix task..."
	nix build -f ./analyze-build-telemetry.nix --print-build-logs || true
	echo "Nix build command executed. Checking for result..."
	if [ -L result ]; then \
		echo "Nix build completed. Inspecting result..." \
		ls -l result \
		echo "Content of analysis-result.txt:" \
		cat result/analysis-result.txt; \
	else \
		echo "Nix build failed or did not produce a 'result' symlink." \
		echo "Please review the build logs above for errors."; \
	fi
