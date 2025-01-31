local M = {}

local function matches_pattern(filename,patterns)
    for i, pattern in ipairs(patterns) do
        if string.match(filename, pattern.regex) then
            return i
        end
    end
    return false
end

local function modify_filename(config)
    local buf = vim.api.nvim_get_current_buf()
    local old_name = vim.api.nvim_buf_get_name(buf)
    local filename = vim.fn.fnamemodify(old_name, ":t")
    i= matches_pattern(filename, config.patterns)
    if i == false then
        return
    end
    local rename_fun = config.patterns[i].rename
    local new_name = rename_fun(filename,config.patterns[i])

    if vim.fn.isdirectory(new_name) == 1 and
        config.open_all_files==true then 
        open_all_files_directory(new_name);
    else
    local old_name = vim.api.nvim_buf_set_name(buf,new_name)
    end
end

function CloseOtherBuffers()
  local current_buf = vim.api.nvim_get_current_buf()  
  local buffers = vim.api.nvim_list_bufs()  

  for _, buf in ipairs(buffers) do
    if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })  
    end
  end
end

function open_all_files_directory(dir)
  if dir == "" then
    return
  end

  local files = vim.fn.globpath(dir , "*", false, true)  

  for _, file in ipairs(files) do
    if vim.fn.filereadable(file) == 1 then  
        vim.cmd("silent edit " .. vim.fn.fnameescape(file))
        vim.cmd("doautocmd BufReadPost")
    end
  end
end

local function get_cursor_string()
    local line = vim.api.nvim_get_current_line() 
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1 
    local left = line:sub(1, col):match("(%S+)%s*$") or ""
    local right = line:sub(col + 1):match("^%s*(%S+)") or ""
    
    return left .. right
end

local function modify_to_under_cursor(config)
  text = get_cursor_string()
  local i = matches_pattern(text,config.patterns)
  if i == false then
      return
  end
  CloseOtherBuffers()
  local rename_fun = config.patterns[i].rename
  local new_dir = rename_fun(text,config.patterns[i])
  open_all_files_directory(new_dir)
end

function M.setup(config)
    vim.api.nvim_create_autocmd("BufNewFile", {
        pattern = "*",
        callback = function() modify_filename(config) end,
    })
    vim.api.nvim_create_user_command("OPENCURSOR", function () modify_to_under_cursor(config) end , {})
end

return M

