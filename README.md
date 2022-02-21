# replace-mode.kak

[kakoune](http://kakoune.org) plugin that adds a Vim-style replace mode.

## Install

If using [plug.kak](https://github.com/andreyorst/plug.kak):
```
plug 'tomKPZ/replace-mode.kak'
```

Otherwise, add `replace-mode.kak` to `~/.config/kak/autoload/`.

## Configuration

```
map global user r ': enter-user-mode replace<ret>' -docstring "replace"
```
