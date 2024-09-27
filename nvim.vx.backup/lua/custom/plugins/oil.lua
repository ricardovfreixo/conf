return {
  'stevearc/oil.nvim',
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    default_file_explorer = true,
  },
  config = function()
    vim.api.nvim_set_keymap('n', '-', [[<cmd>Oil<cr>]], { desc = 'open Oil' })
    require('oil').setup()
  end,
}
