# CLI tools and their configs.
{
  config,
  lib,
  pkgs,
  inputs,
  dotfiles,
  ...
}:
let
  # live symlinks into the checkout, so edits apply without a rebuild
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/${path}";
  bin = builtins.attrNames (builtins.readDir ../home/bin/.local/bin);
in
{
  home.username = "tom";
  home.homeDirectory = "/home/tom";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    git
    tmux
    neovim
    fzf
    ripgrep
    fd
    gcc
    gnumake
    unzip
    curl
    lua-language-server
  ];

  home.file = {
    ".zshrc".source = link "zsh/.zshrc";
    ".tmux.conf".source = link "tmux/.tmux.conf";
  }
  // lib.genAttrs (map (name: ".local/bin/${name}") bin) (
    path: { source = link "bin/${path}"; }
  );

  # point ${dotfiles} at wherever the repo is cloned
  home.activation.dotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for dir in "$HOME/personal/.dotfiles" "$HOME/.dotfiles"; do
      if [ -d "$dir/home" ]; then
        run mkdir -p "$(dirname ${dotfiles})"
        run ln -sfn "$dir" ${dotfiles}
        break
      fi
    done
  '';

  xdg.configFile = {
    "nvim".source = link "nvim/.config/nvim";
    "opencode".source = link "opencode/.config/opencode";

    "zsh/plugins.zsh".text = ''
      source ${inputs.dracula-zsh}/dracula.zsh-theme
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    '';

    "tmux/plugins.conf".text = ''
      run-shell ${pkgs.tmuxPlugins.dracula.rtp}
    '';
  };
}
