export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="dracula"

zstyle ':omz:plugins:nvm' lazy yes

plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf nvm)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
