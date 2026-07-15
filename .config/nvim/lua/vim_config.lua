local o = vim.opt
vim.g.mapleader = ' '          -- space is the leader key
o.expandtab = true             -- spaces, not tabs
o.shiftwidth = 2               -- 2 spaces per indent level
o.number = true                -- absolute number on the cursor line, relative elsewhere
o.relativenumber = true        -- relative line numbers for fast jumps
o.ignorecase = true            -- search is case-insensitive by default
o.smartcase = true             -- case-sensitive only if i type a capital
o.clipboard = 'unnamedplus'    -- share the system clipboard
o.scrolloff = 16               -- keep cursor away from the screen edge
o.undofile = true              -- persistent undo across sessions
o.mouse = 'a'                  -- mouse on, as in the old config

-- carried over from the old init.vim
o.tabstop = 2                  -- tabs render 2 wide
o.softtabstop = 2
o.swapfile = false             -- no swap files; undofile covers crashes
o.list = true                  -- make stray whitespace visible...
o.listchars = { tab = '  ', trail = '·' }  -- ...trailing spaces show as ·
o.linebreak = true             -- wrap lines at convenient points
o.sidescrolloff = 15
o.foldmethod = 'indent'        -- fold based on indent...
o.foldnestmax = 3              -- ...max 3 levels deep...
o.foldenable = false           -- ...and nothing folded until asked

