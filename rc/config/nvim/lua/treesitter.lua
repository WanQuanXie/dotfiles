-- Treesitter 语法解析配置
-- 提供语法高亮、文本对象等功能
-- 注意: playground 已移除，使用 Neovim 内建 :InspectTree 替代
-- 注意: main 分支已移除 nvim-treesitter.configs 模块，改用新 API

-- 解析器安装改由 lazy build/手动 :TSUpdate 管理，避免每次启动都触发下载编译
-- jsonc 复用 json parser，避免请求当前不受支持的独立 jsonc 语言
vim.treesitter.language.register('json', 'jsonc')

-- 启用 Treesitter 语法高亮（由 Neovim 内建 vim.treesitter 提供）
vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

-- 文本对象（基于 Treesitter 的函数/类/参数选择）
require('nvim-treesitter-textobjects').setup({
    select = {
        lookahead = true,
    },
})

local function select_textobject(capture, query_group)
    return function()
        require('nvim-treesitter-textobjects.select').select_textobject(capture, query_group)
    end
end

local xo = { 'x', 'o' }
vim.keymap.set(xo, 'af', select_textobject('@function.outer', 'textobjects')) -- 选中整个函数（含签名）
vim.keymap.set(xo, 'if', select_textobject('@function.inner', 'textobjects')) -- 选中函数体
vim.keymap.set(xo, 'ac', select_textobject('@class.outer', 'textobjects'))    -- 选中整个类
vim.keymap.set(xo, 'ic', select_textobject('@class.inner', 'textobjects'))    -- 选中类体
vim.keymap.set(xo, 'aP', select_textobject('@parameter.outer', 'textobjects')) -- 选中整个参数（含分隔符）
vim.keymap.set(xo, 'iP', select_textobject('@parameter.inner', 'textobjects')) -- 选中参数值
