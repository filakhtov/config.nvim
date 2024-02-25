return function(_, lspconfig, lsp_opts)
  if vim.fn.executable('rust-analyzer') ~= 1 then
    return
  end

  lspconfig.rust_analyzer.setup(vim.tbl_deep_extend('force', lsp_opts or {}, {
    settings = {
      ['rust-analyzer'] = {
        checkOnSave = {
          allFeatures = true,
          overrideCommand = {
            'cargo',
            'clippy',
            '--workspace',
            '--message-format=json',
            '--all-targets',
            '--all-features',
          },
        },
      },
    },
  }))
end
