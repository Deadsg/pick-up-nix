# Running gemini-cli with Nix

This guide provides instructions on how to set up and run `gemini-cli` within a Nix environment. Nix is a powerful package manager that allows for reproducible builds and isolated development environments.

## Prerequisites

- You must have a working Nix installation on your system.

## 1. Install Nix

If you don't have Nix installed, you can install it by running the following command in your terminal. This will download and run the official Nix installer.

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
```

## 2. Set up the Nix Environment

After the installation is complete, you need to source the Nix environment script to add `nix` to your shell's `PATH`.

- **For bash users** (the default shell on most Linux distributions):

  ```bash
  . ~/.nix-profile/etc/profile.d/nix.sh
  ```

- **For fish shell users**:

  ```bash
  . ~/.nix-profile/etc/profile.d/nix.fish
  ```

**Note:** You may want to add this line to your shell's startup file (e.g., `~/.bashrc`, `~/.zshrc`, or `~/.config/fish/config.fish`) to make it permanent.

## 3. Build the Project

Navigate to the `gemini-cli` project directory and run the `nix build` command. This will build the project and all its dependencies.

```bash
nix build
```

If your project uses Nix Flakes, you may need to enable experimental features:

```bash
nix --extra-experimental-features flakes --extra-experimental-features nix-command build
```

## 4. Run `gemini-cli`

Once the build is complete, you can run `gemini-cli` in one of two ways:

### Option A: Enter a Development Shell

You can enter a Nix development shell, which will have `gemini-cli` and all its dependencies available in the `PATH`.

```bash
nix develop
```

Or with flakes:

```bash
nix --extra-experimental-features flakes --extra-experimental-features nix-command develop
```

Once you are in the Nix shell, you can run `gemini-cli` directly:

```bash
gemini
```

### Option B: Execute the Binary from the Nix Store

The `nix build` command will create a symbolic link named `result` in your project directory, which points to the build output in the Nix store. You can execute the `gemini` binary directly from there:

```bash
./result/bin/gemini
```

Alternatively, you can find the full path to the binary in the Nix store from the output of the `nix build` command and run it directly. The path will look something like this (the hash will be different):

```bash
/nix/store/bdjrs1k4dimb6zznfg8jmq3109scy63i-gemini-cli-0.8.0-nightly.20250925.b1da8c21/bin/gemini
```
