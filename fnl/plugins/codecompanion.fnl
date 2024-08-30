{
 1 :olimorris/codecompanion.nvim
 :lazy false
 :dev true
 :dependencies ["nvim-lua/plenary.nvim" "nvim-treesitter/nvim-treesitter"]
 :config
 (fn []
   (local codecompanion (require :codecompanion))
   (codecompanion.setup
     {:strategies {:chat {:adapter "gemini"}
                   :inline {:adapter "gemini"}
                   :agent {:adapter "gemini"}}
      :adapters
      {:gemini
       (fn []
         (let [adapters (require "codecompanion.adapters")]
           (adapters.extend
             "gemini" {:env {:api_key (os.getenv "GEMINI_API_KEY")}})))}
      })
   ; Expand 'cc' into 'CodeCompanion' in the command line
   (vim.cmd.cab :cc :CodeCompanion))
 }
