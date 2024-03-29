local function initTelescope(_, opts)
  local telescope = require('telescope')

  telescope.setup(opts)

  -- show line numbers in the telescope previewer
  vim.api.nvim_create_autocmd('User', {
    pattern = 'TelescopePreviewerLoaded',
    callback = function()
      vim.wo.number = true
    end,
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function()
      local pickers = require('telescope.builtin')

      vim.lsp.buf.references = function()
        pickers.lsp_references({ jump_type = 'never' })
      end
      vim.lsp.buf.implementation = function()
        pickers.lsp_implementations({ jump_type = 'never' })
      end
      vim.lsp.buf.document_symbol = function()
        pickers.lsp_document_symbols()
      end
      vim.lsp.buf.workspace_symbol = function()
        pickers.lsp_dynamic_workspace_symbols()
      end
    end,
  })
end

local function find_files()
  require('telescope.builtin').find_files({ hidden = true })
end

local function show_open_buffers()
  require('telescope.builtin').buffers()
end

local function find_files_including_ignored()
  require('telescope.builtin').find_files({
    hidden = true,
    no_ignore = true,
    no_ignore_parent = true,
  })
end

local function live_grep()
  require('telescope.builtin').live_grep()
end

local function open_last_picker()
  require('telescope.builtin').resume()
end

local function live_grep_current_buffer()
  require('telescope.builtin').current_buffer_fuzzy_find()
end

local function show_jumplist()
  require('telescope.builtin').jumplist()
end

local function show_workspace_diagnostic()
  require('telescope.builtin').diagnostics()
end

local function show_buffer_diagnostic()
  require('telescope.builtin').diagnostics({ bufnr = 0 })
end

local function getPluginOpts()
  local actions = require('telescope.actions')

  return {
    defaults = {
      prompt_prefix = '  ',
      selection_caret = ' ',
      multi_icon = ' ',
      default_mappings = {},
      preview = {
        tresitter = true,
      },
      file_ignore_patterns = {
        '^%.git$',
        '/%.git$',
        '^%.git/',
        '/%.git/',
      },
      mappings = {
        i = {
          ['<esc>'] = actions.close,
          ['<c-n>'] = actions.move_selection_next,
          ['<c-p>'] = actions.move_selection_previous,
          ['<cr>'] = actions.select_default,
          ['<c-u>'] = actions.preview_scrolling_up,
          ['<c-d>'] = actions.preview_scrolling_down,
          -- only in master, will be available in a future release
          -- ['<c-f>'] = actions.preview_scrolling_left,
          -- ['<c-b>'] = actions.preview_scrolling_right,
        },
        n = {
          ['<esc>'] = actions.close,
        },
      },
      layout_strategy = 'vertical',
    },
    pickers = {
      buffers = {
        mappings = {
          i = { ['<c-r>'] = actions.delete_buffer },
        },
      },
    },
  }
end

return {
  'nvim-telescope/telescope.nvim',
  version = '^0.1',
  config = initTelescope,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = getPluginOpts,
  keys = {
    {
      '<leader>ff',
      find_files,
      mode = 'n',
      desc = '󰱽 Telescope: find [f]iles, exclude ignored',
    },
    {
      '<leader>fF',
      find_files_including_ignored,
      mode = 'n',
      desc = '󱈇 Telescope: find [f]iles, include ignored',
    },
    {
      '<leader>fb',
      show_open_buffers,
      mode = { 'n', 'v' },
      desc = ' Telescope: Show open [b]uffers',
    },
    {
      '<leader>ft',
      live_grep,
      mode = { 'n', 'v' },
      desc = '󱎸 Telescope: Live [t]ext grep',
    },
    {
      '<leader>fp',
      open_last_picker,
      mode = { 'n', 'v' },
      desc = '󰮲 Telescope: resume [p]revious picker',
    },
    {
      '<leader>fc',
      live_grep_current_buffer,
      mode = { 'n', 'v' },
      desc = '󰈞 Telescope: [c]urrent buffer fuzzy find',
    },
    {
      '<leader>fd',
      show_buffer_diagnostic,
      mode = { 'n', 'v' },
      desc = '󱥂 Telescope: Show buffer [d]iagnostics',
    },
    {
      '<leader>fD',
      show_workspace_diagnostic,
      mode = { 'n', 'v' },
      desc = '󱥂 Telescope: Show workspace [d]iagnostic',
    },
    {
      '<leader>fj',
      show_jumplist,
      mode = { 'n', 'v' },
      desc = ' Telescope: Show [j]umplist',
    },
  },
}
