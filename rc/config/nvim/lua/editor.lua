-- 编辑增强模块
-- 包含 gitsigns、flash.nvim、nvim-surround、colorizer 等编辑相关配置

-- ━━ gitsigns — Git 变更标记 ━━
-- 在侧边栏显示 Git diff 状态，支持 hunk 操作和内联 blame
require('gitsigns').setup({
    signs = {
        add          = { text = '+' },    -- 新增行标记
        change       = { text = '~' },    -- 修改行标记
        delete       = { text = '_' },    -- 删除行标记
        topdelete    = { text = '‾' },    -- 文件顶部删除标记
        changedelete = { text = '~' },    -- 修改后删除标记
    },
})

-- ━━ flash.nvim — 快速跳转 ━━
-- 替代已归档的 hop.nvim，支持任意位置跳转和 Treesitter 节点选择
vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
    require('flash').jump()               -- 输入字符后跳转到匹配位置
end, { desc = 'Flash jump' })

vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
    require('flash').treesitter()         -- 按 Treesitter 语法节点选择文本
end, { desc = 'Flash Treesitter' })

-- ━━ nvim-surround — 包围操作 ━━
-- Lua 原生实现，替代 vim-surround + vim-repeat
-- 内建 dot-repeat 支持，无需额外的 vim-repeat 插件
-- 用法:
--   ys{motion}{char}  添加包围符号（如 ysiw" 给单词加双引号）
--   ds{char}          删除包围符号（如 ds" 删除双引号）
--   cs{old}{new}      替换包围符号（如 cs"' 双引号换单引号）
-- nvim-surround 已在 pack.lua 中通过 config = true 初始化
