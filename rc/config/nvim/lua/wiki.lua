-- vimwiki 个人 Wiki 配置
-- 使用 Markdown 语法，存储在 ~/dev/wiki-base/wiki/ 目录

vim.g.vimwiki_list = {
    {
        path = '~/dev/wiki-base/wiki/', -- Wiki 文件存储路径
        syntax = 'markdown',            -- 使用 Markdown 语法（而非默认 wiki 语法）
        ext = '.md',                    -- 文件扩展名
    },
}
vim.g.vimwiki_global_ext = 0            -- 不将所有 .md 文件识别为 vimwiki
vim.g.vimwiki_key_mappings = {
    global = 0,                         -- 禁用全局快捷键（避免与其他映射冲突）
    links = 1,                          -- 启用链接相关快捷键
    html = 0,                           -- 禁用 HTML 导出快捷键
}
