local function noremap(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

noremap('n', 'W', 'b')
noremap('n', ';', ':')
noremap('n', 'x', '"_x')
noremap('n', 'c', '"_c')
noremap('n', 'd', '"_d')
noremap('v', 'd', '"_d')
noremap('v', 'c', '"_c')

vim.api.nvim_set_keymap('n', 'S', ':%s//g<left><left>', {noremap = true, silent = true})

vim.o.relativenumber = true
undofile = true
