-- Description: Configuration for the Comment.nvim plugin
-- This plugin provides easy commenting functionality in Neovim.
return {
  {
    -- KEYMAPPINGS
    -- <leader>cc : Toggle line comment
    -- <leader>bc : Toggle block comment
    -- <leader>c  : Operator-pending line comment
    -- <leader>b  : Operator-pending block comment
    -- gcO        : Add comment on the line above
    -- gco        : Add comment on the line below
    -- gcA        : Add comment at end of line

    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---Lines to be ignored while (un)comment
        ---LHS of toggle mappings in NORMAL mode
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        ---LHS of extra mappings
        extra = {
          ---Add comment on the line above
          above = 'gcO',
          ---Add comment on the line below
          below = 'gco',
          ---Add comment at the end of line
          eol = 'gcA',
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
          ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
          basic = true,
          ---Extra mapping; `gco`, `gcO`, `gcA`
          extra = true,
        },
        ---Function to call before (un)comment
        pre_hook = nil,
        ---Function to call after (un)comment
        post_hook = nil,
        ignore = '^$',
        toggler = {
          line = '<leader>cc',
          block = '<leader>bc',
        },
        opleader = {
          line = '<leader>c',
          block = '<leader>b',
        },
      }
    end,
  },
}
