-- 编辑器基础选项
-- 编码、显示、编辑行为、终端颜色等全局设置

local cmd = vim.cmd
local opt = vim.opt
local has = vim.fn.has

cmd('filetype plugin indent on')
cmd('syntax enable')

-- ━━ 系统 ━━
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.fileencodings = { 'utf-8' }
opt.backup = false          -- 禁用备份文件 (.bak)
opt.swapfile = false        -- 禁用交换文件 (.swp)
opt.undofile = true         -- 启用持久化撤销文件
opt.updatetime = 300        -- CursorHold 触发延迟 (ms)

-- ━━ 缓冲区 ━━
opt.expandtab = true        -- Tab 转为空格
opt.tabstop = 4             -- Tab 宽度 4
opt.softtabstop = 4         -- 软 Tab 宽度 4
opt.autoindent = true       -- 新行自动缩进
opt.shiftwidth = 4          -- 自动缩进宽度

-- ━━ 窗口 ━━
opt.number = true           -- 显示行号
opt.relativenumber = true   -- 显示相对行号
opt.foldmethod = 'marker'   -- 折叠方式：标记

-- ━━ 编辑 ━━
opt.whichwrap = 'b,s,<,>,[,]'              -- 光标可从行尾移到下一行
opt.backspace = { 'indent', 'eol', 'start' } -- 退格键行为
opt.list = true                             -- 显示制表符等不可见字符
opt.ignorecase = false                      -- 搜索区分大小写
opt.hlsearch = true                         -- 高亮搜索结果
opt.incsearch = false                       -- 禁用增量搜索
opt.inccommand = 'nosplit'                  -- 实时预览替换效果
opt.completeopt = { 'menuone', 'noselect' } -- 补全菜单选项
opt.hidden = true                           -- 允许隐藏未保存的缓冲区
opt.cursorline = true                       -- 高亮当前行
opt.ruler = true                            -- 显示标尺
opt.colorcolumn = { 120 }                   -- 120 字符处显示列标线
opt.signcolumn = 'yes'                      -- 始终显示符号列
opt.mouse = 'nv'                            -- Normal/Visual 模式启用鼠标
opt.showmatch = true                        -- 显示括号匹配
opt.cmdheight = 2                           -- 命令行高度
opt.wildmenu = true                         -- 命令行补全菜单
opt.wildmode = { 'longest', 'full' }        -- 补全模式
opt.splitright = true                       -- 新分割窗口在右侧
opt.splitbelow = true                       -- 新分割窗口在下方
opt.shortmess:append('c')                   -- 精简状态消息
opt.laststatus = 3                          -- 全局状态栏

-- ━━ 终端颜色 ━━
if not has('gui_running') then
    opt.t_Co = 256
end
opt.background = 'dark'
if has('termguicolors') then
    cmd('let &t_8f = "\\<Esc>[38;2;%lu;%lu;%lum"')
    cmd('let &t_8b = "\\<Esc>[48;2;%lu;%lu;%lum"')
    opt.termguicolors = true     -- 启用 24-bit 真彩色
end

-- ━━ 剪贴板 ━━
-- 使用 Neovim 内建 OSC 52 协议（替代 vim-oscyank 插件）
-- 支持通过 SSH/tmux 等远程终端复制到系统剪贴板
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
