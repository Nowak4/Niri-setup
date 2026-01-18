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
vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
-- [[ Set up keymaps ]] See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
-- To open links press gx
-- To close all folds zM, to open zR, zm and zr to open and close partially, zo (open) and zO (open fully) and zc (close) and zC (close fully) for singular folds
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
vim.keymap.set({ 'n' }, '<Leader>e', ':Oil<CR>')
vim.keymap.set({ 'n' }, '<Leader>n', ':tabnew<CR>')
vim.keymap.set({ 'n' }, '<C-i>', '<C-i>')
vim.keymap.set({ 'n' }, '<Leader>t', ':terminal<CR>')
vim.keymap.set({ 'n' }, '<Leader>h', ':hide<CR>')
vim.keymap.set('n', '<leader>bl', ':ls<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>bo', ':ls<CR>:b ', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>bs', ':ls<CR>:botright 10split | b ', { noremap = true, silent = false })
vim.keymap.set("n", "<leader>cd", ":tcd %:p:h<CR>", { desc = "Cambiar directorio al archivo actual" })
vim.keymap.set('n', '<Leader>o', "o<Esc>", { desc = 'Nueva línea abajo' })
vim.keymap.set('n', '<Leader>O', "O<Esc>", { desc = 'Nueva línea arriba' })
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
	{ src = 'https://github.com/ramojus/mellifluous.nvim',  name = "mellifluous" },
	{ src = 'https://github.com/stevearc/oil.nvim' },
	{ src = 'https://github.com/williamboman/mason.nvim' },
	{ src = 'https://github.com/nvim-mini/mini.pick' },
	{ src = 'https://github.com/nvim-mini/mini.move' },
	{ src = 'https://github.com/nvim-mini/mini.clue' },
	{ src = 'https://github.com/nvim-mini/mini.surround' },
	{ src = 'https://github.com/akinsho/bufferline.nvim' },
	{ src = 'https://github.com/kevinhwang91/nvim-ufo' },
	{ src = 'https://github.com/kevinhwang91/promise-async' },
	{ src = 'https://github.com/neoclide/coc.nvim' },
	{ src = 'https://github.com/jaimecgomezz/here.term' },
	{ src = 'https://github.com/elkowar/yuck.vim' },
	{ src = 'https://github.com/NvChad/nvim-colorizer.lua' },
}
)

require("colorizer").setup()
require("mason").setup()
require("here-term").setup({
	-- The command we run when exiting the terminal and no other buffers are listed. An empty
	-- buffer is shown by default.
	startup_command = "enew", -- Startify, Dashboard, etc. Make sure it has been loaded before `here.term`.

	-- Mappings
	-- Every mapping bellow can be customized by providing your preferred combo, or disabled
	-- entirely by setting them to `nil`.
	--
	-- The minimal mappings used to toggle and kill the terminal. Available in
	-- `normal` and `terminal` mode.
	mappings = {
		enable = true,
		toggle = "<C-,>",
		kill = "<C-A-,>",
	},
	-- Additional mappings that I consider useful since you won't have to escape (<C-\><C-n>)
	-- the terminal each time. Available in `terminal` mode.
	extra_mappings = {
		enable = true, -- Disable them entirely
		escape = "<C-x>", -- Escape terminal mode
		left = "<C-w>h", -- Move to the left window
		down = "<C-w>j", -- Move to the window down
		up = "<C-w>k", -- Move to the window up
		right = "<C-w>l", -- Move to right window
	},
})
require("ufo").setup()
vim.keymap.set('n', '+', require('ufo').openAllFolds)
vim.keymap.set('n', '`', require('ufo').closeAllFolds)
require("oil").setup()
vim.lsp.enable({ "lua_ls", "tinymist", "clangd", "cssmodules-language-server"})
vim.cmd [[colorscheme mellifluous]]

