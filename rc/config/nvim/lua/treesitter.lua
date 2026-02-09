-- Treesitter 语法解析配置
-- 提供语法高亮、增量选择、文本对象等功能
-- 注意: playground 已移除，使用 Neovim 内建 :InspectTree 替代

require('nvim-treesitter.configs').setup({
    -- 确保安装的语言解析器（涵盖日常开发所需语言）
    ensure_installed = {
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
    },
    -- 语法高亮（基于 Treesitter AST，比正则更准确）
    highlight = {
        enable = true,
    },
    -- 缩进（目前关闭，部分语言支持不完善）
    indent = {
        enable = false,
    },
    -- 增量选择（按语法节点逐步扩大/缩小选区）
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = 'gnn',    -- 初始化选择（Normal 模式开始选择当前节点）
            node_incremental = 'grn',  -- 扩大到父节点
            scope_incremental = 'grc', -- 扩大到当前作用域
            node_decremental = 'grm',  -- 缩小选择（回到子节点）
        },
    },
    -- 文本对象（基于 Treesitter 的函数/类/参数选择）
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                ['af'] = '@function.outer', -- 选中整个函数（含签名）
                ['if'] = '@function.inner', -- 选中函数体
                ['ac'] = '@class.outer',    -- 选中整个类
                ['ic'] = '@class.inner',    -- 选中类体
                ['aP'] = '@parameter.outer', -- 选中整个参数（含分隔符）
                ['iP'] = '@parameter.inner', -- 选中参数值
            },
        },
    },
})
