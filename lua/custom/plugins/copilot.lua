return {
  -- Copilot core plugin
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    cmd = 'Copilot',
    build = ':Copilot auth',
    opts = {
      suggestion = { enabled = true },
      panel = { enabled = true },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  -- Copilot Chat interface
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    cmd = { 'CopilotChat', 'CopilotChatToggle' },
    dependencies = {
      'zbirenbaum/copilot.lua',
      'nvim-lua/plenary.nvim',
    },
    opts = {
      show_help = 'yes',
      prompts = {
        Explain = 'Explain this code',
        Review = 'Review this code for issues',
        Refactor = 'Suggest refactors for this code',
      },
    },
    keys = {
      {
        '<leader>cc',
        '<cmd>CopilotChatToggle<cr>',
        desc = 'Toggle Copilot Chat',
      },
    },
  },
}
