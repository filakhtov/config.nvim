local namespace = ...

local function find_lang_module_directory()
  local my_directory = debug.getinfo(1, 'S').source:sub(2)

  for _, path in next, vim.api.nvim_get_runtime_file('', false) do
    if my_directory:sub(1, path:len()) == path then
      return my_directory:sub(path:len() + 1, -9)
    end
  end
end

local function load_lang_modules(set_keymap_fn, lspconfig, lsp_opts, dap)
  for _, module_path in
    next,
    vim.api.nvim_get_runtime_file(find_lang_module_directory() .. '*.lua', true)
  do
    local basename = vim.fs.basename(module_path)
    if basename ~= 'init.lua' then
      local module = require(namespace .. '.' .. basename:sub(1, -5))
      module(set_keymap_fn, lspconfig, lsp_opts, dap)
    end
  end
end

local function configLanguages()
  local lspconfig = require('lspconfig')
  local set_buf_keymap_fn = function(bufnr, mode, keymap, action, desc)
    keymap_set(mode, keymap, action, { buffer = bufnr, desc = desc })
  end

  local dap = require('dap')

  -- Enable cmp-nvim-lsp capabilities for LSPs
  local cmp_nvim_lsp = require('cmp_nvim_lsp')
  local lsp_defaults = lspconfig.util.default_config
  lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    cmp_nvim_lsp.default_capabilities()
  )

  -- Enable formatting using LSP
  local lsp_format = require('lsp-format')
  lsp_format.setup({
    sync = true,
  })

  -- Support for context status-line
  local navic = require('nvim-navic')

  local on_attach = function(client, bufnr)
    lsp_format.on_attach(client, bufnr)

    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end

    -- Will be available in Neovim 0.10.x
    -- vim.lsp.inlay_hints(bufnr, true)

    set_buf_keymap_fn(
      bufnr,
      { 'n', 'v' },
      'K',
      vim.lsp.buf.hover,
      ' LSP: show symbol documentation'
    )
    set_buf_keymap_fn(
      bufnr,
      { 'n', 'v' },
      'gd',
      vim.lsp.buf.definition,
      '󰈮 LSP: go to the definition'
    )
    set_buf_keymap_fn(
      bufnr,
      { 'n', 'v' },
      'gD',
      vim.lsp.buf.declaration,
      ' LSP: go to the declaration'
    )
    set_buf_keymap_fn(
      bufnr,
      { 'n', 'v' },
      'gt',
      vim.lsp.buf.type_definition,
      ' LSP: go to the type definition'
    )
    set_buf_keymap_fn(
      bufnr,
      { 'n', 'v' },
      'gr',
      vim.lsp.buf.references,
      ' LSP: Show [r]eferences'
    )
    set_buf_keymap_fn(
      bufnr,
      { 'n', 'v' },
      'gi',
      vim.lsp.buf.implementation,
      ' LSP: Show [i]mplementations'
    )
    set_buf_keymap_fn(
      bufnr,
      { 'n', 'v' },
      'gs',
      vim.lsp.buf.document_symbol,
      ' LSP: Show document [s]ymbols'
    )
    set_buf_keymap_fn(
      bufnr,
      { 'n', 'v' },
      'gS',
      vim.lsp.buf.workspace_symbol,
      ' LSP: Show workspace [s]ymbols'
    )
    set_buf_keymap_fn(
      bufnr,
      { 'n', 'v' },
      'gA',
      vim.lsp.buf.code_action,
      ' LSP: Show code [a]ctions'
    )
    set_buf_keymap_fn(
      bufnr,
      'n',
      '<leader>hs',
      vim.lsp.buf.signature_help,
      '󱜻 LSP: Show singature help'
    )
  end

  -- Load all LSP drop-in configurations
  load_lang_modules(
    set_buf_keymap_fn,
    lspconfig,
    { on_attach = on_attach },
    dap
  )
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'lukas-reineke/lsp-format.nvim',
    },
  },
  {
    'lukas-reineke/lsp-format.nvim',
    version = '^2.6',
  },
  {
    'SmiteshP/nvim-navic',
    opts = {
      highlight = true,
      separator = '  ',
      icons = {
        Module = '󰕳 ',
        Class = ' ',
        Method = '󰰐 ',
        Property = ' ',
        Constructor = '󱥉 ',
        Enum = ' ',
        Interface = ' ',
        Function = '󰊕 ',
        Variable = '󱄑 ',
        Constant = '󰏿 ',
        Struct = ' ',
        Event = ' ',
        Operator = ' ',
        TypeParameter = ' ',
      },
    },
  },
  {
    'nvim-tree/nvim-web-devicons',
  },
  {
    'mfussenegger/nvim-dap',
    version = '^0.7',
  },
  {
    name = 'Language Support',
    dir = '.',
    config = configLanguages,
    dependencies = {
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
    },
  },
}