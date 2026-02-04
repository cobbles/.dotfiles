source /usr/share/zsh/scripts/zplug/init.zsh

export PATH=~/.local/bin:$PATH:$GOPATH
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# fzf
source <(fzf --zsh)

# Plugins
zplug 'dracula/zsh', as:theme
zplug zsh-users/zsh-autosuggestions
zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug check || zplug install
zplug load

# keybinds
bindkey -e
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Aliases
alias dcr="docker compose run --rm"

~/.dotfiles/check_for_update

[ -f ~/.zshrc.work ] && source ~/.zshrc.work
