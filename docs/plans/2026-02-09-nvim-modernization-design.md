# Neovim 配置现代化重构设计

> 日期: 2026-02-09
> 目标: 全面升级 Neovim 插件生态，移除过时插件，引入 2025-2026 年最佳实践

## 一、改进策略

**大幅重构** — 全面拥抱 snacks.nvim + blink.cmp + flash.nvim 等新生态，调整模块结构，插件总数从 ~55 个精简至 ~35 个。

## 二、技术选型决策

| 领域 | 旧方案 | 新方案 | 理由 |
|------|--------|--------|------|
| Picker | telescope.nvim | snacks.nvim picker | 与 snacks 体系统一，frecency 支持 |
| 补全 | nvim-cmp + 11 个源 | blink.cmp | Rust 核心性能优异，配置简洁，LazyVim 14 已切换 |
| 配色 | nordtheme/vim (VimScript) | shaunsingh/nord.nvim | Lua 原生，treesitter/LSP 高亮更好 |
| 状态栏 | nvim-hardline + nvim-tabline | lualine.nvim | 活跃维护，内建 tabline，丰富主题 |
| 格式化 | 手写 autocmd (formatter.lua) | conform.nvim | 标准化框架，支持所有主流格式化器 |
| QoL 集合 | 6 个独立插件 | snacks.nvim | 统一 dashboard/notifier/terminal/indent/scroll/bufdelete/picker |

## 三、插件变更明细

### 3.1 移除的插件（已过时/内建替代，共 8 个）

| 插件 | 移除原因 |
|------|----------|
| `nvim-treesitter/playground` | Neovim 0.9+ 内建 `:InspectTree` 命令 |
| `ojroques/vim-oscyank` | Neovim 0.10+ 内建 OSC 52 剪贴板支持 |
| `google/vim-searchindex` | Neovim 0.9+ 内建搜索结果计数 |
| `folke/neodev.nvim` | 已弃用，由 `folke/lazydev.nvim` 替代 |
| `nvim-lua/plenary.nvim` | snacks picker 不依赖它，移除后无其他依赖者 |
| `rmagatti/session-lens` | snacks picker 可直接管理 session |
| `winston0410/range-highlight.nvim` | 依赖 plenary，使用率低 |
| `prettier/vim-prettier` | 被 conform.nvim 统一接管 |

### 3.2 替换的插件（共 15 个旧 → 6 个新 + snacks 模块）

| 旧插件 | 新方案 | 理由 |
|--------|--------|------|
| `nordtheme/vim` | `shaunsingh/nord.nvim` | Lua 原生，treesitter/LSP 高亮更好 |
| `ojroques/nvim-hardline` + `crispgm/nvim-tabline` | `nvim-lualine/lualine.nvim` | 活跃维护、内建 tabline 支持 |
| `phaazon/hop.nvim` | `folke/flash.nvim` | hop 已归档不维护，flash 功能更强 |
| `tpope/vim-surround` + `tpope/vim-repeat` | `kylechui/nvim-surround` | Lua 原生，内建 dot-repeat 支持 |
| `hrsh7th/nvim-cmp` + 11 个 cmp-xxx 源 | `saghen/blink.cmp` | Rust 核心性能好，配置简洁，内建多源 |
| `nvim-telescope/telescope.nvim` + 扩展 | snacks.nvim picker | 与 snacks 体系统一 |
| `mhinz/vim-startify` | snacks.nvim dashboard | 现代化，高度可配置 |
| `rcarriga/nvim-notify` | snacks.nvim notifier | 统一 snacks 体系 |
| `akinsho/toggleterm.nvim` | snacks.nvim terminal | 统一 snacks 体系 |
| `Yggdroot/indentLine` | snacks.nvim indent | Lua 原生，treesitter scope 支持 |
| `declancm/cinnamon.nvim` | snacks.nvim scroll | 统一 snacks 体系 |
| `ojroques/nvim-bufdel` | snacks.nvim bufdelete | 统一 snacks 体系 |
| `dstein64/nvim-scrollview` | snacks.nvim scroll | 合并到 scroll 模块 |
| `norcalli/nvim-colorizer.lua` | `NvChad/nvim-colorizer.lua` | 原版不维护，NvChad fork 活跃 |
| 手写 `formatter.lua` | `stevearc/conform.nvim` | 标准化格式化框架 |

