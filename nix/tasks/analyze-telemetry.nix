{
  description = "A task to analyze telemetry.log using the log-analysis-pipeline";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
    self.url = "path:../.."; # Reference to the main flake
    streamofrandom-log-analyzer.url = "github:meta-introspector/streamofrandom/2025/09/25/log_analyzer?ref=feature/CRQ-016-nixify";
  };

  outputs = { self, nixpkgs, streamofrandom-log-analyzer }:
    let
      system = "x86_64-linux"; # Assuming x86_64-linux, adjust if needed
      pkgs = nixpkgs.legacyPackages.${system};
      mainFlake = self.inputs.self.outputs.packages.${system};
    in
    {
      packages.${system}.default = mainFlake.log-analysis-pipeline {
        logFile = streamofrandom-log-analyzer.src + "/logs/telemetry.log";
      };
    };
}