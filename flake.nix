{
  description = "CookLang CookCLI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "cook";
          version = "dev";

          src = self;

          cargoHash = "sha256-pe0GU1y6unRozG6XwpWeD8E+fmpWukIIoFCV1hp6VKI=";

          nativeBuildInputs = with pkgs; [
            nodejs_20
          ];

          buildPhase = ''
            npm install
            npm run build-css
            cargo build --release
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp target/release/cook $out/bin/
          '';
        };
      }
    );
}

