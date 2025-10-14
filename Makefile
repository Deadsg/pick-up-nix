# Makefile for Vendorization and Nix Flake Management

.PHONY: all vendorize-repos add-submodules update-flake-nix clean

PROJECT_ROOT := $(shell pwd)

# Define the path to the vendorization script
VEND_SCRIPT := $(PROJECT_ROOT)/source/github/meta-introspector/ai-ml-zk-ops/source/automation/extract_and_vendorize_github_repos.sh

# Define the path to the unique repositories list
UNIQUE_REPOS_FILE := $(PROJECT_ROOT)/index/unique_github_repos.txt

# List of repositories to vendorize (GitHub URLs)
REPOS_TO_VENDORIZE := \
	https://github.com/nix-community/nix-init \
	https://github.com/msteen/nix-prefetch \
	https://github.com/seppeljordan/nix-prefetch-github \
	https://github.com/nix-community/nurl \
	https://github.com/pbogdan/nix-universal-prefetch \
	https://github.com/justinwoo/prefetch-github \
	https://github.com/msteen/nix-upfetch \
	https://github.com/lheckemann/nix-prefetch

# Define the base directory for submodules
SUBMODULE_BASE_DIR := $(PROJECT_ROOT)/vendor/nix

all: vendorize-repos add-submodules update-flake-nix

# Target to run the repository vendorization script
# This script forks the specified GitHub repositories into the meta-introspector organization.
vendorize-repos:
	@echo "[INFO] Populating $(UNIQUE_REPOS_FILE) with repositories to vendorize..."
	@echo "$(REPOS_TO_VENDORIZE)" | tr ' ' '\n' > $(UNIQUE_REPOS_FILE)
	@echo "[INFO] Executing vendorization script: $(VEND_SCRIPT)"
	@$(VEND_SCRIPT)

# Target to add the forked repositories as Git submodules
# Each repository is added under the $(SUBMODULE_BASE_DIR) directory.
add-submodules:
	@echo "[INFO] Adding Git submodules..."
	cd $(SUBMODULE_BASE_DIR) && git submodule add https://github.com/meta-introspector/nix-init nix-init || true
	cd $(SUBMODULE_BASE_DIR) && git submodule add https://github.com/meta-introspector/nix-prefetch nix-prefetch || true
	cd $(SUBMODULE_BASE_DIR) && git submodule add https://github.com/meta-introspector/nix-prefetch-github nix-prefetch-github || true
	cd $(SUBMODULE_BASE_DIR) && git submodule add https://github.com/meta-introspector/nurl nurl || true
	cd $(SUBMODULE_BASE_DIR) && git submodule add https://github.com/meta-introspector/nix-universal-prefetch nix-universal-prefetch || true
	cd $(SUBMODULE_BASE_DIR) && git submodule add https://github.com/meta-introspector/prefetch-github prefetch-github || true
	cd $(SUBMODULE_BASE_DIR) && git submodule add https://github.com/meta-introspector/nix-upfetch nix-upfetch || true
	cd $(SUBMODULE_BASE_DIR) && git submodule add https://github.com/meta-introspector/nix-prefetch nix-prefetch-lheckemann || true
	@echo "[INFO] Git submodules added."

# Target to update vendor/nix/flake.nix with new inputs and outputs
# This step was previously performed manually by the agent.
# For automation, this would involve scripting 'replace' commands or a dedicated Nix tool.
update-flake-nix:
	@echo "[INFO] flake.nix update handled by agent. No automated action for this target."

# Target to clean up generated files
clean:
	@echo "[INFO] Cleaning up generated files..."
	@rm -f $(UNIQUE_REPOS_FILE)
	@echo "[INFO] Cleanup complete."

SYNAPSE_SUBMODULE_PATH := $(PROJECT_ROOT)/09/26/synapse-system

# Target to recover lost work in the synapse submodule
recover-synapse-work:
	@echo "[INFO] Attempting to recover lost work in the synapse submodule..."
	@echo "[INFO] Synapse Submodule Path: $(SYNAPSE_SUBMODULE_PATH)"
	@echo "[INFO] Reviewing Git history for potential lost commits in $(SYNAPSE_SUBMODULE_PATH)..."
	@echo "--------------------------------------------------------------------------------"
	@git -C $(SYNAPSE_SUBMODULE_PATH) log --oneline --graph --all --decorate
	@echo "--------------------------------------------------------------------------------"
	@echo "[INFO] To identify specific file changes, you can use 'git -C $(SYNAPSE_SUBMODULE_PATH) show <commit-hash>'."
	@echo "[INFO] Once filenames are identified, search telemetry logs for their content:"
	@echo "[INFO] Example: grep -F '<filename>' $(PROJECT_ROOT)/logs/telemetry.log"
	@echo "[INFO] Recovery process requires manual inspection of Git history and telemetry logs."

.PHONY: recover-synapse-work
