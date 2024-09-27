return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap, dapui = require 'dap', require 'dapui'
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
    vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint, { desc = '[D]ebug breakpoint [t]oggle' })
    vim.keymap.set('n', '<Leader>dc', dap.continue, { desc = '[D]ebug [c]ontinue' })
    vim.keymap.set('n', '<Leader>dk', dap.terminate, { desc = 'Terminate debug session' })

    require('dap-python').setup '/home/vx/.virtualenvs/debugpy/bin/python'
  end,
}
