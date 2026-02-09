-- blink.cmp 自动补全配置
-- 替代 nvim-cmp + 11 个 cmp-xxx 源插件
-- Rust 核心引擎，内建 LSP/buffer/path/snippet 源
-- Beancount 补全通过 blink.compat 兼容层适配 cmp-beancount

-- 加载 VSCode 格式的自定义代码片段
require('luasnip.loaders.from_vscode').lazy_load({ paths = '~/dev/snippets' })

require('blink.cmp').setup({
    keymap = {
        ['<C-Space>'] = { 'show' },                       -- 手动触发补全菜单
        ['<CR>']      = { 'accept', 'fallback' },         -- 确认选中项
        ['<C-n>']     = { 'select_next', 'fallback' },    -- 下一个候选项
        ['<C-p>']     = { 'select_prev', 'fallback' },    -- 上一个候选项
        ['<C-d>']     = { 'scroll_documentation_down' },  -- 文档预览向下滚动
        ['<C-u>']     = { 'scroll_documentation_up' },    -- 文档预览向上滚动
        ['<C-c>']     = { 'cancel' },                     -- 取消补全
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'beancount' },
        providers = {
            lazydev = {                            -- Neovim Lua API 补全源
                name = 'LazyDev',
                module = 'lazydev.integrations.blink',
                score_offset = 100,                -- 优先级最高
            },
            beancount = {                          -- Beancount 账户名补全源
                name = 'beancount',
                module = 'blink.compat.source',    -- 通过兼容层桥接 nvim-cmp 源
                opts = {
                    account = '~/dev/ledger/beancounts/accounts.bean',
                },
            },
        },
    },
    completion = {
        documentation = { auto_show = true },  -- 自动显示文档预览窗口
        ghost_text = { enabled = true },       -- 内联灰色预览文本
    },
    signature = { enabled = true },            -- 函数签名参数帮助（替代 cmp-nvim-lsp-signature-help）
    snippets = { preset = 'luasnip' },         -- 使用 LuaSnip 作为代码片段后端
})