### 3.3 保留不变的插件（约 20 个）

| 插件 | 用途 |
|------|------|
| `folke/lazy.nvim` | 插件管理器 |
| `nvim-treesitter/nvim-treesitter` | 语法高亮/解析引擎 |
| `nvim-treesitter/nvim-treesitter-textobjects` | 函数/类/参数文本对象 |
| `neovim/nvim-lspconfig` | LSP 客户端配置 |
| `williamboman/mason.nvim` | LSP/DAP/linter/formatter 包管理器 |
| `williamboman/mason-lspconfig.nvim` | mason 与 lspconfig 桥接 |
| `j-hui/fidget.nvim` | LSP 进度指示器 |
| `SmiteshP/nvim-navic` | LSP 代码位置面包屑 |
| `Bekaboo/dropbar.nvim` | Winbar 面包屑导航 |
| `lewis6991/gitsigns.nvim` | Git 变更标记 + 内联 blame |
| `rhysd/conflict-marker.vim` | Git 冲突标记高亮 |
| `numToStr/Comment.nvim` | 注释切换 |
| `windwp/nvim-autopairs` | 自动括号配对 |
| `monaqa/dial.nvim` | 增强 Ctrl-A/X 递增递减 |
| `chrisgrieser/nvim-spider` | CamelCase 感知的 word motion |
| `wellle/targets.vim` | 扩展文本对象 |
| `AndrewRadev/splitjoin.vim` | 单行/多行代码拆分合并 |
| `tpope/vim-abolish` | 文本变换工具（snake_case, camelCase 等） |
| `crispgm/nvim-auto-ime` | macOS 输入法自动切换 |
| `RRethy/vim-illuminate` | 高亮光标下相同单词 |
| `kana/vim-textobj-user` + `haya14busa/vim-textobj-number` | 自定义/数字文本对象 |
| `rmagatti/auto-session` | 自动保存/恢复 session |
| `ethanholz/nvim-lastplace` | 记住上次编辑位置 |
| `AndrewRadev/undoquit.vim` | 恢复关闭的 tab/窗口 |
| `L3MON4D3/LuaSnip` | 代码片段引擎 |
| `vimwiki/vimwiki` | 个人 Wiki |
| `crispgm/nvim-go` | Go 开发工具 |
| `rust-lang/rust.vim` | Rust 语言支持 |
| `mattn/emmet-vim` | HTML/CSS 缩写展开 |
| `nathangrigg/vim-beancount` | Beancount 记账文件支持 |
| `rafcamlet/nvim-luapad` | Lua REPL 交互环境 |
| `junegunn/vader.vim` | Vim 插件测试框架 |

## 四、模块结构

```
rc/config/nvim/
├── init.lua                 # 入口（微调：移除过时 pre-hooks）
├── .stylua.toml             # 保持不变
└── lua/
    ├── common.lua           # 保持 — 工具函数库
    ├── options.lua          # 保持 — 编辑器选项（添加 OSC 52 clipboard 配置）
    ├── mappings.lua         # 重写 — 清理过时映射，适配新插件
    ├── autocmds.lua         # 简化 — 移除手写格式化逻辑
    ├── pack.lua             # 重写 — 全新插件列表，每个插件带注释
    ├── colorscheme.lua      # 重写 — 适配 shaunsingh/nord.nvim
    ├── completion.lua       # 重写 — blink.cmp 配置（~40 行 vs 原 ~100 行）
    ├── editor.lua           # 扩展 — gitsigns + flash.nvim + nvim-surround + colorizer
    ├── finder.lua           # 重写 — snacks picker 配置
    ├── formatter.lua        # 重写 — conform.nvim 配置
    ├── languages.lua        # 调整 — LSP 配置 + lazydev.nvim 替代 neodev
    ├── statusline.lua       # 重写 — lualine.nvim + tabline
    ├── terminal.lua         # 重写 — snacks terminal
    ├── treesitter.lua       # 调整 — 移除 playground，更新配置
    └── wiki.lua             # 保持不变
```

