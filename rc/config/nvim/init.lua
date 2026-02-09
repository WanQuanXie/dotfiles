-- Neovim 配置入口
-- 加载顺序：options → pack → mappings → 各功能模块 → autocmds

local try_require = require('common').try_require

-- ━━ 插件管理器 (lazy.nvim) ━━
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ━━ 预设 (需在插件加载前设置) ━━
vim.g.vimwiki_ext2syntax = vim.empty_dict() -- vimwiki: 禁用自动文件类型检测
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
vim.o.wrap = false

-- ━━ 加载配置模块 ━━
try_require('options')     -- 编辑器基础选项
try_require('pack')        -- 插件清单 (lazy.nvim)
try_require('mappings')    -- 全局快捷键映射

-- 功能模块
try_require('completion')  -- blink.cmp 自动补全
try_require('colorscheme') -- nord.nvim 配色主题
try_require('editor')      -- 编辑增强 (gitsigns, flash, surround)
try_require('finder')      -- snacks picker 文件搜索
try_require('formatter')   -- conform.nvim 格式化
try_require('languages')   -- LSP 语言服务器配置
try_require('statusline')  -- lualine 状态栏
try_require('terminal')    -- snacks terminal 终端
try_require('treesitter')  -- Treesitter 语法解析
try_require('wiki')        -- vimwiki 个人 Wiki

-- 自动命令（最后加载，确保所有插件已就绪）
try_require('autocmds')
