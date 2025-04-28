{
  description = "This nix flake packages the tools provided by the oso authorization cloud service provider.";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = {flake-parts, ...} @ inputs: let
    oso_cloud_cli_platform_mappings = {
      "aarch64-darwin" = {
        hash = "sha256-ybHZg3tj0dy0St7RtII9ogdv+81nwbzAO4RgQt5oLbE=";
        platform = "mac_osx_arm64";
      };
      "aarch64-linux" = {
        hash = "sha256-dQHKL2yazbUeOuRFAc2+K3fXtauRYiJG9bQZhN8o0So=";
        platform = "linux_arm64";
      };
      "x86_64-darwin" = {
        hash = "sha256-Eo6mkUW1WzHRfFPxrDMwBuCbvenboxNs67mEr6dJwhM=";
        platform = "mac_osx_x86_64";
      };
      "x86_64-linux" = {
        hash = "sha256-XevY5Kc8/0Uk1dyjUK4qQM5LqKwvpA9WLH/oJLiZLYw=";
        platform = "linux_musl";
      };
    };
    oso_cloud_cli_version = "0.28.2";
    oso_dev_server_platform_mappings = {
      "aarch64-darwin" = {
        hash = "sha256-kpPc5X2n9ivNxUjxuM2+itdh+HR3b0YMbZ2dCAm5DM0=";
        platform = "macos-arm64";
      };
      "aarch64-linux" = {
        hash = "sha256-FJvfCefSMXnsyjQzdb38Xydem6NOh03Wr+W23jpnJhk=";
        platform = "linux-arm64";
      };
      "x86_64-darwin" = {
        hash = "sha256-BvWCAEeTKw0Qn3PAG2Ub+HOub+VwOZUDz7RBh6OvEJQ=";
        platform = "macos-x86_64";
      };
      "x86_64-linux" = {
        hash = "sha256-GnWcWaTedFIlo3ZnJ1AvK9DOYu8Ezjs+UvFeJkVEvoU=";
        platform = "linux-x86_64";
      };
    };
    oso_dev_server_version = "1.12.0";
  in
    flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      perSystem = {
        pkgs,
        system,
        ...
      }: {
        # https://www.osohq.com/docs/app-integration/client-apis/cli
        # https://ui.osohq.com/install/?tab=local-binary
        packages.oso_cloud = pkgs.stdenvNoCC.mkDerivation {
          dontUnpack = true;
          installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/oso_cloud
            chmod u=rwx,g=rx,o=rx $out/bin/oso_cloud
          '';
          pname = "oso_cloud";
          src = pkgs.fetchurl {
            hash = oso_cloud_cli_platform_mappings.${system}.hash;
            url = "https://d3i4cc4dqewpo9.cloudfront.net/${oso_cloud_cli_version}/oso_cli_${oso_cloud_cli_platform_mappings.${system}.platform}";
          };
          version = oso_cloud_cli_version;
        };
        # https://www.osohq.com/docs/development/oso-dev-server
        # https://ui.osohq.com/install/?tab=local-binary
        packages.oso_dev_server = pkgs.stdenvNoCC.mkDerivation {
          installPhase = ''
            mkdir -p $out/bin
            cp $src/standalone $out/bin/oso_dev_server
            chmod u=rwx,g=rx,o=rx $out/bin/oso_dev_server
          '';
          pname = "oso_dev_server";
          src = pkgs.fetchzip {
            hash = oso_dev_server_platform_mappings.${system}.hash;
            url = "https://oso-local-development-binary.s3.amazonaws.com/${oso_dev_server_version}/oso-local-development-binary-${oso_dev_server_platform_mappings.${system}.platform}.tar.gz";
          };
          version = oso_dev_server_version;
        };
      };
      systems = ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
    });
}
