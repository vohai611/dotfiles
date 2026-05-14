{ pkgs, lib, ... }: {
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # cli tools
    glab
    pkg-config
    openssl
    bun
    opencode
    go
    ripgrep
    rustup
    mpv
    dust
    tree
    zoxide
    atuin
    yt-dlp
    fd
    chafa
    lua
    gemini-cli
    libgcrypt
    graphviz
    espeak

    # editors / shell
    vim
    neovim
    tmux
    nushell

    # node / web
    nodejs

    # python (version management via uv)
    python313
    uv
    poetry

    # scala
    mill
    sbt
    (lib.lowPrio scala_2_13)
    scala-next

    # build tools
    cmake
    R
    awscli2

    # apps
    sketchybar
    jankyborders
    kitty
    maccy
    bruno
    duckdb

    # zsh plugins (source paths from $NIX_PROFILES or nix store in your zshrc)
    zsh-autosuggestions
    zsh-autocomplete
    zsh-syntax-highlighting

    # fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  programs.home-manager.enable = true;
}
