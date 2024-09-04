-- [nfnl] Compiled from fnl/polish.fnl by https://github.com/Olical/nfnl, do not edit.
local function get_input(prompt, completion)
  local ok, result = pcall(vim.fn.input, {prompt = prompt, completion = completion, cancelreturn = vim.NIL})
  if (ok and (result ~= vim.NIL)) then
    return result
  else
    return nil
  end
end
local function get_vselect_text()
  local _, row, start = unpack(vim.fn.getpos("'<"))
  local _0, _1, _end = unpack(vim.fn.getcharpos("'>"))
  local row0 = (row - 1)
  local start0 = (start - 1)
  local _end0 = vim.fn.byteidx(unpack(vim.api.nvim_buf_get_lines(0, row0, (row0 + 1), nil)), _end)
  return unpack(vim.api.nvim_buf_get_text(0, row0, start0, row0, _end0, {}))
end
local function markdown_setup()
  local group = vim.api.nvim_create_augroup("md_augroup", {clear = true})
  local function _2_(_args)
    vim.opt_local.formatoptions:append("cmB")
    vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u")
    vim.keymap.set("n", "<tab>", ":call search('\\V](\\.\\+)')<cr>", {buffer = true})
    vim.keymap.set("n", "<s-tab>", ":call search('\\V](\\.\\+)', 'b')<cr>", {buffer = true})
    local function _3_()
      local line = vim.fn.getline(".")
      local link = string.match(line, "%b[]%((.-)%)")
      if (link and not string.match(link, "https?://")) then
        local dir = vim.fn.expand("%:p:h")
        local link0
        if not string.match(link, "%.md") then
          link0 = (link .. ".md")
        else
          link0 = link
        end
        local file = vim.fn.resolve((dir .. "/" .. link0))
        return vim.cmd.edit(file)
      else
        return nil
      end
    end
    vim.keymap.set("n", "<cr>", _3_, {buffer = true, desc = "Basic create on press enter on links"})
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en,cjk"
    local surround = require("nvim-surround")
    local function _6_()
      local link = get_input("Enter the link:", "file")
      if link then
        return {{"["}, {("](" .. link .. ")")}}
      else
        return nil
      end
    end
    local function _8_()
      return {{""}, {""}}
    end
    local function _9_()
      local link = get_vselect_text()
      if link then
        return {{"["}, {("](" .. string.lower(string.gsub(link, "[%p%s]+", "-")) .. ")")}}
      else
        return nil
      end
    end
    local function _11_()
      return {{"**"}, {"**"}}
    end
    return surround.buffer_setup({surrounds = {l = {add = _6_, find = "%b[]%b()", delete = "^(%[)().-(%]%b())()$", change = {target = "^()()%b[]%((.-)()%)$", replacement = _8_}}, ["<cr>"] = {add = _9_}, s = {add = _11_, find = "%*%*.-%*%*", delete = "^(%*%*)().-(%*%*)()$"}}})
  end
  vim.api.nvim_create_autocmd("FileType", {pattern = "markdown", group = group, callback = _2_})
  vim.opt.shell = "fish"
  return vim.cmd("\n    map ,ch :call SetColorColumn()<CR>\n    function! SetColorColumn()\n      let col_num = virtcol('.')\n      let cc_list = split(&cc, ',')\n      if count(cc_list, string(col_num)) <= 0\n      execute 'set cc+='.col_num\n      else\n      execute 'set cc-='.col_num\n      endif\n    endfunction\n    ")
end
return markdown_setup()
