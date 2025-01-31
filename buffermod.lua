local M = {}

M.config = {}

function M.setup(opts)
    M.config = vim.tbl_extend("force", M.config, opts or {})
    require("events").setup(M.config)
end

return M
