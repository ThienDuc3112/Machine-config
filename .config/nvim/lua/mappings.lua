require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local nomap = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "zR", require("ufo").openAllFolds)
map("n", "zM", require("ufo").closeAllFolds)
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>")
map("n", "<leader>dr", "<cmd> DapContinue <CR>")
-- vim.keymap.del("n", "<M-h>")
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

nomap("n", "<C-h>")
nomap("n", "<C-j>")
nomap("n", "<C-k>")
nomap("n", "<C-l>")

map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux Navigate Left" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux Navigate Down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux Navigate Up" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux Navigate Right" })
map("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "Tmux Navigate Previous" })

-- -- diagnostic
-- local diagnostic_goto = function(next, severity)
-- 	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
-- 	severity = severity and vim.diagnostic.severity[severity] or nil
-- 	return function()
-- 		go({ severity = severity })
-- 	end
-- end
-- map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- Macro
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

-- LOGGING macro
local function set_macro(filetypes, macro)
  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("SetMacro_" .. table.concat(filetypes, "_"), { clear = true }),
    pattern = "*",
    callback = function()
      local ft = vim.bo.filetype
      if vim.tbl_contains(filetypes, ft) then
        vim.fn.setreg("l", macro)
      end
    end,
  })
end

set_macro({ "cpp", "c" }, 'yocout << "' .. esc .. 'pa: " << ' .. esc .. "pa << endl;" .. esc)
set_macro({ "go" }, 'yofmt.Printf("' .. esc .. 'pa: %v\\n", ' .. esc .. "pa)" .. esc)
set_macro(
  { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  "yoconsole.log(`" .. esc .. "pa: ${" .. esc .. "pa}`);" .. esc
)
