-- nord.nvim 配色主题配置
-- Lua 原生实现，替代 VimScript 版 nordtheme/vim
-- 提供更好的 Treesitter/LSP token 高亮支持

vim.g.nord_contrast = true                -- 侧边栏/浮窗使用深色对比背景
vim.g.nord_borders = true                 -- 窗口分割线可见
vim.g.nord_disable_background = false     -- 保留背景色
vim.g.nord_italic = true                  -- 启用斜体（注释、关键字等）
vim.g.nord_uniform_diff_background = true -- 统一 diff 背景色
vim.g.nord_bold = true                    -- 启用粗体

require('nord').set() -- 应用主题

-- winbar 背景透明
vim.cmd('highlight WinBar guibg=NONE')
