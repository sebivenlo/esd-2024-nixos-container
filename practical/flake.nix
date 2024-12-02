{
  description = "Flake for nixos-container";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";  # Change to "aarch64-linux"if Apple M Chip
    pkgs = import nixpkgs { inherit system; };
  in {
    defaultPackage.${system} = pkgs.buildEnv {
      name = "tools";
      paths = with pkgs; [
        cowsay
        vim
      ];
    };
  };
}

