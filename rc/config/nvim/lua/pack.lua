-- ╔══════════════════════════════════════════════════════════════╗
-- ║  Neovim 插件清单 — 使用 lazy.nvim 管理，按功能分组         ║
-- ║  每个插件标注用途，便于维护和审查                          ║
-- ║  最后更新: 2026-02-09                                      ║
-- ╚══════════════════════════════════════════════════════════════╝

return require('lazy').setup({
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- 核心依赖
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    { 'nvim-tree/nvim-web-devicons', lazy = true }, -- 文件类型图标（被 lualine/snacks 等依赖）

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- QoL 集合 (snacks.nvim by folke)
    -- 一站式替代: vim-startify, nvim-notify, toggleterm,
    --            indentLine, cinnamon.nvim, nvim-bufdel,
    --            nvim-scrollview, telescope.nvim
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        opts = {
            dashboard    = { enabled = true },  -- 启动页（替代 vim-startify）
            notifier     = { enabled = true },  -- 通知系统（替代 nvim-notify）
            terminal     = { enabled = true },  -- 内置终端（替代 toggleterm）
            indent       = { enabled = true },  -- 缩进指引线（替代 indentLine）
            scroll       = { enabled = true },  -- 平滑滚动（替代 cinnamon.nvim）
            picker       = { enabled = true },  -- 文件搜索器（替代 telescope）
            bufdelete    = { enabled = true },  -- 安全删除 buffer（替代 nvim-bufdel）
            statuscolumn = { enabled = true },  -- 状态列美化
            quickfile    = { enabled = true },  -- 大文件快速打开优化
            words        = { enabled = true },  -- 光标下单词跳转增强
        },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- 配色主题
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    { 'shaunsingh/nord.nvim' }, -- Nord Lua 原生主题（替代 VimScript 版 nordtheme/vim）

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- 状态栏
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    { 'nvim-lualine/lualine.nvim' }, -- 状态栏 + tabline（替代 hardline + tabline）

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- 编辑增强
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        'folke/flash.nvim', -- 快速跳转到任意位置（替代已归档的 hop.nvim）
        event = 'VeryLazy',
        opts = {},
    },
    {
        'kylechui/nvim-surround', -- 包围文本操作 ys/ds/cs（替代 vim-surround + vim-repeat）
        version = '*',
        event = 'VeryLazy',
        config = true,
    },
    {
        'numToStr/Comment.nvim', -- 注释切换 gc/gcc
        config = true,
    },
    {
        'windwp/nvim-autopairs', -- 自动括号配对（输入 ( 自动补全 )）
        event = 'InsertEnter',
        config = true,
    },
    { 'monaqa/dial.nvim' },                -- 增强 Ctrl-A/X 递增递减（支持日期、布尔值等）
    { 'chrisgrieser/nvim-spider', lazy = true }, -- CamelCase 感知的 word motion
    { 'wellle/targets.vim' },               -- 扩展文本对象（ci', di", ca, 等）
    { 'AndrewRadev/splitjoin.vim' },        -- 单行/多行代码拆分合并（gS/gJ）
    { 'tpope/vim-abolish' },                -- 文本变换工具（crs→snake_case, crm→MixedCase）
    {
        'crispgm/nvim-auto-ime', -- macOS 输入法自动切换（离开 Insert 模式切回英文）
        -- dev = true,
        config = function()
            require('auto-ime').setup({
                ime_source = 'com.apple.inputmethod.SCIM.ITABC',
            })
        end,
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- 补全引擎
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        'saghen/blink.cmp', -- 自动补全引擎，Rust 核心（替代 nvim-cmp + 11 个 cmp-xxx 源）
        version = '1.*',
        dependencies = {
            {
                'L3MON4D3/LuaSnip', -- 代码片段引擎
                version = 'v2.*',
                build = 'make install_jsregexp',
            },
            {
                'saghen/blink.compat', -- nvim-cmp 源兼容层（用于 cmp-beancount 适配）
                version = '*',
                opts = {},
            },
        },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- LSP & Mason
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    { 'neovim/nvim-lspconfig' }, -- LSP 客户端配置框架
    {
        'williamboman/mason.nvim', -- LSP/DAP/linter/formatter 包管理器
        config = true,
    },
    {
        'williamboman/mason-lspconfig.nvim', -- mason 与 lspconfig 桥接，自动安装 LSP 服务器
        dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'bashls',        -- Bash
                    'beancount',     -- Beancount 记账
                    'cssls',         -- CSS
                    'gopls',         -- Go
                    'html',          -- HTML
                    'jsonls',        -- JSON
                    'lua_ls',        -- Lua
                    'pyright',       -- Python
                    'rust_analyzer', -- Rust
                    'ruby_lsp',      -- Ruby
                    'sqlls',         -- SQL
                    'ts_ls',         -- TypeScript/JavaScript
                    'vimls',         -- Vim
                    'vuels',         -- Vue
                    'yamlls',        -- YAML
                },
            })
        end,
    },
    {
        'folke/lazydev.nvim', -- Neovim Lua API 补全和类型标注（替代已弃用的 neodev.nvim）
        ft = 'lua',
        config = true,
    },
    {
        'j-hui/fidget.nvim', -- LSP 进度指示器（右下角旋转动画）
        config = true,
    },
    {
        'SmiteshP/nvim-navic', -- LSP 代码位置面包屑（当前函数/类路径）
        dependencies = { 'neovim/nvim-lspconfig' },
    },
    { 'Bekaboo/dropbar.nvim' }, -- Winbar 面包屑导航栏（窗口顶部代码路径）

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Treesitter
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        'nvim-treesitter/nvim-treesitter', -- 语法高亮/增量解析引擎
        build = ':TSUpdate',
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects', -- 函数/类/参数的 Treesitter 文本对象
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- 格式化
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    { 'stevearc/conform.nvim' }, -- 统一格式化框架（替代手写 autocmd + vim-prettier）

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Git
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    { 'lewis6991/gitsigns.nvim' },   -- Git 变更标记（侧边栏 +/~/- 标记）+ 内联 blame
    { 'rhysd/conflict-marker.vim' }, -- Git 冲突标记高亮（<<<< ==== >>>>）和快速跳转

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- 视觉增强
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        'RRethy/vim-illuminate', -- 高亮光标下相同单词/符号（LSP + Treesitter 感知）
        config = function()
            require('illuminate').configure({
                under_cursor = false, -- 不高亮光标正下方的词
            })
        end,
    },
    {
        'NvChad/nvim-colorizer.lua', -- 颜色代码可视化（#ff0000 显示彩色背景）
        config = true,               -- 替代不再维护的 norcalli/nvim-colorizer.lua
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- 文本对象
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    { 'kana/vim-textobj-user' }, -- 自定义文本对象框架（被 textobj-number 依赖）
    {
        'haya14busa/vim-textobj-number', -- 数字文本对象（vin 选中数字，van 含周围空格）
        dependencies = { 'kana/vim-textobj-user' },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- 会话 & 历史
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        'rmagatti/auto-session', -- 自动保存/恢复编辑 session（按目录管理）
        opts = {
            suppressed_dirs = { '~/', '~/workspace', '/' },
        },
    },
    { 'ethanholz/nvim-lastplace' }, -- 打开文件时自动回到上次编辑位置
    { 'AndrewRadev/undoquit.vim' }, -- 恢复意外关闭的 tab/窗口（<c-w>u）

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- 语言专用
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    { 'mattn/emmet-vim' }, -- HTML/CSS Emmet 缩写展开（<c-y>, 触发）
    {
        'crispgm/nvim-go', -- Go 开发工具（:GoTest, :GoLint, :GoCoverage 等）
        -- dev = true,
        config = function()
            require('go').setup({
                formatter = 'lsp',              -- 使用 LSP 格式化
                test_flags = { '-v', '-count=1' },
                test_popup_width = 120,
                test_open_cmd = 'tabedit',
            })
        end,
    },
    { 'rust-lang/rust.vim' },       -- Rust 语言支持（rustfmt 自动格式化, cargo 命令集成）
    { 'nathangrigg/vim-beancount' }, -- Beancount 记账文件语法高亮和缩进
    {
        'crispgm/cmp-beancount', -- Beancount 账户名补全源（通过 blink.compat 适配）
        -- dev = true,
    },
    { 'vimwiki/vimwiki' }, -- Markdown 个人 Wiki 系统（链接、日记、导航）

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- 开发工具
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    { 'rafcamlet/nvim-luapad' }, -- Lua REPL 交互式开发环境（:Luapad 启动）
    { 'junegunn/vader.vim' },    -- Vim 插件单元测试框架（:Vader 运行测试）
}, {
    dev = {
        path = '~/dev',
    },
    install = { colorscheme = { 'nord' } },
})
