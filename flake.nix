##sudo nixos-rebuild switch --flake .#myNixOS
{
  inputs = {
   nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
   xremap.url = "github:xremap/nix-flake"; # キー設定をいい感じに変更できるツール
   nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # ハードウェア設定のコレクション
  };

  outputs = inputs: {
    nixosConfigurations = {
      myNixOS = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
	specialArgs = {
           inherit inputs; # `inputs = inputs;`と等しい
       };
      };
    };
  };
}
