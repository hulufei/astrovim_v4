-- [nfnl] Compiled from fnl/plugins/conjure.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  vim.g["conjure#mapping#doc_word"] = "gk"
  return nil
end
return {{"Olical/conjure", ft = {"lua", "fennel", "typescript", "javascript"}, config = _1_}, {"hulufei/conjure-deno", ft = {"typescript", "javascript"}, dev = false}}
