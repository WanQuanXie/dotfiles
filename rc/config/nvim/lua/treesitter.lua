-- Treesitter 语法解析配置
-- 提供语法高亮、文本对象等功能
-- 注意: playground 已移除，使用 Neovim 内建 :InspectTree 替代
-- 注意: main 分支已移除 nvim-treesitter.configs 模块，改用新 API

-- 确保安装所需的语言解析器（异步安装，仅下载缺失的解析器）
require('nvim-treesitter').install({
    'bash',        -- Shell 脚本
    'beancount',   -- 记账文件
    'c',           -- C 语言
    'cmake',       -- CMake 构建系统
    'comment',     -- 注释（TODO/FIXME 等高亮）
    'cpp',         -- C++
    'css',         -- CSS 样式
    'dockerfile',  -- Dockerfile
    'dot',         -- Graphviz DOT
    'go',          -- Go 语言
    'gomod',       -- Go modules
    'gowork',      -- Go workspace
    'graphql',     -- GraphQL 查询
    'haskell',     -- Haskell
    'hcl',         -- HashiCorp HCL (Terraform)
    'html',        -- HTML
    'http',        -- HTTP 请求
    'javascript',  -- JavaScript
    'jsdoc',       -- JSDoc 注释
    'json',        -- JSON 数据
    'json5',       -- JSON5
    'jsonc',       -- JSON with Comments
    'lua',         -- Lua 语言
    'make',        -- Makefile
    'markdown',    -- Markdown 文档
    'php',         -- PHP
    'pug',         -- Pug 模板
    'python',      -- Python
    'regex',       -- 正则表达式
    'rst',         -- reStructuredText
    'ruby',        -- Ruby
    'rust',        -- Rust
    'scss',        -- SCSS 样式
    'toml',        -- TOML 配置
    'tsx',         -- TypeScript JSX
    'typescript',  -- TypeScript
    'vim',         -- Vim 脚本
    'vimdoc',      -- Vim 帮助文档
    'vue',         -- Vue SFC
    'yaml',        -- YAML 配置
})

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
