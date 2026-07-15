-- save by pressing Escape
vim.keymap.set('n', '<Esc>', ':w<CR>', { desc = 'Save' })
-- select all
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select All' })
-- file picker on ctrl-t, old habit from fzf days
vim.keymap.set('n', '<C-t>', function() Snacks.picker.files() end, { desc = 'Find Files' })
-- pasting over a selection no longer clobbers your clipboard
vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]])

