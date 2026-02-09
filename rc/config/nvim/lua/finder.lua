-- snacks.nvim picker 文件搜索配置
-- 替代 telescope.nvim + telescope-heading + session-lens
-- 统一使用 Snacks.picker API，与 snacks.nvim 体系深度集成

local nnoremap = require('common').nnoremap

-- 文件查找
nnoremap('<leader>ff', function() Snacks.picker.files({ hidden = true }) end)         -- 查找文件（含隐藏文件，排除 .git）
nnoremap('<leader>fF', function()
    Snacks.picker.files({ hidden = true, ignored = true })                            -- 查找所有文件（含 gitignore 忽略的）
end)
nnoremap('<leader>fd', function() Snacks.picker.git_files() end)                      -- 查找 Git 跟踪的文件
nnoremap('<leader>fr', function() Snacks.picker.recent() end)                         -- 最近打开的文件

-- 内容搜索
nnoremap('<leader>fg', function() Snacks.picker.grep_word() end)                      -- Grep 光标下的单词
nnoremap('<leader>fG', function() Snacks.picker.grep() end)                           -- Grep 交互式输入

-- 导航与查找
nnoremap('<leader>fb', function() Snacks.picker.buffers() end)                        -- 缓冲区列表
nnoremap('<leader>fh', function() Snacks.picker.help() end)                           -- 帮助文档搜索
nnoremap('<leader>fl', function() Snacks.picker.lsp_symbols() end)                    -- LSP 文档符号
nnoremap('<leader>fk', function() Snacks.picker.keymaps() end)                        -- 快捷键搜索
nnoremap('<leader>fs', function() Snacks.picker.smart() end)                          -- Smart open（frecency 智能排序）
nnoremap('<leader>fm', function() Snacks.picker.lsp_symbols({ filter = { kind = 'String' } }) end) -- Markdown heading（通过 LSP symbols）
