{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      nix.settings.experimental-features = "nix-command flakes";

      nix.gc = {
        automatic = true;
        interval = { Weekday = 7; };
        options = "--delete-older-than 30d";
      };
      nix.optimise.automatic = true;

      programs.zsh.enable = true;
      environment.systemPath = [ "/etc/profiles/per-user/haivo/bin" ];

      users.users.haivo = {
        name = "haivo";
        home = "/Users/haivo";
      };

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;

      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;
    };
  in
  {
    darwinConfigurations."m1pro" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.haivo = import ./home.nix;
        }
      ];
    };
  };
}