## 五、各模块详细配置

### 5.1 pack.lua — 核心插件清单

```lua
-- ╔══════════════════════════════════════════════════╗
-- ║  插件清单 — 按功能分组，每个插件标注用途        ║
-- ╚══════════════════════════════════════════════════╝

require('lazy').setup({
    -- ━━ 核心依赖 ━━
    { 'nvim-tree/nvim-web-devicons' },     -- 文件类型图标（被多个插件依赖）

    -- ━━ QoL 集合 (snacks.nvim) ━━
    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        opts = {
            dashboard = { enabled = true },     -- 启动页（替代 vim-startify）
            notifier  = { enabled = true },     -- 通知系统（替代 nvim-notify）
            terminal  = { enabled = true },     -- 内置终端（替代 toggleterm）
            indent    = { enabled = true },     -- 缩进指引线（替代 indentLine）
            scroll    = { enabled = true },     -- 平滑滚动（替代 cinnamon.nvim）
            picker    = { enabled = true },     -- 文件搜索器（替代 telescope）
            bufdelete = { enabled = true },     -- 安全删除 buffer（替代 nvim-bufdel）
            statuscolumn = { enabled = true },  -- 状态列美化
            quickfile = { enabled = true },     -- 大文件快速打开优化
            words     = { enabled = true },     -- 光标下单词跳转增强
        },
    },

    -- ━━ 配色主题 ━━
    { 'shaunsingh/nord.nvim' },            -- Nord Lua 原生主题（替代 nordtheme/vim）

    -- ━━ 状态栏 ━━
    { 'nvim-lualine/lualine.nvim' },       -- 状态栏 + tabline（替代 hardline + tabline）

    -- ━━ 编辑增强 ━━
    { 'folke/flash.nvim' },                -- 快速跳转（替代已归档的 hop.nvim）
    { 'kylechui/nvim-surround' },          -- 包围文本操作（替代 vim-surround + vim-repeat）
    { 'numToStr/Comment.nvim' },           -- 注释切换
    { 'windwp/nvim-autopairs' },           -- 自动括号配对
    { 'monaqa/dial.nvim' },               -- 增强 Ctrl-A/X 递增递减
    { 'chrisgrieser/nvim-spider' },        -- CamelCase 感知的 word motion
    { 'wellle/targets.vim' },              -- 扩展文本对象（ci', di" 等）
    { 'AndrewRadev/splitjoin.vim' },       -- 单行/多行代码拆分合并
    { 'tpope/vim-abolish' },              -- 文本变换工具（crs→snake, crm→Mixed）
    { 'crispgm/nvim-auto-ime' },          -- macOS 输入法自动切换（SCIM 支持）

    -- ━━ 补全 ━━
    { 'saghen/blink.cmp' },               -- 自动补全引擎（Rust 核心，替代 nvim-cmp 全家桶）
    { 'L3MON4D3/LuaSnip' },              -- 代码片段引擎

    -- ━━ LSP & Mason ━━
    { 'neovim/nvim-lspconfig' },          -- LSP 客户端配置
    { 'williamboman/mason.nvim' },         -- LSP/DAP/linter/formatter 包管理器
    { 'williamboman/mason-lspconfig.nvim' }, -- mason 与 lspconfig 桥接
    { 'folke/lazydev.nvim' },             -- Neovim Lua API 补全（替代已弃用的 neodev.nvim）
    { 'j-hui/fidget.nvim' },              -- LSP 进度指示器（右下角旋转动画）
    { 'SmiteshP/nvim-navic' },            -- LSP 代码位置面包屑
    { 'Bekaboo/dropbar.nvim' },           -- Winbar 面包屑导航栏

    -- ━━ Treesitter ━━
    { 'nvim-treesitter/nvim-treesitter' }, -- 语法高亮/增量解析引擎
    { 'nvim-treesitter/nvim-treesitter-textobjects' }, -- 函数/类/参数文本对象

    -- ━━ 格式化 ━━
    { 'stevearc/conform.nvim' },          -- 统一格式化框架（替代手写 autocmd）

    -- ━━ Git ━━
    { 'lewis6991/gitsigns.nvim' },        -- Git 变更标记 + 内联 blame + hunk 操作
    { 'rhysd/conflict-marker.vim' },      -- Git 冲突标记高亮和跳转

    -- ━━ 视觉增强 ━━
    { 'RRethy/vim-illuminate' },          -- 高亮光标下相同单词/符号
    { 'NvChad/nvim-colorizer.lua' },      -- 颜色代码可视化（#ff0000 → 彩色背景）

    -- ━━ 文本对象 ━━
    { 'kana/vim-textobj-user' },          -- 自定义文本对象框架
    { 'haya14busa/vim-textobj-number' },  -- 数字文本对象（vin/van）

    -- ━━ 会话 & 历史 ━━
    { 'rmagatti/auto-session' },          -- 自动保存/恢复编辑 session
    { 'ethanholz/nvim-lastplace' },       -- 打开文件时回到上次编辑位置
    { 'AndrewRadev/undoquit.vim' },       -- 恢复意外关闭的 tab/窗口

    -- ━━ 语言专用 ━━
    { 'crispgm/nvim-go' },               -- Go 开发工具（GoTest, GoLint 等）
    { 'rust-lang/rust.vim' },            -- Rust 语言支持（rustfmt, cargo 集成）
    { 'mattn/emmet-vim' },               -- HTML/CSS Emmet 缩写展开
    { 'nathangrigg/vim-beancount' },      -- Beancount 记账文件语法支持

    -- ━━ 知识管理 ━━
    { 'vimwiki/vimwiki' },               -- Markdown 个人 Wiki 系统

    -- ━━ 开发工具 ━━
    { 'rafcamlet/nvim-luapad' },         -- Lua REPL 交互式开发环境
    { 'junegunn/vader.vim' },            -- Vim 插件单元测试框架
})
```

