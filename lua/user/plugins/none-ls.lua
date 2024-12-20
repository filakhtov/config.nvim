local function getPluginOpts()
  local null_ls = require('null-ls')

  local sources = {}

  if vim.fn.executable('stylua') == 1 then
    table.insert(sources, null_ls.builtins.formatting.stylua)
  end

  if vim.fn.executable('jsonls') == 1 then
    table.insert(sources, null_ls.builtins.formatting.jsonls)
  end

  if vim.fn.executable('nixfmt') == 1 then
    table.insert(sources, null_ls.builtins.formatting.nixfmt)
  end

  if vim.fn.executable('terraform') == 1 then
    table.insert(sources, null_ls.builtins.formatting.terraform_fmt)
  end

  if vim.fn.executable('revive') == 1 then
    table.insert(sources, null_ls.builtins.diagnostics.revive)
  end

  return {
    sources = sources,
  }
end

return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = getPluginOpts,
}
