# suckless nvim
minimal init.lua. 11 plugins. could reduce more if you really wanted too.

# plugins
- lazy package manager
- nvim-lsp
- blink-cmp
- mason

# requirements
- ripgrep
- gcc or other c compiler needed for treesitter
### optional
- npm. by default there are no lsps installed so only needed if you plan on installing other lsp servers


# bindings

## buffers
- shift + h to move to previous buffer
- shift + l to move to next buffer
- space + bd to close buffer

## telescope
- space + ff for telescope
- space + fg for telescope grep
- space + fr for recent files

## genereal
- alt + left/right/up/down for changing windows size
- control + h/l for moving window ( ie from neovim to filetree)
- space + pl to open lazy
- space + pm to open mason
- control + c to clear highlights
- space + t for floating terminal
- control + n for netrw

## splits
- space + | vertical split
- space + - horizontal split
