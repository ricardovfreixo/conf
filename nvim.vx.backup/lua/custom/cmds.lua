local set = vim.opt

set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4

-- restore the session for the current directory
vim.api.nvim_set_keymap('n', '<leader>qs', [[<cmd>lua require("persistence").load()<cr>]], {})

-- restore the last session
vim.api.nvim_set_keymap('n', '<leader>ql', [[<cmd>lua require("persistence").load({ last = true })<cr>]], {})

-- stop Persistence => session won't be saved on exit
vim.api.nvim_set_keymap('n', '<leader>qd', [[<cmd>lua require("persistence").stop()<cr>]], {})

local M = {}

M.general = {
  n = {
    ['<C-h>'] = { '<cmd> TmuxNavigateLeft<CR>', 'window left' },
    ['<C-l>'] = { '<cmd> TmuxNavigateRight<CR>', 'window right' },
    ['<C-j>'] = { '<cmd> TmuxNavigateDown<CR>', 'window down' },
    ['<C-k>'] = { '<cmd> TmuxNavigateUp<CR>', 'window up' },
    ['-'] = { '<CMD>Oil<CR>', 'Open parent directory' },
  },
}

function M.set_keymaps()
  for mode, bindings in pairs(M.general) do
    for key, opts in pairs(bindings) do
      vim.keymap.set(mode, key, opts[1], { desc = opts[2] })
    end
  end
end

M.set_keymaps()

return M
