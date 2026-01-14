source /usr/share/zsh/scripts/zplug/init.zsh

export PATH=~/.local/bin:$PATH:$GOPATH

# fzf
source <(fzf --zsh)

# Plugins
zplug 'dracula/zsh', as:theme
zplug zsh-users/zsh-autosuggestions
zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug check || zplug install
zplug load

# Aliases
alias dcr="docker compose run --rm"

~/.dotfiles/check_for_update

[ -f ~/.zshrc.work ] && source ~/.zshrc.work