### 5.2 completion.lua — blink.cmp

```lua
-- blink.cmp 自动补全配置
-- 替代 nvim-cmp + 11 个 cmp-xxx 源插件
-- Rust 核心引擎，内建 LSP/buffer/path/snippet/cmdline 源
require('blink.cmp').setup({
    keymap = {
        ['<C-Space>'] = { 'show' },                    -- 手动触发补全菜单
        ['<CR>']      = { 'accept', 'fallback' },      -- 确认选择
        ['<C-n>']     = { 'select_next', 'fallback' }, -- 下一个候选项
        ['<C-p>']     = { 'select_prev', 'fallback' }, -- 上一个候选项
        ['<C-d>']     = { 'scroll_documentation_down' }, -- 文档向下滚动
        ['<C-u>']     = { 'scroll_documentation_up' },   -- 文档向上滚动
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' }, -- 补全源优先级
        cmdline = {},                                        -- 启用命令行补全
    },
    completion = {
        documentation = { auto_show = true },  -- 自动显示文档预览
    },
    signature = { enabled = true },  -- 函数签名帮助（替代 cmp-nvim-lsp-signature-help）
    snippets = { preset = 'luasnip' }, -- 使用 LuaSnip 作为片段后端
})
```

### 5.3 formatter.lua — conform.nvim

