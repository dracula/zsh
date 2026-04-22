### [Zsh](https://zsh.org)

This guide assumes you are using [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh).

If `ZSH` is not set in your shell, this guide uses `${HOME}/.oh-my-zsh`.

#### Install with Git (recommended)

1. Clone this repository:

```sh
git clone https://github.com/dracula/zsh.git
```

2. Set the clone location:

```sh
DRACULA_THEME="$PWD/zsh"
```

3. Copy the theme file and the repository `lib` folder to your themes directory:

```sh
cp -r "$DRACULA_THEME/dracula.zsh-theme" "$DRACULA_THEME/lib" "${ZSH:-$HOME/.oh-my-zsh}/themes/"
```

#### Install from ZIP

1. Download and unzip [dracula/zsh](https://github.com/dracula/zsh/archive/master.zip).
2. From the extracted folder, copy `dracula.zsh-theme` to `${ZSH:-$HOME/.oh-my-zsh}/themes/dracula.zsh-theme`.
3. From the extracted folder, copy `lib` to `${ZSH:-$HOME/.oh-my-zsh}/themes/lib`.

> Important: copy only the repository `lib` directory. Do not move your system `/lib` directory.

#### Activate the theme

Open `~/.zshrc` and set:

```sh
ZSH_THEME="dracula"
```

Reload your shell:

```sh
source ~/.zshrc
```

#### Configure the theme

Add any of these variables to `~/.zshrc`.

Basic options:

```sh
# Show git branch and status (1 = on, 0 = off)
DRACULA_DISPLAY_GIT=1

# Show current time
DRACULA_DISPLAY_TIME=0

# Show username and host context
DRACULA_DISPLAY_CONTEXT=0

# Show the path as the full current working directory
DRACULA_DISPLAY_FULL_CWD=0

# Trim the directory path when full cwd is enabled (0 = no trim)
DRACULA_DIR_TRIM=0

# Put command input on a new line
DRACULA_DISPLAY_NEW_LINE=0
```

Extra options:

```sh
# Arrow symbol at the prompt start
DRACULA_ARROW_ICON="-> "

# Time format, for example a 24-hour clock
DRACULA_TIME_FORMAT="%-H:%M"

# Custom text segment
export DRACULA_CUSTOM_VARIABLE="AWS:PROD:EU-WEST-1"
```

Git locking option:

Dracula auto-detects support for `git --no-optional-locks`.
Detection runs when the theme loads using your current `git version`.

```sh
# Force off
DRACULA_GIT_NOLOCK=0

# Force on
DRACULA_GIT_NOLOCK=1
```

Compatibility notes:

- The theme checks multiple locations for `lib/async.zsh` (`$ZSH_CUSTOM`, `$ZSH`, and theme-relative path).
- If async loading fails, only the git segment is disabled and the prompt still works.
- Zsh `5.0.8+` is recommended for best compatibility.

#### Optional: install with [zplug](https://github.com/zplug/zplug)

Add this line to `~/.zshrc`:

```sh
zplug "dracula/zsh", as:theme
```
