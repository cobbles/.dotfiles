export ZSH="$HOME/.oh-my-zsh"

PATH=~/.local/bin:$PATH

ZSH_THEME="dracula"

zstyle ':omz:plugins:nvm' lazy yes

plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf nvm)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

~/.dotfiles/check_for_update

alias dcr="docker compose run --rm"
export PATH="$PATH:$HOME/.dotnet/tools"
