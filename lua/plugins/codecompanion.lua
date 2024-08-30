-- [nfnl] Compiled from fnl/plugins/codecompanion.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local codecompanion = require("codecompanion")
  local function _2_()
    local adapters = require("codecompanion.adapters")
    return adapters.extend("gemini", {env = {api_key = os.getenv("GEMINI_API_KEY")}})
  end
  codecompanion.setup({strategies = {chat = {adapter = "gemini"}, inline = {adapter = "gemini"}, agent = {adapter = "gemini"}}, adapters = {gemini = _2_}})
  return vim.cmd.cab("cc", "CodeCompanion")
end
return {"olimorris/codecompanion.nvim", dev = true, dependencies = {"nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"}, config = _1_, lazy = false}
