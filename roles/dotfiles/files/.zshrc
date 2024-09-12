export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="dracula"

zstyle ':omz:plugins:nvm' lazy yes

plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf nvm)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export JIRA_API_TOKEN=ATATT3xFfGF0-wNbEtNqFLP-OYB-WRPOKRKWkuOqWYGU82cvW47zQ87uv3KyZcniUCO6iaLy8p15H8VA_bnD6zDiIAxrQGWSCNgGgCUJub-1J1jG2ZUxMbKUqG3nT1Q2P2NugdOuHeYS7Sz10OyCMwLP2efDt0Gg1lr0g8TKadxE4ZWTXSGIYng=88976A6D
alias dcr="docker compose run --rm"
