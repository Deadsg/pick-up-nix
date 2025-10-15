# Running Gemini CLI with Nix

This guide provides instructions on how to set up and run the Gemini CLI in a reproducible development environment using Nix.

## Prerequisites

Before you begin, ensure you have the following installed:

*   **Nix:** with Flakes enabled. For more information on how to install and enable flakes, refer to the [official Nix documentation](https://nixos.wiki/wiki/Flakes).
*   **direnv:** (Recommended) for automatically activating the Nix shell when you enter the project directory.

## Setup

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/google-gemini/gemini-cli.git
    cd gemini-cli
    ```

2.  **Enter the Nix Shell:**

    The recommended way to activate the development environment is to use `direnv`. Once you have `direnv` installed and configured, simply run:

    ```bash
    direnv allow
    ```

    This will automatically load the Nix shell whenever you `cd` into the project directory.

    Alternatively, you can manually enter the Nix shell by running:

    ```bash
    nix develop
    ```

## Building the Project

The Gemini CLI is bundled into a single JavaScript file using `esbuild`. The Nix build process relies on this bundle.

1.  **Install Node.js dependencies:**

    ```bash
    npm install
    ```

2.  **Bundle the application:**

    ```bash
    npm run bundle
    ```

    This will create the `bundle/gemini.js` file, which is then used by the Nix build.

3.  **Build the project with Nix:**

    ```bash
    nix build
    ```

    This command will create a `result` symlink in the current directory, which points to the build output in the Nix store.

## Running the Gemini CLI

Once the project is built, you can run the Gemini CLI in several ways:

*   **Using `nix run`:**

    ```bash
    nix run .#gemini -- <args>
    ```

*   **From the build output:**

    ```bash
    ./result/bin/gemini <args>
    ```

## Development Workflow

The Nix development shell provides all the necessary tools for working on the Gemini CLI.

*   **Activate the shell:**

    As mentioned in the setup, use `direnv allow` or `nix develop` to enter the shell.

*   **Available Tools:**

    The shell includes:
    *   Node.js (version from `flake.nix`)
    *   `node2nix`
    *   `statix`

*   **Running Tests:**

    You can run the test suite using the following command:

    ```bash
    npm test
    ```

## Advanced Topics

### `flake.nix` vs. `nix/packages.nix`

This repository contains two main Nix files for packaging the Gemini CLI:

*   **`flake.nix`:** This is the primary, modern way to build the project using Nix Flakes. It provides a reproducible build and development environment.
*   **`nix/packages.nix`:** This file uses the older `buildNpmPackage` function and is likely used for compatibility with non-flake Nix setups.

For most use cases, you should prefer the `flake.nix` setup.

### `node2nix`

The `flake.nix` file uses `node2nix` to handle the Node.js dependencies of the project. This tool generates a Nix expression from the `package.json` file, ensuring that the dependencies are fetched and built in a reproducible way.
