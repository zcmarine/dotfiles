source $HOME/.common_rc

# Add tab completion to kubectl; you'll first need to do `brew install bash-completion`
# Note that this only works if you also installed kubectl with brew. If not,
# run `rm $(which kubectl)` and then `brew install kubectl`
kcomplete() {
	if [[ -e $(brew --prefix)/etc/bash_completion ]] ; then
	    source $(brew --prefix)/etc/bash_completion
	    source <(kubectl completion bash)
	fi
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
