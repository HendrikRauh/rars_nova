{
  description = "RARS Nova development environment (JDK 21 + Gradle)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        jdk = pkgs.jdk21;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            jdk
            pkgs.gradle
          ];

          JAVA_HOME = "${jdk}";

          shellHook = ''
            echo "RARS Nova dev shell: $(java -version 2>&1 | head -n1)"
            echo "Build with: ./gradlew shadowJar  (or: gradle shadowJar)"
          '';
        };

        packages.default = pkgs.writeShellApplication {
          name = "rars-nova";
          runtimeInputs = [ jdk pkgs.gradle ];
          text = ''
            set -euo pipefail
            if [ ! -f "build.gradle.kts" ]; then
              echo "rars-nova: run this from the repository root (build.gradle.kts not found in $PWD)" >&2
              exit 1
            fi
            echo "Building RARS Nova..."
            gradle --quiet shadowJar
            JAR="$(find build/libs -maxdepth 1 -name '*.jar' -print -quit)"
            exec java -jar "$JAR" "$@"
          '';
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/rars-nova";
          meta = {
            description = "RARS Nova RISC-V assembler and simulator";
          };
        };
      });
}
