# -*- mode: sh; -*-

# Dracula Theme v1.2.5
#
# https://github.com/dracula/dracula-theme
#
# Copyright 2019, All rights reserved
#
# Code licensed under the MIT license
# http://zenorocha.mit-license.org
#
# @author Zeno Rocha <hi@zenorocha.com>

# Initialization {{{
source ${0:A:h}/lib/async.zsh
autoload -Uz add-zsh-hook
setopt PROMPT_SUBST
async_init
# }}}

# Options {{{
# Set to 1 to show the date
DRACULA_DISPLAY_TIME=${DRACULA_DISPLAY_TIME:-0}

# Set to 1 to show the 'context' segment
DRACULA_DISPLAY_CONTEXT=${DRACULA_DISPLAY_CONTEXT:-0}
# }}}

# Status segment {{{
PROMPT='%(?:%F{green}:%F{red})➜'
# }}}

# Time segment {{{
dracula_time_segment() {
  if (( DRACULA_DISPLAY_TIME )); then
    if [[ -z "$TIME_FORMAT" ]]; then
      TIME_FORMAT="%k:M"
      
      # check if locale uses AM and PM
      if ! locale -c LC_TIME -k | grep 'am_pm=";"'; then
        TIME_FORMAT="%l:%M%p"
      fi
    fi

    print -P "%D{$TIME_FORMAT}"
  fi
}

PROMPT+='%F{green}%B$(dracula_time_segment) '
# }}}

# User context segment {{{
dracula_context() {
  if (( DRACULA_DISPLAY_CONTEXT )); then
    if [[ -n "${SSH_CONNECTION-}${SSH_CLIENT-}${SSH_TTY-}" ]] || (( EUID == 0 )); then
      echo '%n@%m '
    else
      echo '%n '
    fi
  fi
}

PROMPT+='%F{magenta}%B$(dracula_context)'
# }}}

# Directory segment {{{
PROMPT+='%F{blue}%B%c '
# }}}

# Async git segment {{{
dracula_git_status() {
  cd "$1"
  
  local ref branch
  ref=$(git symbolic-ref --quiet HEAD 2>/dev/null)

  case $? in
    0)   ;;
    128) return ;;
    *)   ref=$(git rev-parse --short HEAD 2>/dev/null) || return ;;
  esac

  branch=${ref#refs/heads/}
  
  if [[ -n $branch ]]; then
    echo -n "${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}"

    local git_status icon
    git_status="$(LC_ALL=C =git status 2>&1)"
    
    if [[ "$git_status" =~ 'new file:|deleted:|modified:|renamed:|Untracked files:' ]]; then
      echo -n "$ZSH_THEME_GIT_PROMPT_DIRTY"
    else
      echo -n "$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi

    echo -n "$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

dracula_git_callback() {
  DRACULA_GIT_STATUS="$3"
  zle && zle reset-prompt
  async_stop_worker dracula_git_worker dracula_git_status "$(pwd)"
}

dracula_git_async() {
  async_start_worker dracula_git_worker -n
  async_register_callback dracula_git_worker dracula_git_callback
  async_job dracula_git_worker dracula_git_status "$(pwd)"
}

precmd() {
  dracula_git_async
}

PROMPT+='$DRACULA_GIT_STATUS'

ZSH_THEME_GIT_PROMPT_CLEAN=") %F{green}%B✔ "
ZSH_THEME_GIT_PROMPT_DIRTY=") %F{yellow}%B✗ "
ZSH_THEME_GIT_PROMPT_PREFIX="%F{cyan}%B("
ZSH_THEME_GIT_PROMPT_SUFFIX="%f%b"
# }}}

# Ensure effects are reset
PROMPT+='%f%b'