```lua
-- conform.nvim 统一格式化配置
-- 替代手写的 bean_format/lua_format/shell_format autocmd 函数
require('conform').setup({
    formatters_by_ft = {
        lua       = { 'stylua' },                  -- Lua: stylua（遵循 .stylua.toml）
        sh        = { 'shfmt' },                   -- Shell: shfmt
        bash      = { 'shfmt' },                   -- Bash: shfmt
        beancount = { 'bean_format' },             -- Beancount: bean-format（自定义格式化器）
        go        = { 'goimports', 'gofmt' },      -- Go: goimports + gofmt
        rust      = { 'rustfmt' },                 -- Rust: rustfmt
        html      = { 'prettier' },                -- HTML: prettier
        css       = { 'prettier' },                -- CSS: prettier
        scss      = { 'prettier' },                -- SCSS: prettier
        javascript = { 'prettier' },               -- JavaScript: prettier
        typescript = { 'prettier' },               -- TypeScript: prettier
        json      = { 'prettier' },                -- JSON: prettier
        yaml      = { 'prettier' },                -- YAML: prettier
        markdown  = { 'prettier' },                -- Markdown: prettier
        vue       = { 'prettier' },                -- Vue: prettier
    },
    format_on_save = {
        timeout_ms = 1000,                         -- 格式化超时 1 秒
        lsp_format = 'fallback',                   -- 无专用 formatter 时回退到 LSP 格式化
    },
    -- 自定义 bean-format 格式化器
    formatters = {
        bean_format = {
            command = 'bean-format',
            stdin = true,
        },
    },
})
```

### 5.4 finder.lua — snacks picker

```lua
-- snacks picker 文件搜索配置
-- 替代 telescope.nvim + telescope-heading + session-lens
local nnoremap = require('common').nnoremap

-- 文件查找
nnoremap('<leader>ff', function() Snacks.picker.files({ hidden = true }) end)        -- 查找文件（含隐藏文件）
nnoremap('<leader>fF', function() Snacks.picker.files({ hidden = true, ignored = true }) end) -- 查找所有文件
nnoremap('<leader>fd', function() Snacks.picker.git_files() end)                      -- 查找 Git 文件
nnoremap('<leader>fr', function() Snacks.picker.recent() end)                         -- 最近打开的文件

-- 内容搜索
nnoremap('<leader>fg', function() Snacks.picker.grep_word() end)                      -- Grep 光标下单词
nnoremap('<leader>fG', function() Snacks.picker.grep() end)                           -- Grep 输入内容

-- 导航与查找
nnoremap('<leader>fb', function() Snacks.picker.buffers() end)                        -- 缓冲区列表
nnoremap('<leader>fh', function() Snacks.picker.help() end)                           -- 帮助文档搜索
nnoremap('<leader>fl', function() Snacks.picker.lsp_symbols() end)                    -- LSP 文档符号
nnoremap('<leader>fk', function() Snacks.picker.keymaps() end)                        -- 快捷键搜索
nnoremap('<leader>fs', function() Snacks.picker.smart() end)                          -- Smart open（frecency 排序）
```

### 5.5 statusline.lua — lualine

```lua
-- lualine 状态栏 + tabline 配置
-- 替代 nvim-hardline + nvim-tabline
require('lualine').setup({
    options = {
        theme = 'nord',                           -- 保持 Nord 视觉风格
        component_separators = '',                -- 简洁分隔符
        section_separators = '',
    },
    sections = {
        lualine_a = { 'mode' },                   -- 编辑模式（NORMAL/INSERT/VISUAL...）
        lualine_b = { 'branch', 'diff' },         -- Git 分支名 + 变更统计
        lualine_c = { 'filename' },               -- 当前文件名
        lualine_x = {
            'diagnostics',                         -- LSP 诊断（错误/警告数量）
            { 'filetype', cond = function()       -- 文件类型（窄窗口隐藏）
                return vim.fn.winwidth(0) > 80
            end },
        },
        lualine_y = { 'progress' },               -- 文件阅读进度百分比
        lualine_z = { 'location' },               -- 行号:列号
    },
    tabline = {
        lualine_a = { 'tabs' },                   -- Tab 页列表（替代 nvim-tabline）
    },
})
```

### 5.6 colorscheme.lua — nord.nvim

