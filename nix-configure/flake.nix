{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
            pkgs.ripgrep
            pkgs.rustc
            pkgs.mpv
            pkgs.dust
            pkgs.tree
            pkgs.zoxide
            pkgs.atuin
            pkgs.yt-dlp
            pkgs.zsh-autosuggestions
            #pkgs.tailscale
            pkgs.python313Packages.pip
            #python global pkgs
            # pkgs.claude-code
            pkgs.python313Packages.polars
            pkgs.python313Packages.django
            pkgs.zsh-autocomplete
            pkgs.clickhouse
            pkgs.poetry
            pkgs.python313
            pkgs.python311
            pkgs.python310
            pkgs.neovim
            pkgs.nodejs
            pkgs.cmake
            pkgs.python313Packages.pybind11
            pkgs.python313Packages.python-lsp-server
            pkgs.tmux
            pkgs.uv
            pkgs.zsh-syntax-highlighting
            pkgs.autojump
            pkgs.awscli2
            pkgs.R
            pkgs.libgcrypt
            pkgs.tree
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#m1pro
    darwinConfigurations."m1pro" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
