-- LSP 语言服务器配置
-- 管理各语言的 LSP 设置，navic 面包屑集成，以及语言专用选项

local lspconfig = require('lspconfig')

-- navic 面包屑 — 为支持 documentSymbol 的 LSP 客户端附加面包屑导航
local navic = require('nvim-navic')
local attach_navic = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

-- ━━ 主要语言 LSP ━━（附加 navic 面包屑）
lspconfig.gopls.setup({
    on_attach = attach_navic, -- Go 语言服务器
})
lspconfig.rust_analyzer.setup({
    on_attach = attach_navic, -- Rust 语言服务器
})
lspconfig.ts_ls.setup({
    on_attach = attach_navic, -- TypeScript/JavaScript 语言服务器
})

-- ━━ 其他语言 LSP ━━
lspconfig.bashls.setup({})    -- Bash 脚本
lspconfig.beancount.setup({}) -- Beancount 记账
lspconfig.cssls.setup({})     -- CSS
lspconfig.html.setup({})      -- HTML
lspconfig.jsonls.setup({})    -- JSON
lspconfig.lua_ls.setup({})    -- Lua（lazydev.nvim 自动增强 Neovim API 补全）
lspconfig.pyright.setup({})   -- Python
lspconfig.ruby_lsp.setup({})  -- Ruby
lspconfig.sqlls.setup({})     -- SQL
lspconfig.vimls.setup({})     -- Vim 脚本
lspconfig.vuels.setup({})     -- Vue
lspconfig.yamlls.setup({})    -- YAML

-- ━━ HTML/Emmet ━━
vim.g.user_emmet_install_global = 0        -- 不全局安装 emmet
vim.g.user_emmet_leader_key = '<c-y>'      -- Emmet 快捷键前缀
vim.api.nvim_command('autocmd FileType html,css EmmetInstall') -- 仅 HTML/CSS 启用

-- ━━ Rust ━━
vim.g.rustfmt_autosave = 1 -- 保存 Rust 文件时自动运行 rustfmt
