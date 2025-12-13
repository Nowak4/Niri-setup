-- [[ Setting options ]] See `:h vim.o`
-- For more options, you can see `:help option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`

-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

vim.o.number = true
vim.o.relativenumber = false

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
	callback = function()
		vim.o.clipboard = 'unnamedplus'
	end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.bo.buflisted = true
vim.o.ignorecase = false
vim.o.smartcase = true
vim.o.cursorline = false
vim.o.scrolloff = 10
vim.o.list = true
vim.o.confirm = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
-- [[ Set up keymaps ]] See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
-- To open links press gx
-- Oil open split v, h, new tab C-{s,h,t}
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')
vim.keymap.set({ 't', 'i' }, '<C-l>', '<Right>')
vim.keymap.set({ 't', 'i' }, '<C-k>', '<Up>')
vim.keymap.set({ 't', 'i' }, '<C-j>', '<Down>')
vim.keymap.set({ 't', 'i' }, '<C-h>', '<Left>')
vim.keymap.set({ 'n' }, '<Tab>', ':BufferLineCycleNext<CR>')
vim.keymap.set({ 'n' }, '<S-Tab>', ':BufferLineCyclePrev<CR>')
vim.keymap.set({ 'n' }, '<C-A-h>', ':BufferLineMovePrev<CR>')
vim.keymap.set({ 'n' }, '<C-A-l>', ':BufferLineMoveNext<CR>')
vim.keymap.set({ 'n' }, '<C-n>', ':Lexplore<CR>')
vim.keymap.set({ 'n' }, '<ESC>', ':nohlsearch<CR>')
vim.keymap.set({ 'n' }, '<Leader>w', ':w<CR>')
vim.keymap.set({ 'n' }, '<Leader>q', ':q<CR>')
vim.keymap.set({ 'n' }, '<Leader>x', ':bdelete<CR>')
vim.keymap.set({ 'n' }, '<Leader>s', ':update<CR> :source<CR>')
vim.keymap.set({ 'n' }, '<Leader>lf', vim.lsp.buf.format)
vim.keymap.set({ 'n' }, '<Leader>ll', vim.diagnostic.setloclist)
vim.keymap.set({ 'n' }, '<Leader>ff', ':Pick files<CR>')
vim.keymap.set({ 'n' }, '<Leader>o', ':Oil<CR>')
vim.keymap.set({ 'n' }, '<Leader>n', ':tabnew<CR>')
vim.keymap.set({ 'n' }, '<C-i>', '<C-i>')
vim.keymap.set({ 'n' }, '<Leader>t', ':terminal<CR>')
vim.keymap.set({ 'n' }, '<Leader>h', ':hide<CR>')
vim.keymap.set('n', '<leader>bl', ':ls<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>bo', ':ls<CR>:b ', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>bs', ':ls<CR>:botright 10split | b ', { noremap = true, silent = false })

-- [[ Basic Autocommands ]].
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	callback = function()
		vim.hl.on_yank()
	end,
})

-- [[ Create user commands ]]
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
	local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
	local filename = vim.api.nvim_buf_get_name(0)
	print(vim.fn.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }))
end, { desc = 'Print the git blame for the current line' })

-- [[ Add optional packages ]]
-- Nvim comes bundled with a set of packages that are not enabled by
-- default. You can enable any of them by using the `:packadd` command.

-- For example, to add the "nohlsearch" package to automatically turn off search highlighting after
-- 'updatetime' and when going to insert mode
vim.cmd('packadd! nohlsearch')
vim.cmd('packadd! termdebug')

-- [[ Install plugins ]]
-- Nvim functionality can be extended by installing external plugins.
-- One way to do it is with a built-in plugin manager. See `:h vim.pack`.
vim.pack.add({
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/bluz71/vim-moonfly-colors', name = "moonfly" },
	{ src = 'https://github.com/ramojus/mellifluous.nvim',  name = "mellifluous" },
	{ src = 'https://github.com/stevearc/oil.nvim' },
	{ src = 'https://github.com/williamboman/mason.nvim' },
	{ src = 'https://github.com/nvim-mini/mini.pick' },
}
)

require("mason").setup()
require("mini.pick").setup({
    -- Delays (in ms; should be at least 1)
    delay = {
      -- Delay between forcing asynchronous behavior
      async = 10,

      -- Delay between computation start and visual feedback about it
      busy = 50,
    },

    -- Keys for performing actions. See `:h MiniPick-actions`.
    mappings = {
      caret_left  = '<Left>',
      caret_right = '<Right>',

      choose            = '<CR>',
      choose_in_split   = '<C-s>',
      choose_in_tabpage = '<C-t>',
      choose_in_vsplit  = '<C-v>',
      choose_marked     = '<M-CR>',

      delete_char       = '<BS>',
      delete_char_right = '<Del>',
      delete_left       = '<C-u>',
      delete_word       = '<C-w>',

      mark     = '<C-x>',
      mark_all = '<C-a>',

      move_down  = '<C-n>',
      move_start = '<C-g>',
      move_up    = '<C-p>',

      paste = '<C-r>',

      refine        = '<C-Space>',
      refine_marked = '<M-Space>',

      scroll_down  = '<C-f>',
      scroll_left  = '<C-h>',
      scroll_right = '<C-l>',
      scroll_up    = '<C-b>',

      stop = '<Esc>',

      toggle_info    = '<S-Tab>',
      toggle_preview = '<Tab>',
    },

    -- General options
    options = {
      -- Whether to show content from bottom to top
      content_from_bottom = false,

      -- Whether to cache matches (more speed and memory on repeated prompts)
      use_cache = false,
    },

    -- Source definition. See `:h MiniPick-source`.
    source = {
      items = nil,
      name  = nil,
      cwd   = nil,

      match   = nil,
      show    = nil,
      preview = nil,

      choose        = nil,
      choose_marked = nil,
    },

    -- Window related options
    window = {
      -- Float window config (table or callable returning it)
      config = nil,

      -- String to use as caret in prompt
      prompt_caret = '▏',

      -- String to use as prefix in prompt
      prompt_prefix = '> ',
    },
 }
  )



-- require("plugins.telescope")
require("plugins.bufferline")
require("oil").setup()
vim.lsp.enable({ "lua_ls", "tinymist", "clangd", "cssmodules-language-server" })
vim.cmd [[colorscheme mellifluous]]
