(local lisps [:scheme :lisp :clojure :fennel])

[
 {1 :guns/vim-sexp
  :ft lisps
  :init
  (fn []
    ; insert_double_quote in fennel works not well, two options, see
    ; https://github.com/guns/vim-sexp/issues/31
    ; 1. Disable insert mode mappings
    ; 2. Enabled additional_vim_regex_highlighting in fennel
    ; (set vim.g.sexp_enable_insert_mode_mappings 0) 
    (set vim.g.sexp_filetypes "clojure,scheme,lisp,timl,fennel,janet"))}

 {1 :tpope/vim-sexp-mappings-for-regular-people :ft lisps}
]
