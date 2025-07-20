-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- plugins/quarto.lua

  { 'christoomey/vim-tmux-navigator' },
  { 'NMAC427/guess-indent.nvim' },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- unpack(require 'custom.plugins.lsp'),
  -- unpack(require 'custom.plugins.copilot'),
  -- unpack(require 'custom.plugins.yazi'),
  -- unpack(require 'custom.plugins.comment'),
  -- unpack(require 'custom.plugins.snacks'),
  -- unpack(require 'custom.plugins.blink'),
  -- unpack(require 'custom.plugins.mini'),
  -- unpack(require 'custom.plugins.telescope'),
  -- unpack(require 'custom.plugins.harpoon'),
  -- unpack(require 'custom.plugins.iron'),
  -- unpack(require 'custom.plugins.treesitter'),
}
