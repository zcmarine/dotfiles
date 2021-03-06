# zsh Initial Setup:
# 1. Install zsh and set it as your default shell
#     - brew install zsh zsh-completions
#     - Change iTerm2 shell settings
#           - Go to iTerm2 -> Preferences -> Profiles -> Default -> General Tab
#             and set the command to /usr/local/bin/zsh instead of Login shell
# 2. Install oh-my-zsh
#     - follow the instructions here: https://github.com/robbyrussell/oh-my-zsh
# 3. Install powerlevel9k
#     - git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
#
# If you have issues with git auto-completion, try the following:
#     $ brew uninstall git
#     $ brew install git --without-completions

########################################################################
###################### Set up powerlevel9k prompt ######################
########################################################################
# See how colors would look with:
# for code ({000..255}) print -P -- "$code: %F{$code}This is how your text would look like%f"

ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(time dir vcs custom_virtualenv custom_kube_namespace)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time status vi_mode)

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="↳ "

POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'
POWERLEVEL9K_SHORTEN_DELIMITER=''
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

POWERLEVEL9K_VCS_CLEAN_BACKGROUND='088'
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='254'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='088'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='254'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='053'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='254'

POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0

POWERLEVEL9K_STATUS_OK=false

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
POWERLEVEL9K_CUSTOM_VIRTUALENV_FOREGROUND='253'

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

POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND="236"
POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND="236"
POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND="190"
POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND="236"
POWERLEVEL9K_VI_INSERT_MODE_STRING=''
POWERLEVEL9K_VI_COMMAND_MODE_STRING='VIM'


########################################################################
###################### Set up zsh functionality ########################
########################################################################

export SHELL=$(which zsh)

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
 jira
 vi-mode
)

export JIRA_DEFAULT_ACTION='dashboard'
source $ZSH/oh-my-zsh.sh


########################################################################
#################### Set up terminal functionality #####################
########################################################################

source $HOME/.common_rc

# Add tab completion to kubectl; you'll first need to do `brew install zsh-completions`
kcomplete() { source <(kubectl completion zsh); }

# prevent zsh from setting this to page all output regardless of length
unset LESS
