export PATH=~/.local/bin:$PATH
[[ -n $GOPATH ]] && export PATH=$PATH:$GOPATH
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# fzf
(( $+commands[fzf] )) && source <(fzf --zsh 2>/dev/null)

# Plugins (see wsl/plugins.zsh, nixos/core.nix)
[[ -r ~/.config/zsh/plugins.zsh ]] && source ~/.config/zsh/plugins.zsh

# keybinds
bindkey -e
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Aliases
alias dcr="docker compose run --rm"

(( $+commands[dotfiles-check-update] )) && dotfiles-check-update

[ -f ~/.zshrc.work ] && source ~/.zshrc.work

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
