# Based on bira theme
setopt prompt_subst

() {

local PR_USER PR_USER_OP PR_PROMPT PR_HOST

# Check the UID
if [[ $UID -ne 0 ]]; then # normal user
  PR_USER='%F{green}%n%f'
  PR_USER_OP='%F{green}%#%f'
  PR_PROMPT='%f➤ %f'
else # root
  PR_USER='%F{red}%n%f'
  PR_USER_OP='%F{red}%#%f'
  PR_PROMPT='%F{red}➤ %f'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  PR_HOST='%F{red}%M%f' # SSH
else
  PR_HOST='%F{green}%M%f' # no SSH
fi


local return_code="%(?..%F{red}%? ↵%f)"

local user_host="${PR_USER}%F{cyan}@${PR_HOST}:"
local current_dir="%B%F{blue}%~%f%b"
local git_branch='$(git_prompt_info)'
local git_status='$(git_prompt_status)'

PROMPT="╭─${user_host} ${current_dir} \$(ruby_prompt_info) ${git_branch} ${git_status}
╰─$PR_PROMPT "
RPROMPT="${return_code}"

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_no_bold[yellow]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{●%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{✚%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}…%f"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg_bold[blue]%}⚑%f"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg_bold[green]%}✔%f"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[red]%}✗%f"
}
