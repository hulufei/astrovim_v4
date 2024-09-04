return {
  "rebelot/heirline.nvim",
  dependencies = {
    "AstroNvim/astroui",
  },
  opts = function(_, opts)
    local status = require "astroui.status"
    local CodeCompanion = {
      static = {
        processing = false,
      },
      update = {
        "User",
        pattern = "CodeCompanionRequest*",
        callback = function(self, args)
          if args.match == "CodeCompanionRequestStarted" then
            self.processing = true
          elseif args.match == "CodeCompanionRequestFinished" then
            self.processing = false
          end
          vim.cmd "redrawstatus"
        end,
      },
      {
        condition = function(self) return self.processing end,
        provider = " ",
        hl = { fg = "green" },
      },
    }
    -- add time to last mode indicator
    table.insert(opts.statusline, 1, status.component.builder(CodeCompanion))
  end,
}
