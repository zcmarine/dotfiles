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

# If holder for sensitive bash_profile items exists, source it
if [[ -e  $HOME/.bash_sensitive ]] ; then
    source ~/.bash_sensitive
fi

# Use bastion ansible wrapper for SSH 2-factor auth
# if [[ -e  $HOME/repos/bastion/files/ansible-wrapper.sh ]] ; then
#     source $HOME/repos/bastion/files/ansible-wrapper.sh
# fi

# Set up Cmd + back arrow / forward arrow by going to:
#     Go to iTerm2 > Preferences > Profiles > <your_profile > Keys # Click the + button
#     Enter the key combination Cmd+←
#     For the action, choose ‘Send Escape Sequence’ and enter b
#     Repeat with the key combination Cmd+→ and the escape sequence f

# Color scheme for terminal comes from https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/schemes/Zenburn.itermcolors
# Set grep to highlight found patterns

export GREP_OPTIONS='--color=always'

# Create shortcuts
export BI=$HOME/repos/business-intelligence/
export BII=$HOME/repos/business-intelligence/pybi/scripts
export DT=$HOME/repos/dotfiles
export A=$HOME/repos/ansible
export P=$HOME/repos/pyline
export POWERLINE_REPO=~/Library/Python/2.7/lib/python/site-packages/powerline
export KUBE_EDITOR=vim

# Stop kubernetes cluster info from showing up by default
export RENDER_POWERLINE_KUBERNETES=NO

export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible-vault-pw
export TILLER_NAMESPACE=analytics

alias v=/usr/local/bin/vim
alias k=kubectl

# Always use color output for `ls`
alias ls='ls -lG'
alias lsa='ls -laG'

# Create shortcuts for git
alias g='git'
alias gs='git status'
alias gpl='git pull'
alias gps='git push'
alias glo='git log -n 3'
gdi() { git diff $*; }
ga() { git add $*; }
gco() { git commit -m "$1"; }
gcoa() { git commit -am "$1"; }
gch() { git checkout $*; }
gbr() { git branch $*; }
gcd() { cd `git rev-parse --show-cdup`; }

# Set upstream quickly; better just to do gch -bt
# to automatically set up tracking though
gbrsu () {
	local branch_name=$(git rev-parse --abbrev-ref HEAD);
	git branch --set-upstream-to=origin/$branch_name $branch_name;
}

# Easier recursive grepping of repos
grepd() { grep -IRn --exclude-dir={.eggs,.git,.idea,.ipynb_checkpoints,.tox,build,src} "$1" .; }

# Easier recursive searching by filename
findf() { find . -name "*$1*" -type f; }

# Alias for using pypi for pip
pipp() { pip install --user "$1" --index-url=https://pypi.python.org/pypi ; }

tma() { tmux attach -t $1; }
tmn() { tmux new -s $1; }
tmd () { tmux kill-session -t $1; }
tmk () { tmux kill-session -t $1; }
tmls () { tmux ls; }

docker-ip() { docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@"; }
alias docker-rmi='docker rmi $(docker images -f "dangling=true" -q)'
alias docker-rmv='docker volume rm $(docker volume ls -f dangling=true -q)'

ksetnsp() { kubectl config set-context $(kubectl config current-context) --namespace=$1; }
kshow() {
	if [[ $RENDER_POWERLINE_KUBERNETES = "NO" ]]; then
		export RENDER_POWERLINE_KUBERNETES=YES
	else
		export RENDER_POWERLINE_KUBERNETES=NO
	fi
}

# Add tab completion to kubectl; you'll first need to do `brew install bash-completion`
# Note that this only works if you also installed kubectl with brew. If not,
# run `rm $(which kubectl)` and then `brew install kubectl`
kcomplete() {
	if [[ -e $(brew --prefix)/etc/bash_completion ]] ; then
	    source $(brew --prefix)/etc/bash_completion
	    source <(kubectl completion bash)
	fi
}

# Adding this here as I always forget how to install the current kernel into my
# current virtualenv
ipy-kernel-install() {
    if [[ -z $(pip show ipython) ]] ; then
        echo 'ERROR: You must have the ipython library installed'
        return
    fi

    if [[ -z $(pip show jupyter) ]] ; then
        echo 'ERROR: You must have the jupyter library installed'
        return
    fi

    ipython kernel install;
}

open_stash() {
    REPO_NAME=$(basename `git rev-parse --show-toplevel`);
    RELATIVE_PATH=$(git rev-parse --show-prefix);

    case $REPO_NAME in
        "ansible") PROJECT=SYSTEMS;;
        "dconn"|"easel"|"gsheets"|"analytics-dqis") PROJECT=STRAT;;
        *) PROJECT=DATA;;
    esac;

    URL="$BASE_STASH_URL/projects/$PROJECT/repos/$REPO_NAME/browse/$RELATIVE_PATH$1";
    open "$URL";
}


########################################################################
#################### Build out the terminal prompt #####################
########################################################################


# If powerline is installed, use it. Otherwise create a PS1 / PS2 prompt. You can install
# powerline with `pip install --user powerline-status`. More details in .vimrc
# To get the current git branch into the status bar, navigate to
# $HOME/Library/Python/2.7/lib/python/site-packages/powerline/config_files/config.json and
# change the shell theme from "default" to "default_leftonly"
if [[ -e $POWERLINE_REPO ]] ; then
    source $POWERLINE_REPO/bindings/bash/powerline.sh
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


