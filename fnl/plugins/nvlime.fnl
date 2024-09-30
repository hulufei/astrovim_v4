{1 :monkoose/nvlime
 :ft "lisp"
 :dependencies [:monkoose/parsley]
 :init (fn []
         (set vim.g.nvlime_config {:implementation "sbcl"
                                   ; :compiler_policy {:DEBUG 3 :SPEED 0}
                                   :cmp {:enabled true}})
         (set vim.g.nvlime_mappings {:lisp {:normal {:load_file "<LocalLeader>sl"
                                                     :repl {:show "<LocalLeader>so"
                                                            :clear "<LocalLeader>sC"}}}})
         (local cmp (require :cmp))
         ;; Note: file-specify cmp override global sources, instead of extending
         (cmp.setup.filetype [:lisp] {:sources [{:name "nvlime"}
                                                {:name "luasnip"}
                                                {:name "buffer"}
                                                {:name "path"}]}))}
