-- LSP 语言服务器配置
-- 管理各语言的 LSP 设置，navic 面包屑集成，以及语言专用选项

-- navic 面包屑 — 通过全局 LspAttach 自动附加，无需逐个配置 on_attach
local navic = require('nvim-navic')
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.documentSymbolProvider then
            navic.attach(client, args.buf)
        end
    end,
})

-- LSP 服务器由 mason-lspconfig 的 automatic_enable 自动启用（vim.lsp.enable）
-- 无需手动调用 lspconfig.XXX.setup() 或 vim.lsp.enable()

-- ━━ HTML/Emmet ━━
vim.g.user_emmet_install_global = 0        -- 不全局安装 emmet
vim.g.user_emmet_leader_key = '<c-y>'      -- Emmet 快捷键前缀
vim.api.nvim_command('autocmd FileType html,css EmmetInstall') -- 仅 HTML/CSS 启用

-- ━━ Rust ━━
vim.g.rustfmt_autosave = 1 -- 保存 Rust 文件时自动运行 rustfmt
