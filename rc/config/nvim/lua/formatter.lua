-- conform.nvim 统一格式化配置
-- 替代手写的 bean_format/lua_format/shell_format autocmd 函数
-- 以及 vim-prettier 插件
-- 所有语言的格式化器在此统一管理，保存时自动格式化

require('conform').setup({
    -- 按文件类型配置格式化器
    formatters_by_ft = {
        lua        = { 'stylua' },                  -- stylua（遵循 .stylua.toml 配置）
        sh         = { 'shfmt' },                   -- shfmt（Shell 脚本格式化）
        bash       = { 'shfmt' },                   -- shfmt（Bash 脚本格式化）
        beancount  = { 'bean_format' },             -- bean-format（Beancount 记账格式化）
        go         = { 'goimports', 'gofmt' },      -- goimports 整理导入 + gofmt 格式化
        rust       = { 'rustfmt' },                 -- rustfmt（Rust 官方格式化器）
        html       = { 'prettier' },                -- prettier（HTML 格式化）
        css        = { 'prettier' },                -- prettier（CSS 格式化）
        scss       = { 'prettier' },                -- prettier（SCSS 格式化）
        javascript = { 'prettier' },                -- prettier（JavaScript 格式化）
        typescript = { 'prettier' },                -- prettier（TypeScript 格式化）
        json       = { 'prettier' },                -- prettier（JSON 格式化）
        yaml       = { 'prettier' },                -- prettier（YAML 格式化）
        markdown   = { 'prettier' },                -- prettier（Markdown 格式化）
        vue        = { 'prettier' },                -- prettier（Vue SFC 格式化）
    },
    -- 保存时自动格式化
    format_on_save = {
        timeout_ms = 1000,           -- 格式化超时 1 秒
        lsp_format = 'fallback',     -- 无专用 formatter 时回退到 LSP 格式化
    },
    -- 自定义格式化器定义
    formatters = {
        bean_format = {              -- Beancount 格式化器（调用 bean-format 命令）
            command = 'bean-format',
            stdin = true,
        },
    },
})
