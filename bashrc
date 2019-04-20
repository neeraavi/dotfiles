source ~/.aliases-off
source ~/.exports
source ~/.aliases
source ~/.functions

shopt -s checkwinsize

if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source $HOME/.bash-git-prompt/gitprompt.sh
fi
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
