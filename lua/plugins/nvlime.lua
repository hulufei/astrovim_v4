-- [nfnl] Compiled from fnl/plugins/nvlime.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  vim.g.nvlime_config = {implementation = "sbcl", cmp = {enabled = true}}
  vim.g.nvlime_mappings = {lisp = {normal = {load_file = "<LocalLeader>sl", repl = {show = "<LocalLeader>so", clear = "<LocalLeader>sC"}}}}
  local cmp = require("cmp")
  return cmp.setup.filetype({"lisp"}, {sources = {{name = "nvlime"}, {name = "luasnip"}, {name = "buffer"}, {name = "path"}}})
end
return {"monkoose/nvlime", ft = "lisp", dependencies = {"monkoose/parsley"}, init = _1_}
