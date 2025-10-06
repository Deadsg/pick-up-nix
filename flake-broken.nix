{
  description = "A minimal development environment for Rust projects.";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
    flake-utils.url = "github:meta-introspector/flake-utils?ref=feature/CRQ-016-nixify";
    naersk.url = "github:meta-introspector/naersk?ref=feature/CRQ-016-nixify";
    my-new-flake.url = "./nix/flakes/my-new-flake";
    streamofrandom-log-analyzer.url = "github:meta-introspector/time-2025?ref=feature/vale-precommit&dir=09/27/7-concepts/6-qa-testing/tests/2025-01-27-build-time-gemini-capture";
    nix-stdlib.url = "github:meta-introspector/nix-stdlib?ref=main";
#    template-generator-bin.url = "./tools/template_generator_bin"; # Keep this input
  };

    outputs = { self, nixpkgs, flake-utils, rust-overlay, naersk, my-new-flake, streamofrandom-log-analyzer, nix-stdlib }:
      let
        # Define pkgs here for top-level access
        pkgs = import nixpkgs {
          system = "aarch64-linux"; # Assuming aarch64-linux as the default system
          overlays = [
            rust-overlay.overlays.default
          ];
        };
      in
      {
        default = {
          description = self.description;
          systems = flake-utils.lib.systems;
          # Add other relevant top-level information here
        };

        crqFunctions.search = { system, commitMsgFile ? null }: pkgs.callPackage ./10/04/lib/crq-search.nix { inherit commitMsgFile; pkgs = import nixpkgs { inherit system; }; };

        # The eachDefaultSystem block now defines system-specific outputs
        # and can access the top-level pkgs
        # ... (rest of the outputs block)

  #      logAnalyzer = naerskLib.buildPackage {
#          pname = "log-analyzer";
#          version = "0.1.0";
#          src = ./crates/log_analyzer;
#          cargoLock = {
#            lockFile = ./crates/log_analyzer/Cargo.lock;
#          };
#        };
        packages = { # Re-add the packages section
#            log-analyzer = logAnalyzer;
            my-new-flake = my-new-flake.packages.${system}.default;
            crq-document-check-script = pkgs.runCommand "crq-document-check-instantiate" {
              buildInputs = [ pkgs.jq ];
            } ''
              mkdir -p $out/bin
              echo "#!${pkgs.bash}/bin/bash" > $out/bin/crq-document-check
              echo "set -euo pipefail" >> $out/bin/crq-document-check
              echo "NIX_OUTPUT=$(${pkgs.nix}/bin/nix-instantiate --eval --json ${./10/04/lib/crq-document-check.nix} --argstr commitMsgFile \"\$1\" --arg pkgs \"(import <nixpkgs> {})")" >> $out/bin/crq-document-check
              echo "SUCCESS=$(echo \"\$NIX_OUTPUT\" | ${pkgs.jq}/bin/jq -r '.success')" >> $out/bin/crq-document-check
              echo "MESSAGE=$(echo \"\$NIX_OUTPUT\" | ${pkgs.jq}/bin/jq -r '.message')" >> $out/bin/crq-document-check
              echo "if [ \"\$SUCCESS\" = \"false\" ]; then" >> $out/bin/crq-document-check
              echo "  echo \"\$MESSAGE\" >&2" >> $out/bin/crq-document-check
              echo "  exit 1" >> $out/bin/crq-document-check
              echo "else" >> $out/bin/crq-document-check
              echo "  exit 0" >> $out/bin/crq-document-check
              echo "fi" >> $out/bin/crq-document-check
              chmod +x $out/bin/crq-document-check
            '';
          };

          apps.log-analyzer = flake-utils.lib.mkApp {
            drv = logAnalyzer;
          };

          apps.crq-document-check = flake-utils.lib.mkApp {
            drv = pkgs.runCommand "crq-document-check-instantiate" {} ''
              mkdir -p $out/bin
              echo "#!${pkgs.bash}/bin/bash" > $out/bin/crq-document-check
              echo "exec ${pkgs.nix}/bin/nix-instantiate --eval --json ${./10/04/lib/crq-document-check.nix} --argstr commitMsgFile \"\$1\" --arg pkgs \"(import <nixpkgs> {})\"> /dev/null" >> $out/bin/crq-document-check
              chmod +x $out/bin/crq-document-check
            '';
          };
          devShells.default = pkgs.mkShell {
            buildInputs = [
              pkgs.cargo
              pkgs.rustc
            ];
          };


  
          # Expose the rustVersions for easy access
          inherit rustVersions;
        }
      ;

      crqFunctions.search = { system, commitMsgFile ? null }: pkgs.callPackage ./10/04/lib/crq-search.nix { inherit commitMsgFile; pkgs = import nixpkgs { inherit system; }; };}
