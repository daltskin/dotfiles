alias cls=clear
alias md=mkdir
alias cd..="cd .."

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# helper to reset the marker files to reinstall extensions on reloading the devcontainer
reset-vscode-extensions() { rm ~/.vscode-server/data/Machine/.installExtensionsMarker; rm ~/.vscode-server/data/Machine/.postCreateCommandMarker; }

function set-prompt() { echo -ne '\033]0;' $@ '\a'; }

if [[ $(command -v devcontainerx > /dev/null; echo $?) == 0 ]]; then
    source <(devcontainerx completion bash)
    alias dc=devcontainerx
    complete -F __start_devcontainer dc

    alias dco="devcontainerx open-in-code ."
    alias dce="devcontainerx exec bash"
fi

if [[ $(command -v azbrowse > /dev/null; echo $?) == 0 ]]; then
    source <(azbrowse completion bash)
    alias azb=azbrowse
    complete -F __start_azbrowse azb
fi


if [[ $(command -v kubectl > /dev/null; echo $?) == 0 ]]; then
    alias k=kubectl
    source <(kubectl completion bash)
    complete -F __start_kubectl k
fi

if [[ $(command -v kind > /dev/null; echo $?) == 0 ]]; then
    source <(kind completion bash)
fi


if [[ $(command -v az > /dev/null; echo $?) == 0 ]]; then
    function get-alias() { az ad user list --filter "mail eq '$1'" --query [0].userPrincipalName -o tsv; }
fi

if [[ $(command -v terraform > /dev/null; echo $?) == 0 ]]; then
    alias tf=terraform
fi

if [[ $(command -v gh > /dev/null; echo $?) == 0 ]]; then
    eval "$(gh completion -s bash)"
    
    # Original ghrun alias
    # alias ghrun="gh run list | grep \$(git rev-parse --abbrev-ref HEAD) | cut -d$'\t' -f 8 | xargs gh run watch && notify-send 'Run finished'"
    alias ghrun="$DIR/ghrun.sh"
fi

if gh extension list | grep -q 'github/gh-copilot'; then
    copilot_shell_suggest() { 
        gh copilot suggest -t shell "$@" 
    }
    alias '??'='copilot_shell_suggest'

    copilot_git_suggest() { 
        gh copilot suggest -t git "$@" 
    }
    alias 'git?'='copilot_git_suggest'

    copilot_gh_suggest() {
        gh copilot suggest -t gh "$@"
    }
    alias 'gh?'='copilot_gh_suggest'
fi