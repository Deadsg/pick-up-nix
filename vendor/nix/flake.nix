{
  description = "A flake for this submodule, providing a basic development shell.";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
    flake-utils.url = "github:meta-introspector/flake-utils?ref=feature/CRQ-016-nixify";
    nixtract-flake.url = "./nixtract";
    nix-flake.url = "./nix";
    rnix-parser-tester-flake.url = "./rnix-parser-tester";
    renix-flake.url = "./renix";
    nixpkgs-lint-flake.url = "./nixpkgs-lint";
    nil-flake.url = "./nil";
    nix-direnv-flake.url = "./nix-direnv";
    makenix-flake.url = "./MakeNix"; # Added MakeNix
    nix-init-flake.url = "./nix-init";
    nix-prefetch-flake.url = "./nix-prefetch";
    nix-prefetch-github-flake.url = "./nix-prefetch-github";
    nurl-flake.url = "./nurl";
    nix-universal-prefetch-flake.url = "./nix-universal-prefetch";
    prefetch-github-flake.url = "./prefetch-github";
    nix-upfetch-flake.url = "./nix-upfetch";
    nix-prefetch-lheckemann-flake.url = "./nix-prefetch-lheckemann";
  };

  outputs = { self, nixpkgs, flake-utils, nixtract-flake, nix-flake, rnix-parser-tester-flake, renix-flake, nixpkgs-lint-flake, nil-flake, nix-direnv-flake, makenix-flake, ... }@inputs: # Added makenix-flake here
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bash
            git
            shellcheck # Add shellcheck for shell script linting
            # Add any other common tools needed for your submodules here
          ];

          shellHook = ''
            echo "Welcome to the development shell of this submodule!"
          '';
        };
        # Expose the sub-flakes with prime identifiers
        nixtract-flake = nixtract-flake // { meta.primeIdentifier = 2; };
        nix-flake = nix-flake // { meta.primeIdentifier = 3; };
        rnix-parser-tester-flake = rnix-parser-tester-flake // { meta.primeIdentifier = 5; };
        renix-flake = renix-flake // { meta.primeIdentifier = 7; };
        nixpkgs-lint-flake = nixpkgs-lint-flake // { meta.primeIdentifier = 11; };
        nil-flake = nil-flake // { meta.primeIdentifier = 13; };
        nix-direnv-flake = nix-direnv-flake // { meta.primeIdentifier = 17; };
        makenix-flake = makenix-flake // { meta.primeIdentifier = 19; };
        nix-init-flake = nix-init-flake // { meta.primeIdentifier = 23; };
        nix-prefetch-flake = nix-prefetch-flake // { meta.primeIdentifier = 29; };
        nix-prefetch-github-flake = nix-prefetch-github-flake // { meta.primeIdentifier = 31; };
        nurl-flake = nurl-flake // { meta.primeIdentifier = 37; };
        nix-universal-prefetch-flake = nix-universal-prefetch-flake // { meta.primeIdentifier = 41; };
        prefetch-github-flake = prefetch-github-flake // { meta.primeIdentifier = 43; };
        nix-upfetch-flake = nix-upfetch-flake // { meta.primeIdentifier = 47; };
        nix-prefetch-lheckemann-flake = nix-prefetch-lheckemann-flake // { meta.primeIdentifier = 53; };
      }
    );
}
