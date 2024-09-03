-- [nfnl] Compiled from fnl/plugins/sexp.fnl by https://github.com/Olical/nfnl, do not edit.
local lisps = {"scheme", "lisp", "clojure", "fennel"}
local function _1_()
  vim.g.sexp_filetypes = "clojure,scheme,lisp,timl,fennel,janet"
  return nil
end
return {{"guns/vim-sexp", ft = lisps, init = _1_}, {"tpope/vim-sexp-mappings-for-regular-people", ft = lisps}}
