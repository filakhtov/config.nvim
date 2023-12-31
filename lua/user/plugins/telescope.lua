local function actions()
  return require('telescope.actions')
end

local function action_close(...)
  actions().close(...)
end

local function action_move_selection_next(...)
  actions().move_selection_next(...)
end

local function action_move_selection_prev(...)
  actions().move_selection_previous(...)
end

local function action_select_default(...)
  actions().select_default(...)
end

local function action_preview_scroll_up(...)
  actions().preview_scrolling_up(...)
end

local function action_preview_scroll_down(...)
  actions().preview_scrolling_down(...)
end

local function action_delete_buffer(...)
  actions().delete_buffer(...)
end

local function initTelescope(_, opts)
  local telescope = require('telescope')
  local pickers = require('telescope.builtin')
  local actions = require('telescope.actions')
  local state = require('telescope.actions.state')

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

return {
  'nvim-telescope/telescope.nvim',
  version = '^0.1',
  config = initTelescope,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
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
          ['<esc>'] = action_close,
          ['<c-n>'] = action_move_selection_next,
          ['<c-p>'] = action_move_selection_prev,
          ['<cr>'] = action_select_default,
          ['<c-u>'] = action_preview_scroll_up,
          ['<c-d>'] = action_preview_scroll_down,
          -- only in master, will be available in a future release
          -- ['<c-f>'] = actions.preview_scrolling_left,
          -- ['<c-b>'] = actions.preview_scrolling_right,
        },
        n = {
          ['<esc>'] = action_close,
        },
      },
      layout_strategy = 'vertical',
    },
    pickers = {
      buffers = {
        mappings = {
          i = { ['<c-r>'] = action_delete_buffer },
        },
      },
    },
  },
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
