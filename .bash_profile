# Profile largely built off of:
#   - https://github.com/nicolashery/mac-dev-setup
#   - https://github.com/gf3/dotfiles

######### Set up terminal functionality #########

# Add Homebrew's `/usr/local/bin` and User's `~/bin` to `$PATH`
PATH=/usr/local/bin:$PATH
PATH=$HOME/bin:$PATH
export PATH

# Set up virtualenvwrapper
export WORKON_HOME=$HOME/Envs
source /usr/local/bin/virtualenvwrapper.sh
alias vim=/usr/local/bin/vim

# Load shell dotfiles
#   - ~/.path can be used to extend `$PATH`
#   - ~/.extra can be used for other settings you don’t want to commit
#   Note: only appears that `exports` is necessary here
for file in ~/.{path,exports,functions,extra}; do
  [ -r "$file" ] && source "$file"
done
unset file

# Set grep to highlight found patterns
export GREP_OPTIONS='--color=always'

# Create shortcuts
export BI=/Users/zcmarine/repos/business-intelligence/
export BII=/Users/zcmarine/repos/business-intelligence/pybi/scripts

# Create alias for ls-ing only directories
alias lsd='ls -l | grep "^d"'

# Always use color output for `ls`
alias ls="command ls -G"



######### Build out the terminal prompt #########

function parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}

function parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

export TERM=xterm-256color
export DARK_BLUE=$(tput setaf 033)
export MID_BLUE=$(tput setaf 014)
export LIGHT_BLUE=$(tput setaf 195)
export GREY=$(tput setaf 244)
export RESET=$(tput sgr0)
# export BOLD=$(tput bold)

export PS1="\[$GREY\]\t | \[$DARK_BLUE\]\u \[$GREY\]at \[$MID_BLUE\]\w \[$GREY\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \"on\") \[$LIGHT_BLUE\]\$(parse_git_branch)\[$GREY\]\n\$ \[$RESET\]"
export PS2="\[$MID_BLUE\]→ \[$RESET\]"
