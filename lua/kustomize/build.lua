local utils = require("kustomize.utils")
M = {}

local function create_output()
  vim.api.nvim_command("botright vnew")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_name(buf, "Kustomize #" .. buf)
  vim.api.nvim_buf_set_option(buf, "filetype", "yaml")
  vim.keymap.set("n", "q", ":q<cr>", { buffer = buf })
  return buf
end

M.build = function()
  if not (utils.check_plenary() and utils.check_exec("kustomize")) then
    return
  end
  local bufName = vim.api.nvim_buf_get_name(0)
  local fileName = vim.fs.basename(bufName)
  if utils.is_kustomization_yaml(fileName) then
    local Job = require("plenary.job")
    local dirName = vim.fs.dirname(bufName)
    Job:new({
      command = "kustomize",
      args = { "build", "." },
      cwd = dirName,
      -- https://github.com/nvim-lua/plenary.nvim/issues/189
      on_exit = vim.schedule_wrap(function(j, code)
        if code == 1 then
          local error = table.concat(j:stderr_result(), "\n")
          utils.error("Failed with code " .. code .. "\n" .. error)
        else
          local buf = create_output()
          vim.api.nvim_buf_set_lines(buf, -1, -1, true, j:result())
        end
      end),
    }):sync()
  else
    utils.warn("Buffer is not a kustomization.y(a)ml")
  end
end

return M
