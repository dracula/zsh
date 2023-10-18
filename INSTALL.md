### [Zsh](http://zsh.org/)

#### Install using Git

If you are a git user, you can install the theme and keep up to date by cloning the repo:

    git clone https://github.com/dracula/zsh.git

And copying the file `dracula.zsh-theme` and the folder `/lib` to [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/)'s theme folder:

    cp -r $DRACULA_THEME/dracula.zsh-theme $DRACULA_THEME/lib $OH_MY_ZSH/themes/dracula.zsh-theme

_P.S.: Remember that you should replace `$DRACULA_THEME` and `$OH_MY_ZSH` with the actual directories for this command to work._

#### Install manually

1.  Download using the [GitHub .zip download](https://github.com/dracula/zsh/archive/master.zip) option and unzip them.
2.  Move `dracula.zsh-theme` file to [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/)'s theme folder: `oh-my-zsh/themes/dracula.zsh-theme`.
3.  Move `/lib` to [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/)'s theme folder: `oh-my-zsh/themes/lib`.

#### Activating theme

Go to your `~/.zshrc` file and set `ZSH_THEME="dracula"`.

Load the new configuration:

    source ~/.zshrc

#### Install using [zplug](https://github.com/zplug/zplug)

Just add `zplug "dracula/zsh", as:theme` to your `~/.zshrc` file.
