# -*- mode: sh; -*-
# vim: set ft=sh :
# Dracula Theme v1.2.6
#
# https://github.com/dracula/dracula-theme
#
# Copyright 2019, All rights reserved
#
# Code licensed under the MIT license
# http://zenorocha.mit-license.org
#
# @author Zeno Rocha <hi@zenorocha.com>
# @maintainer Lucas de França <https://github.com/luxonauta>

# Bootstrap {{{
dracula_source_async() {
	local -a candidate_paths
	local path
	candidate_paths=(
		"${0:A:h}/lib/async.zsh"
		"${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/dracula/lib/async.zsh"
		"${ZSH:-$HOME/.oh-my-zsh}/themes/dracula/lib/async.zsh"
	)

	for path in $candidate_paths; do
		if [[ -r "$path" ]]; then
			source "$path"
			return 0
		fi
	done

	print -u2 -- "dracula theme: unable to load lib/async.zsh, disabling git prompt segment"
	return 1
}

DRACULA_ASYNC_AVAILABLE=1
dracula_source_async || DRACULA_ASYNC_AVAILABLE=0
autoload -Uz add-zsh-hook
setopt PROMPT_SUBST
(( DRACULA_ASYNC_AVAILABLE )) && async_init
PROMPT=''
# }}}

# Configuration {{{
# Set to 0 to disable the git status
DRACULA_DISPLAY_GIT=${DRACULA_DISPLAY_GIT:-1}

# Set to 1 to show the date
DRACULA_DISPLAY_TIME=${DRACULA_DISPLAY_TIME:-0}

# Set to 1 to show the 'context' segment
DRACULA_DISPLAY_CONTEXT=${DRACULA_DISPLAY_CONTEXT:-0}

# Changes the arrow icon
DRACULA_ARROW_ICON=${DRACULA_ARROW_ICON:-➜ }

# Set to 1 to use a new line for commands
DRACULA_DISPLAY_NEW_LINE=${DRACULA_DISPLAY_NEW_LINE:-0}

# Set to 1 to show full path of current working directory
DRACULA_DISPLAY_FULL_CWD=${DRACULA_DISPLAY_FULL_CWD:-0}

# Set to 1 or greater in order to show that many directories in your path prompt
DRACULA_DIR_TRIM=${DRACULA_DIR_TRIM:-0}

# function to detect if git has support for --no-optional-locks
dracula_test_git_optional_lock() {
	local git_version
	git_version=${DEBUG_OVERRIDE_V:-"$(git version | cut -d' ' -f3)"}
	# test for git versions < 2.14.0
	case "$git_version" in
		[0-1].*)
			print 0
			return 1
			;;
		2.[0-9].*)
			print 0
			return 1
			;;
		2.1[0-3].*)
			print 0
			return 1
			;;
	esac

	# if version > 2.14.0 return true
	print 1
}

# use --no-optional-locks flag on git
DRACULA_GIT_NOLOCK=${DRACULA_GIT_NOLOCK:-$(dracula_test_git_optional_lock)}

# time format string
if [[ -z "$DRACULA_TIME_FORMAT" ]]; then
	DRACULA_TIME_FORMAT="%-H:%M"
	# check if locale uses AM and PM
	if locale -ck LC_TIME 2>/dev/null | grep -q '^t_fmt="%r"$'; then
		DRACULA_TIME_FORMAT="%-I:%M%p"
	fi
fi
# }}}

# Prompt segments {{{
# Status arrow {{{
dracula_arrow() {
	if [[ "$1" = "start" ]] && (( ! DRACULA_DISPLAY_NEW_LINE )); then
		print -P -- "$DRACULA_ARROW_ICON"
	elif [[ "$1" = "end" ]] && (( DRACULA_DISPLAY_NEW_LINE )); then
		print -P -- "\n$DRACULA_ARROW_ICON"
	fi
}

# arrow is green if last command was successful, red if not, 
# turns yellow in vi command mode
PROMPT+='%(1V:%F{yellow}:%(?:%F{green}:%F{red}))%B$(dracula_arrow start)'
# }}}

# Time {{{
dracula_time_segment() {
	if (( DRACULA_DISPLAY_TIME )); then
		print -P "%D{$DRACULA_TIME_FORMAT} "
	fi
}

PROMPT+='%F{green}%B$(dracula_time_segment)'
# }}}

