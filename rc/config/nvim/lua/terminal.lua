-- snacks.nvim terminal 配置
-- 替代 toggleterm.nvim
-- 使用 Snacks.terminal API 管理终端窗口

local nnoremap = require('common').nnoremap

-- Normal 模式切换终端（Ctrl-\ 打开/关闭）
nnoremap('<C-\\>', function()
    Snacks.terminal.toggle()
end)

-- Terminal 模式切换终端（在终端内按 Ctrl-\ 返回编辑器）
vim.keymap.set('t', '<C-\\>', function()
    Snacks.terminal.toggle()
end, { desc = 'Toggle terminal' })
