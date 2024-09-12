-- [nfnl] Compiled from fnl/polish.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.string")
local blank_3f = _local_1_["blank?"]
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
local function check_list_section(pattern)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local prev_line_text = vim.fn.getline((row - 1))
  local prefix, text = string.match(prev_line_text, pattern)
  return prefix, text, row
end
local function insert_list_item()
  vim.api.nvim_command("startinsert")
  local todo_pattern = "^%s*(%- %[.?%] )(.*)"
  local dash_pattern = "^%s*(%- )([^%[%]]*)"
  local star_pattern = "^%s*(%* )(.*)"
  local prefix, text, row = check_list_section(todo_pattern)
  if not prefix then
    prefix, text = check_list_section(dash_pattern)
    if not prefix then
      prefix, text = check_list_section(star_pattern)
    else
    end
  else
  end
  if prefix then
    if blank_3f(text) then
      return vim.api.nvim_buf_set_text(0, (row - 2), 0, (row - 2), #vim.fn.getline((row - 1)), {""})
    else
      vim.api.nvim_buf_set_text(0, (row - 1), 0, (row - 1), 0, {prefix})
      return vim.api.nvim_win_set_cursor(0, {row, (string.len(prefix) + 1)})
    end
  else
    return nil
  end
end
local function toggle_todo_item()
  local todo_pattern = "^%s*%- %[(.?)%] "
  local row = vim.fn.line(".")
  local text = vim.fn.getline(".")
  local toggle_text = string.gsub(text, todo_pattern, {x = "- [ ] ", [" "] = "- [x] "})
  return vim.api.nvim_buf_set_text(0, (row - 1), 0, (row - 1), #toggle_text, {toggle_text})
end
local function markdown_setup()
  local group = vim.api.nvim_create_augroup("md_augroup", {clear = true})
  local function _7_(_args)
    vim.opt_local.formatoptions:append("cmB")
    local function _8_()
      vim.api.nvim_command("exe 'normal! i\13'")
      return insert_list_item()
    end
    vim.keymap.set("i", "<CR>", _8_, {buffer = true})
    local function _9_()
      vim.api.nvim_command("normal! o")
      return insert_list_item()
    end
    vim.keymap.set("n", "o", _9_, {buffer = true})
    vim.keymap.set("n", "<LocalLeader>x", toggle_todo_item, {buffer = true, desc = "Toggle TODO"})
    vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u")
    vim.keymap.set("n", "<tab>", ":call search('\\V](\\.\\+)')<cr>", {buffer = true})
    vim.keymap.set("n", "<s-tab>", ":call search('\\V](\\.\\+)', 'b')<cr>", {buffer = true})
    local function _10_()
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
    vim.keymap.set("n", "<cr>", _10_, {buffer = true, desc = "Basic create on press enter on links"})
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en,cjk"
    local surround = require("nvim-surround")
    local function _13_()
      local link = get_input("Enter the link:", "file")
      if link then
        return {{"["}, {("](" .. link .. ")")}}
      else
        return nil
      end
    end
    local function _15_()
      return {{""}, {""}}
    end
    local function _16_()
      local link = get_vselect_text()
      if link then
        return {{"["}, {("](" .. string.lower(string.gsub(link, "[%p%s]+", "-")) .. ")")}}
      else
        return nil
      end
    end
    local function _18_()
      return {{"**"}, {"**"}}
    end
    return surround.buffer_setup({surrounds = {l = {add = _13_, find = "%b[]%b()", delete = "^(%[)().-(%]%b())()$", change = {target = "^()()%b[]%((.-)()%)$", replacement = _15_}}, ["<cr>"] = {add = _16_}, s = {add = _18_, find = "%*%*.-%*%*", delete = "^(%*%*)().-(%*%*)()$"}}})
  end
  vim.api.nvim_create_autocmd("FileType", {pattern = "markdown", group = group, callback = _7_})
  vim.opt.shell = "fish"
  return vim.cmd("\n    map ,ch :call SetColorColumn()<CR>\n    function! SetColorColumn()\n      let col_num = virtcol('.')\n      let cc_list = split(&cc, ',')\n      if count(cc_list, string(col_num)) <= 0\n      execute 'set cc+='.col_num\n      else\n      execute 'set cc-='.col_num\n      endif\n    endfunction\n    ")
end
return markdown_setup()
