export EDITOR=vim

# PATH
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Oh-My-ZSH
export ZSH="$HOME/.oh-my-zsh"
plugins=(sudo aliases git docker docker-compose node nvm npm)
source $ZSH/oh-my-zsh.sh

# Python
echo 'eval "$(uv generate-shell-completion zsh)"' >> ~/.zshrc
echo 'eval "$(uvx --generate-shell-completion zsh)"' >> ~/.zshrc

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Go
export PATH=$PATH:/usr/local/go/bin

# NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# LSD
alias ls='lsd -A'
alias ll='lsd -lA'
alias lt='lsd --tree'

# LazyDocker & LazyGit
alias ldocker='lazydocker'
alias lgit='lazygit'

# TheFuck
eval $(thefuck --alias)

# Starship
eval "$(starship init zsh)"
