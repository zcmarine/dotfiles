########################################################################
###################### Set up powerlevel9k prompt ######################
########################################################################
# See how colors would look with:
# for code ({000..255}) print -P -- "$code: %F{$code}This is how your text would look like%f"

ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(time dir custom_virtualenv custom_kube_namespace)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time status vcs vi_mode)

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="↳ "

POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'
POWERLEVEL9K_SHORTEN_DELIMITER=''
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0

POWERLEVEL9K_STATUS_OK=false

POWERLEVEL9K_VI_INSERT_MODE_STRING=''
POWERLEVEL9K_VI_COMMAND_MODE_STRING='VIM-MODE'

POWERLEVEL9K_TIME_BACKGROUND='233'
POWERLEVEL9K_TIME_FOREGROUND='248'

POWERLEVEL9K_DIR_HOME_BACKGROUND='233'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='233'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='233'
POWERLEVEL9K_DIR_HOME_FOREGROUND='248'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='248'
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='248'

get_virtualenv() {
    if [[ -n $VIRTUAL_ENV ]]; then
        echo "ⓔ  $(basename $VIRTUAL_ENV)";
    fi
}

POWERLEVEL9K_CUSTOM_VIRTUALENV="get_virtualenv"
POWERLEVEL9K_CUSTOM_VIRTUALENV_BACKGROUND='124'
POWERLEVEL9K_CUSTOM_VIRTUALENV_FOREGROUND='250'

POWERLEVEL9K_VCS_CLEAN_BACKGROUND='088'
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='254'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='088'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='254'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='053'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='254'

get_k8s_namespace() {
	if [[ $RENDER_POWERLINE_KUBERNETES = "YES" ]]; then
        local current_namespace=$(kubectl config get-contexts| ag '\*' | ag -o '[^ ]*$');
        echo "\U00002388  $current_namespace";
	else
		return
	fi
}

POWERLEVEL9K_CUSTOM_KUBE_NAMESPACE="get_k8s_namespace"
POWERLEVEL9K_CUSTOM_KUBE_NAMESPACE_BACKGROUND="0"
POWERLEVEL9K_CUSTOM_KUBE_NAMESPACE_FOREGROUND="255"

#TODO: move functionality common to both bash_profile and zshrc into one file and source it

########################################################################
###################### Set up zsh functionality ########################
########################################################################

# Path to oh-my-zsh installation
export ZSH=/Users/zmarine/.oh-my-zsh

# If not set, zsh complains about this when entering vim
export TERM="xterm-256color"

# Update zsh every 13 days
export UPDATE_ZSH_DAYS=13

DISABLE_AUTO_TITLE="true"

# Disable marking untracked files under VCS as dirty. This makes repository status
# check for large repositories much, much faster
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Show command execution time in history
HIST_STAMPS="yyyy-mm-dd"

# Note: custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
 fancy-ctrl-z
 jira
 vi-mode
)

export JIRA_DEFAULT_ACTION='dashboard'
source $ZSH/oh-my-zsh.sh


########################################################################
#################### Set up terminal functionality #####################
########################################################################

# Profile largely built off of:
#   - https://github.com/nicolashery/mac-dev-setup
#   - https://github.com/gf3/dotfiles

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

# If holder for sensitive items exists, source it
if [[ -e  $HOME/.bash_sensitive ]] ; then
    source ~/.bash_sensitive
fi

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

# prevent zsh from setting this to page all output regardless of length
unset LESS

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
gc() { git commit $*; }
# gco() { git commit -m "$1"; }
# gcoa() { git commit -am "$1"; }
gch() { git checkout $*; }
gbr() { git branch $*; }
gcd() {
    local cdup=$(git rev-parse --show-cdup);
    if [[ $cdup ]] ; then
        cd "$cdup"
    fi
}

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

kcomplete() { source <(kubectl completion zsh); }

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
    local repo_name=$(basename `git rev-parse --show-toplevel`);
    local relative_path=$(git rev-parse --show-prefix);

    case $repo_name in
        "ansible") local project=SYSTEMS;;
        "dconn"|"easel"|"gsheets"|"analytics-dqis") local project=STRAT;;
        *) local project=DATA;;
    esac;

    local url="$BASE_STASH_URL/projects/$project/repos/$repo_name/browse/$relative_path$1";
    open "$url";
}
