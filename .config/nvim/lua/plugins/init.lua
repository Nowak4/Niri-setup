-- This file was automatically created by the NvChad system package
-- to ensure NvChad starts correctly without errors.
--
-- You can add your custom lazy.nvim plugin specifications here.
-- For example:
-- return {
--   { "nvim-lua/plenary.nvim" },
--   -- add more plugins here
-- }
--
-- If you have no custom plugins yet, NvChad requires this file to return an empty table.
return {
  {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  };
 {
    "OXY2DEV/markview.nvim",
    lazy = false,

   -- For `nvim-treesitter` users.
    priority = 49,

    -- For blink.cmp's completion
    -- source
    -- dependencies = {
    --     "saghen/blink.cmp"
    -- },
};
{
  "neovim/nvim-lspconfig",
   config = function()
      require "configs.lspconfig"
      require ("extra.lsp")
   end,
};
  { 
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    } 
  };
  
}



