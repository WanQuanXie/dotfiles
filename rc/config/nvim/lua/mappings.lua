-- 全局快捷键映射
-- 注意: 插件特定的映射在各自模块中定义
--   - finder 映射 → finder.lua
--   - flash 跳转映射 → editor.lua
--   - terminal 映射 → terminal.lua

local map = require('common').map
local nnoremap = require('common').nnoremap
local inoremap = require('common').inoremap
local vnoremap = require('common').vnoremap
local cnoremap = require('common').cnoremap

-- ━━ 通用命令 ━━
nnoremap('<leader>#', '<cmd>let @/ = ""<cr><Esc>')  -- 清除搜索高亮
nnoremap('n', 'nzzzv')                              -- 搜索下一个并居中
nnoremap('N', 'Nzzzv')                              -- 搜索上一个并居中
nnoremap('<leader>q', '<cmd>q!<cr>')                 -- 强制退出
nnoremap('<leader>e', '<cmd>e!<cr>')                 -- 强制重载缓冲区
nnoremap('<leader>Q', '<cmd>qa!<cr>')                -- 强制退出所有
nnoremap('<leader>w', '<cmd>wq!<cr>')                -- 保存并退出
nnoremap('<leader>n', '<cmd>set nonumber norelativenumber<cr>') -- 隐藏行号
nnoremap('<leader>N', '<cmd>set number<cr>')                    -- 显示绝对行号
nnoremap('<leader>R', '<cmd>set relativenumber<cr>')            -- 显示相对行号

-- ━━ 移动 ━━
inoremap('<c-a>', '<Esc>I')  -- Insert 模式跳到行首
inoremap('<c-e>', '<End>')   -- Insert 模式跳到行尾
nnoremap('k', 'gk')         -- 按显示行上移（处理折行）
nnoremap('j', 'gj')         -- 按显示行下移（处理折行）

-- ━━ 编辑 ━━
nnoremap('Y', 'y$')                                  -- 复制到行尾（与 D/C 行为一致）
inoremap('<c-d>', '<Esc>ddi')                         -- Insert 模式删除当前行
nnoremap('<leader>pp', '"0p')                         -- 粘贴 yank 寄存器（不受 delete 影响）
nnoremap('<a-Up>', '<cmd>m .-2<cr>==')                -- Alt+Up 上移当前行
nnoremap('<a-Down>', '<cmd>m .+1<cr>==')              -- Alt+Down 下移当前行
vnoremap('<a-Up>', ":move '<-2<CR>gv=gv")             -- Visual 模式上移选中行
vnoremap('<a-Down>', ":move '>+1<CR>gv=gv")           -- Visual 模式下移选中行

-- ━━ 窗口分割 ━━
nnoremap('<leader>s', '<c-w>w')  -- 切换到下一个分割窗口
nnoremap('<leader>j', '<c-w>j')  -- 切换到下方窗口
nnoremap('<leader>k', '<c-w>k')  -- 切换到上方窗口
nnoremap('<leader>h', '<c-w>h')  -- 切换到左侧窗口
nnoremap('<leader>l', '<c-w>l')  -- 切换到右侧窗口

-- ━━ 缓冲区 ━━
nnoremap('<leader>bd', function() Snacks.bufdelete() end) -- 安全删除缓冲区（保持窗口布局）
nnoremap('<s-Tab>', '<cmd>bprev<cr>')                     -- 上一个缓冲区
nnoremap('<Tab>', '<cmd>bnext<cr>')                       -- 下一个缓冲区

-- ━━ Tab 页 ━━
nnoremap('<leader>[', 'gT')                -- 上一个 Tab
nnoremap('<leader>]', 'gt')                -- 下一个 Tab
nnoremap('<leader>t[', '<cmd>tabmove -1<cr>') -- Tab 左移
nnoremap('<leader>t]', '<cmd>tabmove +1<cr>') -- Tab 右移
nnoremap('<leader>1', '1gt')               -- 跳转到 Tab 1
nnoremap('<leader>2', '2gt')               -- 跳转到 Tab 2
nnoremap('<leader>3', '3gt')               -- 跳转到 Tab 3
nnoremap('<leader>4', '4gt')               -- 跳转到 Tab 4
nnoremap('<leader>5', '5gt')               -- 跳转到 Tab 5
nnoremap('<leader>6', '6gt')               -- 跳转到 Tab 6
nnoremap('<leader>7', '7gt')               -- 跳转到 Tab 7
nnoremap('<leader>8', '8gt')               -- 跳转到 Tab 8
nnoremap('<leader>9', '9gt')               -- 跳转到 Tab 9
nnoremap('<leader>0', '<cmd>tablast<cr>')  -- 跳转到最后一个 Tab

-- ━━ Quickfix ━━
nnoremap('<leader>cc', '<cmd>cclose<cr>')  -- 关闭 quickfix 窗口

-- ━━ 命令行 ━━
cnoremap('<c-a>', '<Home>')  -- 命令行跳到行首
cnoremap('<c-e>', '<End>')   -- 命令行跳到行尾

-- ━━ LSP ━━
nnoremap('<leader>ld', function() Snacks.picker.lsp_definitions() end)      -- LSP 跳转到定义
nnoremap('<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<cr>')            -- LSP 跳转到声明
nnoremap('<leader>lt', function() Snacks.picker.lsp_type_definitions() end) -- LSP 类型定义
nnoremap('<leader>li', function() Snacks.picker.lsp_implementations() end)  -- LSP 实现
nnoremap('K', '<cmd>lua vim.lsp.buf.hover()<cr>')                           -- LSP 悬浮文档
nnoremap('U', '<cmd>lua vim.lsp.buf.signature_help()<cr>')                  -- LSP 函数签名
nnoremap('<leader>lr', function() Snacks.picker.lsp_references() end)       -- LSP 查找引用
nnoremap('<leader>ls', function() Snacks.picker.lsp_symbols() end)          -- LSP 文档符号
nnoremap('<leader>lS', function() Snacks.picker.lsp_workspace_symbols() end) -- LSP 工作区符号
nnoremap('<leader>lR', '<cmd>lua vim.lsp.buf.rename()<cr>')                 -- LSP 重命名符号
nnoremap('<leader>lf', '<cmd>lua vim.lsp.buf.format({async=true})<cr>')     -- LSP 格式化文档

-- ━━ dial.nvim — 增强递增/递减 ━━
map('n', '<c-a>', '<Plug>(dial-increment)')             -- Ctrl-A 递增（支持数字、日期、布尔值等）
map('n', '<c-x>', '<Plug>(dial-decrement)')             -- Ctrl-X 递减
map('n', 'g<c-a>', '<Plug>(dial-increment-additional)') -- g Ctrl-A 附加递增
map('n', 'g<c-x>', '<Plug>(dial-decrement-additional)') -- g Ctrl-X 附加递减

-- ━━ 通知 ━━
nnoremap('<leader>un', function() Snacks.notifier.hide() end) -- 清除所有通知
