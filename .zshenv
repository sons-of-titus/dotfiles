export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"

export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

#export HOMEBREW_ARTIFACT_DOMAIN_ARIA2C=1
export HOMEBREW_NO_AUTO_UPDATE=1

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk


export PATH="/opt/homebrew/opt/llvm/bin:$PATH"


export HOMEBREW_CURL_RETRIES=5
export HOMEBREW_CURL_SPEED_LIMIT=10        # Accept as low as 10 bytes/sec
export HOMEBREW_CURL_SPEED_TIME=30         # Wait 30 seconds at low speed
export HOMEBREW_CURLRC=/dev/null

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export LC_ALL=en_US.UTF-8

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

alias config='/usr/bin/git --git-dir=/Users/mohamedabdellahi/.dotfiles/ --work-tree=/Users/mohamedabdellahi'
