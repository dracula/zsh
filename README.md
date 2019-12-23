# Dracula for [ZSH](http://zsh.org)

> A dark theme for [ZSH](http://zsh.org).

![Screenshot](./screenshot.png)

## Install

All instructions can be found at [draculatheme.com/zsh](https://draculatheme.com/zsh).

## Configuration
### Time Segment
The time segment shows a clock in either a 12 or 24 hour format
based on your locale. To enable it, use the following in your config file:
```
DRACULA_DISPLAY_TIME=1
```

### Context Segment
The context segment, which shows the username, and, if the user is root or logged in via
SSH, the hostname of the system. To enable this segment, use the following in your config file:
```
DRACULA_DISPLAY_CONTEXT=1
```

### Status Segment Indicator
The status segment indicator (the arrow at the beginning), can be changed by setting the `DRACULA_ARROW_ICON` variable. For example, to use an ASCII '->':
```sh
DRACULA_ARROW_ICON="-> "
```

### Git Locking
This program automatically makes use of git's `--no-optional-locks` option,
and it should automatically detect if your version supports the option. However,
if, for some reason, the automatically detected values are incorrect, you can
forcefully disable or enable the functionality by setting the variable
`DRACULA_GIT_NOLOCK` to 0 or 1, respectively.

## Team

This theme is maintained by the following person(s) and a bunch of [awesome contributors](https://github.com/dracula/zsh/graphs/contributors).

[![Aidan Williams](https://avatars0.githubusercontent.com/u/30708886?s=70)](https://github.com/AGitBoy) |
--- | ---
[Aidan Williams](https://github.com/AGitBoy) |

## License

[MIT License](./LICENSE)
