-- CMake Tools for Neovim
return {
  {
    'Civitasv/cmake-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
      require('cmake-tools').setup {
        cmake_command = 'cmake', -- macOS should already have this if installed
        cmake_build_directory = 'build', -- where build files go
        cmake_generate_options = { '-DCMAKE_EXPORT_COMPILE_COMMANDS=1' },
        cmake_build_options = {},
        cmake_console_size = 10, -- how big build output window is
        cmake_show_console = 'always', -- show console after running
      }
    end,
  },
}
