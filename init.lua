local function noremap(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

noremap('n', 'W', 'b')
noremap('n', ';', ':')
vim.api.nvim_set_keymap('n', 'S', ':%s//g<left><left>', {noremap = true, silent = true})


vim.o.relativenumber = true
undofile = true
