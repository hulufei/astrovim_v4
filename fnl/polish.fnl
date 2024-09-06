; This will run last in the setup process and is a good place to configure
; things like custom filetypes. This just pure lua so anything that doesn't
; fit in the normal config locations above can go here

(fn get-input [prompt completion]
  ; Modified get_input to support completion option
  ; https://github.com/kylechui/nvim-surround/blob/main/lua/nvim-surround/input.lua
  (let [(ok result) (pcall vim.fn.input {: prompt
                                         : completion
                                         :cancelreturn vim.NIL})]
    (if (and ok (not= result vim.NIL)) result)))

(fn get-vselect-text []
  ;; Get visual selected text
  ;; Type: nil -> string
  ;; Constraint: only works for one line
  (local (_ row start) (unpack (vim.fn.getpos "'<")))
  (local (_ _ end) (unpack (vim.fn.getcharpos "'>"))) ; End char may be an unicode char
  (local row (- row 1)) ; getpos return index-1 base, nvim_buf_get_text index-0 base
  (local start (- start 1))
  (local end (vim.fn.byteidx
               (unpack (vim.api.nvim_buf_get_lines 0 row (+ row 1) nil))
               end)) ; Convert charidx to byteidx
  (unpack (vim.api.nvim_buf_get_text 0 row start row end [])))

(fn check-list-section [pattern]
  (let [row (. (vim.api.nvim_win_get_cursor 0) 1)
        prev-line-text (vim.fn.getline (- row 1))
        item-match (string.match prev-line-text pattern)]
    (values item-match row)))

(fn insert-list-item []
  (vim.api.nvim_command "startinsert")
  (let [todo-pattern "^%s*%- %[.?%] "
        dash-pattern "^%s*%- "
        star-pattern "^%s*%* "]
    (var (list-item-match row) (check-list-section todo-pattern))
    (when (not list-item-match)
      (set list-item-match (check-list-section dash-pattern))
      (when (not list-item-match)
        (set list-item-match (check-list-section star-pattern))))
    (when list-item-match
      (vim.api.nvim_buf_set_text
        0 (- row 1) 0 (- row 1) 0 [list-item-match])
      (vim.api.nvim_win_set_cursor 0 [row (+ (string.len list-item-match) 1)]))))

(fn markdown-setup []
  (local group (vim.api.nvim_create_augroup "md_augroup" {:clear true}))
  (vim.api.nvim_create_autocmd
    "FileType"
    {:pattern "markdown"
     :group group
     :callback
     (fn [_args]
       (vim.opt_local.formatoptions:append "cmB") ; Make `gw` works for cjk, m - Also break at a multi-byte character above 255.

       ; Insert list items
       (vim.keymap.set
         "i" "<CR>"
         (fn []
           ; Keep default behavior first, using exe to insert <cr> character
           (vim.api.nvim_command "exe 'normal! i\r'")
           (insert-list-item))
         {:buffer true})
       (vim.keymap.set
         "n" "o"
         (fn []
           (vim.api.nvim_command "normal! o")
           (insert-list-item))
         {:buffer true})
       ; -- It basically jumps to the previous spelling mistake [s,
       ; -- then picks the first suggestion 1z=, and then jumps back `]a.
       ; -- The <c-g>u in the middle make it possible to undo the spelling correction quickly.
       (vim.keymap.set "i" "<C-l>" "<c-g>u<Esc>[s1z=`]a<c-g>u")
       ;; Use <tab> to navigate links
       (vim.keymap.set "n" "<tab>" ":call search('\\V](\\.\\+)')<cr>" {:buffer true})
       (vim.keymap.set "n" "<s-tab>" ":call search('\\V](\\.\\+)', 'b')<cr>" {:buffer true})
       (vim.keymap.set "n" "<cr>" 
                       (fn []
                         (local line (vim.fn.getline "."))
                         (local link (string.match line "%b[]%((.-)%)"))
                         (when (and link (not (string.match link "https?://")))
                           (local dir (vim.fn.expand "%:p:h"))
                           (local link (if (not (string.match link "%.md"))
                                         (.. link ".md")
                                         link))
                           (local file (vim.fn.resolve (.. dir "/" link)))
                           (vim.cmd.edit file))
                         )
                       {:buffer true
                        :desc "Basic create on press enter on links"})

       (set vim.opt_local.spell true) ; Enable spell
       (set vim.opt_local.spelllang "en,cjk")
       ;; Coceal code blocks is annoying, so disabled conceal by default
       ; (set vim.opt_local.conceallevel 2) ; Enable conceal

       ; Add surround with link
       ; https://github.com/kylechui/nvim-surround/discussions/53#discussioncomment-3134891
       (local surround (require "nvim-surround"))
       (surround.buffer_setup
         {:surrounds {"l" {:add (fn [] ; [text](link)
                                  (local link (get-input "Enter the link:" "file"))
                                  (if link [["["] [(.. "](" link ")")]]))
                           :find "%b[]%b()"
                           :delete "^(%[)().-(%]%b())()$"
                           :change {:target "^()()%b[]%((.-)()%)$"
                                    :replacement (fn [] [[""] [""]])}}
                      "<cr>" {:add (fn [] ; [text](text-as-link)
                                     (local link (get-vselect-text))
                                     (if link [["["] 
                                               [(.. "](" 
                                                    (string.lower
                                                      (string.gsub link "[%p%s]+" "-")) ; replace punctuations and spaces
                                                    ")")]]))}
                      "s" {:add (fn [] [[:**] [:**]]) ; **strong**
                           :find "%*%*.-%*%*"
                           :delete "^(%*%*)().-(%*%*)()$"}}}))})
  (set vim.opt.shell "fish")
  ; (set vim.o.timeoutlen 150)
  ;; vertical line ruler
  (vim.cmd "
    map ,ch :call SetColorColumn()<CR>
    function! SetColorColumn()
      let col_num = virtcol('.')
      let cc_list = split(&cc, ',')
      if count(cc_list, string(col_num)) <= 0
      execute 'set cc+='.col_num
      else
      execute 'set cc-='.col_num
      endif
    endfunction
    ")
)

(markdown-setup)
