# Profile largely built off of:
#   - https://github.com/nicolashery/mac-dev-setup
#   - https://github.com/gf3/dotfiles

########################################################################
#################### Set up terminal functionality #####################
########################################################################

# Add the default install locations for Homebrew and pip --user to `$PATH`
PATH=$HOME/Library/Python/2.7/bin:/usr/local/bin:$PATH
export PATH

# Set up virtualenvwrapper
export WORKON_HOME=$HOME/Envs
source /usr/local/bin/virtualenvwrapper.sh

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
export BI=$HOME/repos/business-intelligence/
export BII=$HOME/repos/business-intelligence/pybi/scripts
export DT=$HOME/repos/dotfiles
export A=$HOME/repos/ansible

# Tell tmux where to put sessions (make it if it doesn't exist)
mkdir -p $HOME/.tmux_sessions/
export TMUX_TMPDIR=$HOME/.tmux_sessions/

alias vim=/usr/local/bin/vim

# Create alias for ls-ing only directories
alias lsd='ls -l | grep "^d"'

# Always use color output for `ls`
alias ls='ls -lG'
alias lsa='ls -laG'

# Create shortcuts for git
alias gs='git status'
alias gpl='git pull'
alias gps='git push'
gd() { git diff "$1"; }
gda() { git diff; }
ga() { git add "$1"; }
gc() { git commit -m "$1"; }
gca() { git commit -am "$1"; }


# If holder for sensitive bash_profile items exists, source it
if [[ -e  $HOME/.bash_sensitive ]] ; then
    source ~/.bash_sensitive
fi

# Easier recursive grepping of repos
grepd() { grep -IR --exclude-dir={.eggs,.git,.idea,.ipynb_checkpoints,.tox,build,src} "$1" .; }

# Use both devpi and pypi for pip
pi() { pip install --index-url=$DEVPI_URL --extra-index-url=https://pypi.python.org/pypi "$1"; }

tma() { tmux attach -t $1; }
tmn() { tmux new -s $1; }
tmd () { tmux kill-session -t $1; }
tmls () { tmux ls; }

docker-ip() { docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@"; }
# Remove all unnamed docker images
alias docker-rmi='docker rmi $(docker images | grep "^<none>" | awk "{print $3}")'

########################################################################
#################### Build out the terminal prompt #####################
########################################################################


# If powerline is installed, use it. Otherwise create a PS1 / PS2 prompt. You can install
# powerline with `pip install --user powerline-status`. More details in .vimrc
# To get the current git branch into the status bar, navigate to
# $HOME/Library/Python/2.7/lib/python/site-packages/powerline/config_files/config.json and
# change the shell theme from "default" to "default_leftonly"
if [[ -e $HOME/Library/Python/2.7/lib/python/site-packages/powerline ]] ; then
    source $HOME/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh
else
    # Build out the non-powerline terminal prompt
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

    export PS1="\[$GREY\]\t | \[$DARK_BLUE\]\u \[$GREY\]at \[$MID_BLUE\]\w \[$GREY\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \"on\") \[$LIGHT_BLUE\]\$(parse_git_branch)\[$GREY\]\n\$ \[$RESET\]"
    export PS2="\[$MID_BLUE\]→ \[$RESET\]"
fi


