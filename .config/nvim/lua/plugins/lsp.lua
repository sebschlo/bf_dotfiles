return {
  {
    'neovim/nvim-lspconfig',  -- per-server definitions consumed by vim.lsp.enable
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      vim.diagnostic.config({ virtual_text = true })

      -- built-in completion (nvim 0.11+), auto-triggered as you type
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
          end
        end,
      })

      vim.lsp.enable({
        'pyright',        -- python:  brew install pyright
        'rust_analyzer',  -- rust:    brew install rust-analyzer
        'sourcekit',      -- swift:   ships with Xcode (sourcekit-lsp)
        'ts_ls',          -- ts/js:   brew install typescript-language-server
        'sqlls',          -- sql:     npm install -g sql-language-server
      })
    end,
  },
}
