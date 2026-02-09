-- 自动命令 (autocmds)
-- 编辑器行为自定义：空白处理、文件类型设置、quickfix 等

local a = vim.api
local f = vim.fn

-- ━━ 编辑器选项 ━━
local editor = a.nvim_create_augroup('editor_options', { clear = true })

-- 保存前删除行尾空白（排除 markdown/vimwiki，它们的尾部空格有语义）
local function trim_whitespace()
    local exclude_filetypes = { 'markdown', 'vimwiki' }
    local ft = vim.bo.filetype
    for _, ef in ipairs(exclude_filetypes) do
        if ft == ef then
            return
        end
    end
    local view = f.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.cmd([[silent! 0;/^\%(\n*.\)\@!/,$d]])
    f.winrestview(view)
end

a.nvim_create_autocmd({ 'BufWritePre' }, {
    group = editor,
    pattern = { '*' },
    callback = trim_whitespace,
})

-- 复制时短暂高亮被复制的文本（500ms）
a.nvim_create_autocmd({ 'TextYankPost' }, {
    group = editor,
    pattern = { '*' },
    callback = function()
        vim.highlight.on_yank({ timeout = 500 })
    end,
})

-- 进入 Insert 模式时关闭相对行号（便于精确定位行号）
a.nvim_create_autocmd({ 'InsertEnter' }, {
    group = editor,
    pattern = { '*' },
    callback = function()
        vim.wo.relativenumber = false
    end,
})

-- 离开 Insert 模式时恢复相对行号
a.nvim_create_autocmd({ 'InsertLeave' }, {
    group = editor,
    pattern = { '*' },
    callback = function()
        vim.wo.relativenumber = true
    end,
})

-- ━━ 文件类型缩进设置 ━━
-- Web 相关文件使用 2 空格缩进
a.nvim_create_autocmd({ 'Filetype' }, {
    group = editor,
    pattern = {
        'beancount',
        'css',
        'html',
        'javascript',
        'json',
        'scss',
        'typescript',
        'yaml',
        'vim',
    },
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.expandtab = true
    end,
})

-- Go 使用 Tab 缩进（语言规范要求）
a.nvim_create_autocmd({ 'Filetype' }, {
    group = editor,
    pattern = { 'go' },
    callback = function()
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4
        vim.bo.shiftwidth = 4
        vim.bo.expandtab = false
    end,
})

-- Brewfile/Gemfile 识别为 Ruby 文件类型
a.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    group = editor,
    pattern = { 'Brewfile', 'Gemfile' },
    callback = function()
        vim.bo.filetype = 'ruby'
    end,
})

-- ━━ Quickfix ━━
-- 当 quickfix 窗口是唯一窗口时自动关闭（避免残留空窗口）
local qf = a.nvim_create_augroup('qf_options', { clear = true })
a.nvim_create_autocmd({ 'WinEnter' }, {
    group = qf,
    pattern = { '*' },
    callback = function()
        if vim.fn.winnr('$') == 1 and vim.bo.buftype == 'quickfix' then
            vim.cmd('q')
        end
    end,
})

-- ━━ LSP ━━
-- 光标停留时自动弹出诊断浮窗（非聚焦，不打断工作流）
local lsp = a.nvim_create_augroup('lsp_options', { clear = true })
a.nvim_create_autocmd({ 'CursorHold' }, {
    group = lsp,
    pattern = { '*' },
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false, scope = 'cursor' })
    end,
})

-- ━━ Beancount ━━
-- 保存 Beancount 文件后运行 bean-check 语法检查
local beancount = a.nvim_create_augroup('beancount_options', { clear = true })
a.nvim_create_autocmd({ 'BufWritePost' }, {
    group = beancount,
    pattern = { '{*.bean,*.beancount}' },
    callback = function()
        vim.cmd('!bean-check <afile>')
    end,
})

-- ━━ nvim-go ━━
-- GoLint 弹窗后自动返回前一个窗口
local nvim_go = a.nvim_create_augroup('nvim_go', { clear = true })
a.nvim_create_autocmd({ 'User' }, {
    group = nvim_go,
    pattern = { 'NvimGoLintPopupPost' },
    command = 'wincmd p',
})