# User context {{{
dracula_context() {
	if (( DRACULA_DISPLAY_CONTEXT )); then
		if [[ -n "${SSH_CONNECTION-}${SSH_CLIENT-}${SSH_TTY-}" ]] || (( EUID == 0 )); then
			print -- '%n@%m '
		else
			print -- '%n '
		fi
	fi
}

PROMPT+='%F{magenta}%B$(dracula_context)'
# }}}

# Directory {{{
dracula_directory() {
	if (( DRACULA_DISPLAY_FULL_CWD )); then
		print -P '%${DRACULA_DIR_TRIM}~ '
	else
		print -P '%c '
	fi
}

PROMPT+='%F{blue}%B$(dracula_directory)'
# }}}

# Custom variable {{{
dracula_custom_variable() {
	[[ -z "$DRACULA_CUSTOM_VARIABLE" ]] && return
	print -- "%F{yellow}$DRACULA_CUSTOM_VARIABLE "
}

PROMPT+='$(dracula_custom_variable)'
# }}}

# Git (async) {{{

dracula_git_status() {
	(( ! DRACULA_DISPLAY_GIT )) && return
	builtin cd "$1"
	
	local ref branch lockflag
	
	(( DRACULA_GIT_NOLOCK )) && lockflag="--no-optional-locks"

	ref=$(=git $lockflag symbolic-ref --quiet HEAD 2>/dev/null)

	case $? in
		0)   ;;
		128) return ;;
		*)   ref=$(=git $lockflag rev-parse --short HEAD 2>/dev/null) || return ;;
	esac

	branch=${ref#refs/heads/}
	
	if [[ -n $branch ]]; then
		echo -n "${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}"

		local git_status
		git_status="$(LC_ALL=C =git $lockflag status 2>&1)"
		
		if [[ "$git_status" =~ 'new file:|deleted:|modified:|renamed:|Untracked files:' ]]; then
			print -n -- "$ZSH_THEME_GIT_PROMPT_DIRTY"
		else
			print -n -- "$ZSH_THEME_GIT_PROMPT_CLEAN"
		fi

		print -n -- "$ZSH_THEME_GIT_PROMPT_SUFFIX"
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

if (( DRACULA_ASYNC_AVAILABLE )); then
	add-zsh-hook precmd dracula_git_async
fi

PROMPT+='$DRACULA_GIT_STATUS'

ZSH_THEME_GIT_PROMPT_CLEAN=") %F{green}%B✓ "
ZSH_THEME_GIT_PROMPT_DIRTY=") %F{yellow}%B✗ "
ZSH_THEME_GIT_PROMPT_PREFIX="%F{cyan}%B("
ZSH_THEME_GIT_PROMPT_SUFFIX="%f%b"
# }}}

# Linebreak {{{
PROMPT+='%(1V:%F{yellow}:%(?:%F{green}:%F{red}))%B$(dracula_arrow end)'
# }}}

# ZLE widgets {{{
# define widget without clobbering old definitions
dracula_defwidget() {
	emulate -L zsh
	setopt localoptions nonomatch

	local fname=dracula-wrap-$1
	local prev_line
	local -a prev_words
	local oldfn

	prev_line="$(zle -l -L "$1" 2>/dev/null)"

	# if no existing zle functions, just define it normally
	if [[ -z "$prev_line" ]]; then
		zle -N $1 $2
		return
	fi

	prev_words=(${(z)prev_line})
	oldfn=${prev_words[4]:-$1}

	# if parsing failed, define it normally
	if [[ -z "$oldfn" ]]; then
		zle -N $1 $2
		return
	fi

	# if already defined, return
	[[ "$oldfn" = $fname ]] && return

	zle -N dracula-old-$oldfn $oldfn

	eval "$fname() { $2 \"\$@\"; zle dracula-old-$oldfn -- \"\$@\"; }"

	zle -N $1 $fname
}

# ensure vi mode is handled by prompt
dracula_zle_update() {
	if [[ $KEYMAP = vicmd ]]; then
		psvar[1]=vicmd
	else
		psvar[1]=''
	fi

	zle reset-prompt
	zle -R
}

dracula_defwidget zle-line-init dracula_zle_update
dracula_defwidget zle-keymap-select dracula_zle_update
# }}}

# Ensure effects are reset
PROMPT+='%f%b'
