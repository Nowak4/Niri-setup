-- lua/plugins/telescope.lua

-- 1. Cargar dependencias PRIMERO
vim.cmd.packadd('plenary.nvim')       -- Sin esto, Telescope explota
vim.cmd.packadd('nvim-web-devicons')  -- Opcional, para iconos

-- 2. Cargar Telescope
vim.cmd.packadd('telescope.nvim')

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end
-- 3. Configurar
local builtin = require('telescope.builtin')

require('telescope').setup({
  defaults = {
    -- Aquí tus preferencias, por ejemplo:
    file_ignore_patterns = { ".git/", "node_modules" },
  }
})

-- 4. Tus atajos de teclado
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope Find Files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope Live Grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope Help' })
