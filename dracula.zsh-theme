# Dracula Theme v1.2.5
#
# https://github.com/dracula/dracula-theme
#
# Copyright 2016, All rights reserved
#
# Code licensed under the MIT license
# http://zenorocha.mit-license.org
#
# @author Zeno Rocha <hi@zenorocha.com>

# Set dracula display time to 0 to hide the date
DRACULA_DISPLAY_TIME=${DRACULA_DISPLAY_TIME:-0}

# locale specific time format
dracula_time_segment() {
  if (( DRACULA_DISPLAY_TIME )); then
    local time_fmt="%D{%l:%M%p}"
    
    if locale -c LC_TIME -k | grep 'am_pm=";"'; then
      time_fmt="%D{%k:M}"
    fi

    print -n $time_fmt
  fi
}

# Slightly faster git_prompt_info when not in a git repo
# Note that this is a stand-in improvement until I get async implemented.
dracula_git_segment() {
  [[ -d ./.git ]] && git_prompt_info
}

local ret_status="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)"

PROMPT='${ret_status}%{$fg_bold[green]%}$(dracula_time_segment) %{$fg_bold[blue]%}%c $(dracula_git_segment)% %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_CLEAN=") %{$fg_bold[green]%}✔ "
ZSH_THEME_GIT_PROMPT_DIRTY=") %{$fg_bold[yellow]%}✗ "
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

# vim: set filetype=zsh :
