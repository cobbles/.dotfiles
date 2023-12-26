export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="dracula"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf nvm)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh