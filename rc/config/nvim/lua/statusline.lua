-- lualine.nvim 状态栏 + tabline 配置
-- 替代 nvim-hardline + nvim-tabline
-- 使用 Nord 主题风格，简洁分隔符

require('lualine').setup({
    options = {
        theme = 'nord',                           -- 保持 Nord 视觉风格
        component_separators = '',                -- 无组件分隔符（简洁风格）
        section_separators = '',                  -- 无区段分隔符
    },
    sections = {
        lualine_a = { 'mode' },                   -- 编辑模式（NORMAL/INSERT/VISUAL...）
        lualine_b = {
            'branch',                              -- Git 分支名
            'diff',                                -- Git 变更统计（+/-/~）
        },
        lualine_c = { 'filename' },               -- 当前文件名
        lualine_x = {
            'diagnostics',                         -- LSP 诊断（错误/警告数量）
            {
                'filetype',                        -- 文件类型
                cond = function()
                    return vim.fn.winwidth(0) > 80 -- 窗口宽度 > 80 时才显示
                end,
            },
        },
        lualine_y = { 'progress' },               -- 文件阅读进度百分比
        lualine_z = { 'location' },               -- 行号:列号
    },
    tabline = {
        lualine_a = { 'tabs' },                   -- Tab 页列表（替代 nvim-tabline）
    },
})
