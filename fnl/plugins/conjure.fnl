[
 {1 :Olical/conjure
  :ft ["lua" "fennel" "typescript" "javascript"]
  :config (fn []
           ; Fix conflict: rebind K to <prefix>gk
           (set vim.g.conjure#mapping#doc_word "gk"))}
 {1 :hulufei/conjure-deno :dev false :ft ["typescript" "javascript"]}
]
