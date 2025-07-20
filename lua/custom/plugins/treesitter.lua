return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        -- your existing config like ensure_installed, highlight, etc.
        ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        -- List of parsers to ignore installing (or "all")
        ignore_install = { 'javascript' },
        -- Autoinstall languages that are not installed
        highlight = {
          enable = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
        textobjects = {
          move = {
            enable = true,
            set_jumps = false,
            goto_next_start = {
              [']b'] = { query = '@code_cell.inner', desc = 'next code block' },
            },
            goto_previous_start = {
              ['[b'] = { query = '@code_cell.inner', desc = 'previous code block' },
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['ib'] = { query = '@code_cell.inner', desc = 'in block' },
              ['ab'] = { query = '@code_cell.outer', desc = 'around block' },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>sbl'] = '@code_cell.outer',
            },
            swap_previous = {
              ['<leader>sbh'] = '@code_cell.outer',
            },
          },
        },
      }
    end,
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}
