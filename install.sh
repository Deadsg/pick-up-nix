#!/bin/bash
#
# Installer and setup script for the pick-up-nix project.
# This script ensures all necessary dependencies are met and prepares the
# project for use.

set -e # Exit immediately if a command exits with a non-zero status.

echo "--- Pick-up-Nix Installer ---"
echo ""

# --- Step 1: Prerequisite Verification ---

echo "Step 1: Verifying prerequisites..."

# Check for Nix
if ! command -v nix &> /dev/null; then
    echo "[ERROR] Nix is not installed or not in your PATH."
    echo "Please install Nix by following the instructions at https://nixos.org/download.html"
    echo "After installation, ensure you have enabled the 'flakes' experimental feature."
    echo "Installation failed."
    exit 1
else
    echo "[OK] Nix is found."
fi

# Check for Git
if ! command -v git &> /dev/null; then
    echo "[ERROR] Git is not installed or not in your PATH."
    echo "Please install Git using your system's package manager (e.g., 'sudo apt install git') or from https://git-scm.com/"
    echo "Installation failed."
    exit 1
else
    echo "[OK] Git is found."
fi

echo "All prerequisites are met."
echo ""

# --- Step 2: Project Setup ---

echo "Step 2: Setting up the project..."

echo "Initializing and updating Git submodules. This may take a moment..."
git submodule update --init --recursive
echo "Submodules are up to date."
echo ""

# --- Step 3: Create Entry Point Script ---

echo "Step 3: Creating the 'run.sh' entry point script..."

cat > run.sh <<- 'EOF'
#!/bin/bash
#
# Project Entry Point
#
# This script launches the Nix development shell, providing access to all the
# tools and dependencies defined in flake.nix.

echo "--- Entering Pick-up-Nix Development Environment ---"
echo "All project dependencies are now available in this shell."
echo "You can run project commands, build crates, and use the defined tools."
echo "Type 'exit' to leave the environment."
echo ""

nix develop

EOF

chmod +x run.sh

echo "'run.sh' has been created."
echo ""

# --- Step 4: Finalization ---
echo "--- Installation Complete! ---"
echo ""
echo "The project is now set up."
echo "To start the development environment, run the following command:"
echo ""
echo "  ./run.sh"
echo ""

exit 0