require("mini.surround").setup({
	-- Add custom surroundings to be used on top of builtin ones. For more
	-- information with examples, see `:h MiniSurround.config`.
	custom_surroundings = nil,

	-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
	highlight_duration = 500,

	-- Module mappings. Use `''` (empty string) to disable one.
	mappings = {
		add = 'sa',  -- Add surrounding in Normal and Visual modes
		delete = 'sd', -- Delete surrounding
		find = 'sf', -- Find surrounding (to the right)
		find_left = 'sF', -- Find surrounding (to the left)
		highlight = 'sh', -- Highlight surrounding
		replace = 'sr', -- Replace surrounding

		suffix_last = 'l', -- Suffix to search with "prev" method
		suffix_next = 'n', -- Suffix to search with "next" method
	},

	-- Number of lines within which surrounding is searched
	n_lines = 40,

	-- Whether to respect selection type:
	-- - Place surroundings on separate lines in linewise mode.
	-- - Place surroundings on each line in blockwise mode.
	respect_selection_type = false,

	-- How to search for surrounding (first inside current line, then inside
	-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
	-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
	-- see `:h MiniSurround.config`.
	search_method = 'cover',

	-- Whether to disable showing non-error feedback
	-- This also affects (purely informational) helper messages shown after
	-- idle time if user input is required.
	silent = false,
}
)
require("mini.move").setup()
require("mini.clue").setup({
	triggers = {
		-- Leader triggers
		{ mode = 'n', keys = '<Leader>' },
		{ mode = 'x', keys = '<Leader>' },

		-- `[` and `]` keys
		{ mode = 'n', keys = '[' },
		{ mode = 'n', keys = ']' },

		-- Built-in completion
		{ mode = 'i', keys = '<C-x>' },

		-- `g` key
		{ mode = 'n', keys = 'g' },
		{ mode = 'x', keys = 'g' },

		-- Marks
		{ mode = 'n', keys = "'" },
		{ mode = 'n', keys = '`' },
		{ mode = 'x', keys = "'" },
		{ mode = 'x', keys = '`' },

		-- Registers
		{ mode = 'n', keys = '"' },
		{ mode = 'x', keys = '"' },
		{ mode = 'i', keys = '<C-r>' },
		{ mode = 'c', keys = '<C-r>' },

		-- Window commands
		{ mode = 'n', keys = '<C-w>' },

		-- `z` key
		{ mode = 'n', keys = 'z' },
		{ mode = 'x', keys = 'z' },
	},
})
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
		caret_left        = '<Left>',
		caret_right       = '<Right>',

		choose            = '<CR>',
		choose_in_split   = '<C-s>',
		choose_in_tabpage = '<C-t>',
		choose_in_vsplit  = '<C-v>',
		choose_marked     = '<M-CR>',

		delete_char       = '<BS>',
		delete_char_right = '<Del>',
		delete_left       = '<C-u>',
		delete_word       = '<C-w>',

		mark              = '<C-x>',
		mark_all          = '<C-a>',

		move_down         = '<C-n>',
		move_start        = '<C-g>',
		move_up           = '<C-p>',

		paste             = '<C-r>',

		refine            = '<C-Space>',
		refine_marked     = '<M-Space>',

		scroll_down       = '<C-f>',
		scroll_left       = '<C-h>',
		scroll_right      = '<C-l>',
		scroll_up         = '<C-b>',

		stop              = '<Esc>',

		toggle_info       = '<S-Tab>',
		toggle_preview    = '<Tab>',
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
		items         = nil,
		name          = nil,
		cwd           = nil,

		match         = nil,
		show          = nil,
		preview       = nil,

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
require("bufferline").setup({

	options = {
		numbers = "none",
		close_command = "bdelete! %d",
		right_mouse_command = nil,
		left_mouse_command = "buffer %d",
		middle_mouse_command = nil,
		indicator = {
			icon = "▎", -- this should be omitted if indicator style is not 'icon'
			style = "icon",
		},
		buffer_close_icon = "",
		modified_icon = "●",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 18,
		max_prefix_length = 15,
		tab_size = 10,
		diagnostics = false,
		custom_filter = function(bufnr)
			-- if the result is false, this buffer will be shown, otherwise, this
			-- buffer will be hidden.

			-- filter out filetypes you don't want to see
			local exclude_ft = { "qf", "fugitive", "git" }
			local cur_ft = vim.bo[bufnr].filetype
			local should_filter = vim.tbl_contains(exclude_ft, cur_ft)

			if should_filter then
				return false
			end

			return true
		end,
		show_buffer_icons = false,
		show_buffer_close_icons = true,
		show_close_icon = true,
		show_tab_indicators = true,
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		separator_style = "bar",
		enforce_regular_tabs = false,
		always_show_bufferline = true,
		sort_by = "id",
	},
})
