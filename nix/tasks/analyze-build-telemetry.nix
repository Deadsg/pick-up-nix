{
  description = "A task to analyze build-time telemetry log using the log-analysis-pipeline";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
    self.url = "path:../.."; # Reference to the main flake
    build-telemetry-flake.url = "github:meta-introspector/time-2025/09/27/7-concepts/6-qa-testing/tests/2025-01-27-build-time-gemini-capture?ref=feature/vale-precommit";
  };

  outputs = { self, nixpkgs, build-telemetry-flake }:
    let
      system = "x86_64-linux"; # Assuming x86_64-linux, adjust if needed
      pkgs = nixpkgs.legacyPackages.${system};
      mainFlake = self.inputs.self.outputs.packages.${system};

      # Build the buildTimeTelemetry derivation to get its output
      buildTimeTelemetryOutput = build-telemetry-flake.packages.${system}.default;
    in
    {
      packages.${system}.default = mainFlake.log-analysis-pipeline {
        logFile = buildTimeTelemetryOutput + "/logs/build-time-capture.log";
      };
    };
}