```lua
-- nord.nvim Lua 原生主题配置
-- 替代 VimScript 版 nordtheme/vim
vim.g.nord_contrast = true                -- 侧边栏/浮窗深色对比
vim.g.nord_borders = true                 -- 窗口分割线可见
vim.g.nord_disable_background = false     -- 保留背景色
vim.g.nord_italic = true                  -- 启用斜体（注释、关键字等）
vim.g.nord_uniform_diff_background = true -- 统一 diff 背景色
vim.g.nord_bold = true                    -- 启用粗体

require('nord').set()                     -- 应用主题
```

### 5.7 editor.lua — 编辑增强

```lua
-- ━━ gitsigns — Git 变更标记 ━━
require('gitsigns').setup({
    signs = {
        add          = { text = '+' },    -- 新增行标记
        change       = { text = '~' },    -- 修改行标记
        delete       = { text = '_' },    -- 删除行标记
        topdelete    = { text = '‾' },    -- 顶部删除标记
        changedelete = { text = '~' },    -- 修改+删除标记
    },
})

-- ━━ flash.nvim — 快速跳转 ━━（替代已归档的 hop.nvim）
require('flash').setup({})
vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
    require('flash').jump()               -- 任意位置跳转（替代 hop 的 2-char 跳转）
end, { desc = 'Flash jump' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
    require('flash').treesitter()         -- 按 Treesitter 节点选择（替代 hop 的 word jump）
end, { desc = 'Flash Treesitter' })

-- ━━ nvim-surround — 包围操作 ━━（替代 vim-surround + vim-repeat）
require('nvim-surround').setup({})
-- 用法: ys{motion}{char} 添加包围, ds{char} 删除, cs{old}{new} 替换

-- ━━ nvim-colorizer — 颜色代码可视化 ━━（NvChad 维护版，替代原版）
require('colorizer').setup({})
```

### 5.8 terminal.lua — snacks terminal

```lua
-- snacks terminal 配置
-- 替代 toggleterm.nvim
local nnoremap = require('common').nnoremap

-- Normal 模式切换终端
nnoremap('<C-\\>', function() Snacks.terminal.toggle() end)
-- Terminal 模式切换终端（退出终端）
vim.keymap.set('t', '<C-\\>', function() Snacks.terminal.toggle() end, { desc = 'Toggle terminal' })
```

### 5.9 languages.lua — 调整项

```lua
-- 关键变更：
-- 1. neodev.nvim → lazydev.nvim
require('lazydev').setup({})  -- Neovim Lua API 补全和类型标注

-- 2. 移除 vim-prettier 相关配置（由 conform.nvim 接管）

-- 3. LSP 服务器配置保持不变：
-- bashls, beancount, cssls, gopls, html, jsonls, lua_ls,
-- pyright, rust_analyzer, ruby_lsp, sqlls, ts_ls, vimls, vuels, yamlls
```

### 5.10 treesitter.lua — 调整项

```lua
-- 关键变更：
-- 1. 移除 playground（用内建 :InspectTree 替代）
-- 2. 其余配置（语言列表、高亮、text objects）保持不变
```

### 5.11 mappings.lua — 变更清单

**移除的映射：**
- `cp` — OSC52 手动映射（Neovim 0.10+ 内建，配置 `vim.g.clipboard` 即可）
- hop.nvim 相关 `s`/`S`/`<C-l>` — 迁移到 editor.lua 由 flash.nvim 接管
- telescope 相关 `<leader>f*` — 迁移到 finder.lua 由 snacks picker 接管
- `<leader>bb` (nvim-bufdel) — 改用 snacks bufdelete

**新增/修改的映射：**
- `<leader>bd` → `Snacks.bufdelete()` — 安全删除 buffer
- `<leader>un` → `Snacks.notifier.hide()` — 清除所有通知

### 5.12 autocmds.lua — 简化

**移除：** 所有手写格式化 autocmd（BufWritePre 调用 bean_format/lua_format/shell_format）→ 由 conform.nvim 的 `format_on_save` 统一处理

**保留不变：**
- `BufWritePre` — 删除行尾空白（排除 markdown/vimwiki）
- `TextYankPost` — 复制高亮（500ms）
- `InsertEnter/Leave` — 相对行号切换
- Filetype 缩进设置（HTML/CSS/JSON/JS/TS → 2 空格，Go → tab）
- Quickfix 自动关闭
- LSP diagnostic on cursor hold
- Brewfile/Gemfile → Ruby filetype

### 5.13 options.lua — 新增

```lua
-- 新增：内建 OSC 52 剪贴板支持（替代 vim-oscyank）
vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
}
```

## 六、实施步骤

按依赖关系分步骤实施，每步可独立验证：

### Step 1: 基础层 — 移除过时插件 + 配色迁移
1. 从 pack.lua 移除 8 个过时插件
2. 替换 `nordtheme/vim` → `shaunsingh/nord.nvim`，重写 colorscheme.lua
3. 在 options.lua 添加 OSC 52 clipboard 配置
4. 验证：`nvim --headless '+Lazy! sync' +qa` 无报错

### Step 2: 核心替换 — snacks.nvim 引入
1. 添加 snacks.nvim，配置所有模块
2. 移除 vim-startify, nvim-notify, toggleterm, indentLine, cinnamon, nvim-bufdel, nvim-scrollview
3. 重写 terminal.lua
4. 验证：启动页、终端、缩进线、通知正常

### Step 3: Picker 迁移 — telescope → snacks picker
1. 移除 telescope + 扩展 + plenary + session-lens + range-highlight
2. 重写 finder.lua
3. 更新 mappings.lua 中的 finder 快捷键
4. 验证：`<leader>ff`, `<leader>fg` 等正常工作

### Step 4: 补全迁移 — nvim-cmp → blink.cmp
1. 移除 nvim-cmp + 11 个 cmp-xxx 源
2. 添加 blink.cmp，重写 completion.lua
3. 验证：LSP 补全、路径补全、片段展开正常

### Step 5: 编辑增强迁移
1. 替换 hop.nvim → flash.nvim
2. 替换 vim-surround + vim-repeat → nvim-surround
3. 替换 neodev.nvim → lazydev.nvim
4. 替换 norcalli/nvim-colorizer → NvChad/nvim-colorizer
5. 重写 editor.lua
6. 验证：跳转、包围操作、Lua API 补全正常

### Step 6: 格式化迁移
1. 添加 conform.nvim，重写 formatter.lua
2. 移除 vim-prettier
3. 清理 autocmds.lua 中的手写格式化 autocmd
4. 验证：保存时各语言自动格式化正常

### Step 7: 状态栏迁移
1. 替换 hardline + tabline → lualine
2. 重写 statusline.lua
3. 验证：状态栏显示、tab 切换正常

### Step 8: 清理 + 注释
1. 为 pack.lua 中每个插件添加完整注释
2. 为所有模块文件添加模块级说明注释
3. 清理 mappings.lua 中的过时映射
4. 运行 `stylua` 格式化所有 Lua 文件
5. 运行完整测试：`bash ./app/nvim/test`

## 七、风险与回退策略

| 风险 | 缓解措施 |
|------|----------|
| blink.cmp 对 beancount 补全源不兼容 | blink.cmp 支持 nvim-cmp 源适配器，可复用 cmp-beancount |
| snacks picker 缺少 telescope-heading 功能 | 可用 snacks picker 的 LSP symbols 替代 markdown heading 搜索 |
| nord.nvim 与原 nord 主题视觉差异 | 两个都是 Nord 色板，差异主要在 treesitter token 高亮更精细 |
| 大量同时变更导致调试困难 | 严格按 Step 1-8 分步实施，每步验证后再继续 |

## 八、预期效果

- **插件数量**：~55 → ~35（减少约 36%）
- **启动性能**：减少插件加载数量，lazy loading 更高效
- **维护性**：所有插件为活跃维护状态，无归档/弃用风险
- **配置简洁度**：blink.cmp 配置减少约 60%，格式化配置标准化
- **生态一致性**：snacks.nvim 统一 QoL 功能，减少插件间兼容性问题
