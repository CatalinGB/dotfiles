if has("win32")
let g:configForWork = 1
endif

" {{{ Plugins func

lua << EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
{
  -- TODO: add configs
  {
    "inkarkat/vim-mark",
    lazy = false,
    dependencies = {
      "inkarkat/vim-ingo-library"
    },
    config = function()
      -- vim.g.mw_no_mappings = 1
    end,
  },

  {
    "wincent/ferret",
    lazy = false,
    dependencies = {
      "Olical/vim-enmasse",
      "yssl/QFEnter"
    },
    config = function()
    end,
  },

  {
    "airblade/vim-rooter",
    lazy = false,
    config = function()
    end,
  },

  {
      -- TODO: check if I can replace it with Picker, unfortunately seems not
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-frecency.nvim",
    },
    config = function()
    end,
  },

  {
    "nanozuki/tabby.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
    end,
  },

  {
    "monaqa/dial.nvim",
    lazy = false,
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group{
        -- default augends used when no group name is specified
        default = {
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.integer.alias.decimal,   -- nonnegative decimal number (0, 1, 2, 3, ...)
          augend.integer.alias.hex,       -- nonnegative hex number  (0x01, 0x1a1f, etc.)
          augend.date.alias["%Y/%m/%d"],  -- date (2022/02/19, etc.)
          augend.constant.new{ elements = {"true", "false"} },
          augend.constant.new{ elements = {"TRUE", "FALSE"} },
          augend.constant.new{ elements = {"E_OK", "E_NOT_OK"} },
          augend.constant.new{ elements = {"DCM_INITIAL", "DCM_CANCEL", "DCM_E_PENDING", "DCM_E_FORCE_RCRRP"} },
        },
      }

      vim.keymap.set("n", "<C-a>", function()
          require("dial.map").manipulate("increment", "normal")
      end)
      vim.keymap.set("n", "<C-x>", function()
          require("dial.map").manipulate("decrement", "normal")
      end)
      vim.keymap.set("n", "g<C-a>", function()
          require("dial.map").manipulate("increment", "gnormal")
      end)
      vim.keymap.set("n", "g<C-x>", function()
          require("dial.map").manipulate("decrement", "gnormal")
      end)
      vim.keymap.set("v", "<C-a>", function()
          require("dial.map").manipulate("increment", "visual")
      end)
      vim.keymap.set("v", "<C-x>", function()
          require("dial.map").manipulate("decrement", "visual")
      end)
      vim.keymap.set("v", "g<C-a>", function()
          require("dial.map").manipulate("increment", "gvisual")
      end)
      vim.keymap.set("v", "g<C-x>", function()
          require("dial.map").manipulate("decrement", "gvisual")
      end)
    end,
  },

  {
    "mhinz/vim-signify",
    -- TODO: ft = ['c', 'xml', 'm4', 'h', 'c.m4', 'h.m4'],
    config = function()
    end,
  },

  {
    "kshenoy/vim-signature",
    config = function()
    end,
  },

  {
    "folke/todo-comments.nvim",
    config = function()
    end,
  },

  {
    "AndrewRadev/linediff.vim",
    config = function()
    end,
  },

  {
    "mbbill/undotree",
    config = function()
    end,
  },

  -- {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},

  {
    "cocopon/vaffle.vim",
    config = function()
    end,
  },

  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    config = function()
    end,
  },

  {
    "nlknguyen/papercolor-theme",
    lazy = false,
    priority = 1000,
    config = function()
    end,
  },

  {
    "rakr/vim-one",
    lazy = false,
    priority = 1000,
    config = function()
    end,
  },

  {
    "echasnovski/mini.nvim",
    lazy = false,
    config = function()
    end,
  },

  {
    "dstein64/vim-startuptime",
    -- lazy-load on a command
    cmd = "StartupTime",
    -- init is called during startup. Configuration for vim plugins typically should be set in an init function
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- if some code requires a module from an unloaded plugin, it will be automatically loaded.
  -- So for api plugins like devicons, we can always set lazy=true
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {'akinsho/toggleterm.nvim', version = "*", config = true},

  {
     "folke/trouble.nvim",
     dependencies = { "nvim-tree/nvim-web-devicons" },
     opts = {},
  },


}
)
-- Mini.nvim
require('mini.ai').setup()

require('mini.align').setup({
  mappings = {
    start = '<Enter>', -- TODO: think of replacing with ga
    start_with_preview = 'gA',
  }
})

require('mini.comment').setup()

require('mini.jump').setup()

-- TODO: seems like replacement to MRU - not really, it's project based
require('mini.visits').setup()
require('mini.pick').setup()
require('mini.extra').setup()

-- TODO:maye do it later
--require('mini.completion').setup()
--
--local lspconfig = require('lspconfig')
--lspconfig.clangd.setup{
--  on_attach = aerial.on_attach,
--}

-- TODO: find a way to enable this as needed, otherwise is annoying
-- require('mini.cursorword').setup({
--   delay = 700,
-- })

require('mini.pairs').setup()

-- gS, go split
require('mini.splitjoin').setup()

-- {{{ mini.statusline
require('mini.statusline').setup(
{
  -- Content of statusline as functions which return statusline string. See
  -- `:h statusline` and code of default contents (used instead of `nil`).
  content = {
    -- Content for active window
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
      local git = MiniStatusline.section_git { trunc_width = 75 }
      local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
      local filename = MiniStatusline.section_filename { trunc_width = 140 }
      local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
      local location = MiniStatusline.section_location { trunc_width = 75 }
      local search = MiniStatusline.section_searchcount { trunc_width = 75 }
      -- vim.opt.laststatus = 3

      return MiniStatusline.combine_groups {
        { hl = mode_hl },
        { strings = { mode } },
        { hl = 'MiniStatuslineInactive', strings = { git, diagnostics, search } },
        '%=', -- Start center alignment
        '%<', -- Mark general truncate point
        { strings = { filename } },
        '%=', -- start right alignment
        { hl = 'MiniStatuslineInactive', strings = { fileinfo } },
        { strings = { location } },
      }
    end,
    inactive = function() end,
  },
  set_vim_settings = false,
})
-- }}}

require('mini.surround').setup({
  mappings = {
    add = 'S', -- Add surrounding in Normal and Visual modes
    delete = 'ds', -- Delete surrounding
    find = 'sf', -- Find surrounding (to the right)
    find_left = 'sF', -- Find surrounding (to the left)
    highlight = 'sh', -- Highlight surrounding
    replace = 'sr', -- Replace surrounding
    update_n_lines = 'sn', -- Update `n_lines`

    suffix_last = 'l', -- Suffix to search with "prev" method
    suffix_next = 'n', -- Suffix to search with "next" method
  },
})

-- {{{Tabline
vim.o.showtabline = 2
vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'
local theme = {
  fill = 'TabLineFill',
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = 'TabLine',
  -- current_tab = 'TabLineSel',
  current_tab = { fg = '#F8FBF6', bg = '#896a98', style = 'italic' },
  tab = 'TabLine',
  win = 'TabLine',
  tail = 'TabLine',
}

require('tabby.tabline').set(function(line)
  return {
    {
      line.sep(' ', theme.head, theme.fill),
    },
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and theme.current_tab or theme.tab
      return {
        line.sep(' ', hl, theme.fill),
        tab.is_current() and '' or '',
        tab.number(),
        tab.name(),
        -- tab.close_btn(''), -- show a close button
        line.sep(' ', hl, theme.fill),
        hl = hl,
        margin = ' ',
      }
    end),
    line.spacer(),
    --shows list of windows in tab
    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
      return {
        line.sep(' ', theme.win, theme.fill),
        win.is_current() and '' or '',
        win.buf_name(),
        line.sep(' ', theme.win, theme.fill),
        hl = theme.win,
        margin = ' ',
      }
    end),
    {
      line.sep(' ', theme.tail, theme.fill),
    },
    hl = theme.fill,
  }
end)
-- }}}

-- require'nvim-treesitter.install'.compilers = { "clang" }
-- require'nvim-treesitter.configs'.setup {
--   -- A list of parser names, or "all" (the five listed parsers should always be installed)
--   ensure_installed = { "c", "lua", "vim", "python"},
--
--   -- Install parsers synchronously (only applied to `ensure_installed`)
--   sync_install = false,
--
--   -- Automatically install missing parsers when entering buffer
--   -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
--   auto_install = false,
--
--   -- List of parsers to ignore installing (or "all")
--   ignore_install = { "javascript" },
--
--   ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
--   -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
--
--   highlight = {
--     enable = true,
--
--     -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
--     -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
--     -- the name of the parser)
--     -- list of language that will be disabled
--     disable = { "rust" },
--     -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
--     disable = function(lang, buf)
--         local max_filesize = 100 * 1024 -- 100 KB
--         local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
--         if ok and stats and stats.size > max_filesize then
--             return true
--         end
--     end,
--
--     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--     -- Using this option may slow down your editor, and you may see some duplicate highlights.
--     -- Instead of true it can also be a list of languages
--     additional_vim_regex_highlighting = true,
--   },
-- }

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- local neogit = require('neogit')
-- neogit.setup {}

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ['<C-p>'] = require('telescope.actions.layout').toggle_preview
      }
    },
    preview = {
      hide_on_startup = true -- hide previewer when picker starts
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    frecency = {
      show_scores = false,
      show_unindexed = true,
      ignore_patterns = { "*.git/*", "*/tmp/*" },
      disable_devicons = false,
    },
  },
}

require("telescope").load_extension "frecency"

-- TODO: check the above comment about trouble
-- local actions = require("telescope.actions")
-- local trouble = require("trouble.providers.telescope")
-- 
-- local telescope = require("telescope")
-- 
-- telescope.setup {
--   defaults = {
--     mappings = {
--       i = { ["<c-t>"] = trouble.open_with_trouble },
--       n = { ["<c-t>"] = trouble.open_with_trouble },
--     },
--   },
-- }

-- require("fzf-lua").setup({})

-- -- Repeat this for each language server you have configured
-- require("nvim-surround").setup {
--     -- Configuration here, or leave empty to use defaults
-- }

-- Plug 'folke/todo-comments.nvim'
require("todo-comments").setup {
  keywords = {
    FIX = {
      icon = " ", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    ERROR = { icon = " ", color = "error", alt = { "ERROR" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
},
  }

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

if vim.g.neovide then
  vim.g.neovide_fullscreen = false
  vim.g.neovide_cursor_animation_length = 0
end

EOF

" }}}

" {{{ Editior settings

" Boost performance of rendering long lines
set synmaxcol=300


" How many lines to scroll at a time, make scrolling appears faster
" set scrolljump=5

set mouse=a

if (has("termguicolors"))
 set termguicolors
 let $NVIM_TUI_ENABLE_TRUE_COLOR=1
 let &t_8b="\e[48;2;%ld;%ld;%ldm"
endif

syntax on

" Plug 'marko-cerovac/material.nvim'
let g:material_contrast = v:true
let g:material_style = 'darker'
set background=light
colorscheme material

colorscheme one

set encoding=utf-8
scriptencoding utf-8

" map copy/paste
set clipboard+=unnamedplus

" folding
set foldmethod=manual

" set the curent directory
set autochdir

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" don't open folds when search match is found inside
set fdo-=search

" persistent undo
set undofile
set undodir=$HOME\vim_undo
set undolevels=10000
set undoreload=10000

" set the locaiton for swp files
set directory=$HOME\vim_undo
set backupdir=$HOME\vim_undo

" search
set hlsearch
set incsearch
set number
set ignorecase
vmap // y/\V<C-R>"<CR>

" set spelling
set sps=best,10

" flashes matching brackets or parentheses
set showmatch

" Display extra whitespace
set list
set listchars=trail:-,tab:>-,extends:>,precedes:<,conceal:+

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set nowrap

set scrolloff=5

set splitright " Puts new vsplit windows to the right of the current
set splitbelow " Puts new split windows to the bottom of the current

" set the language
set langmenu=none

" autoindent
set ai

set wildmenu
set wildmode=full

" set visual bell -- i hate that damned beeping
set vb

" set history length
set history=1000

" disable the menu
set guioptions-=T
set guioptions-=L
set guioptions-=r
set guioptions-=m
set guioptions-=e
"
" Disable built-in plugins
let g:loaded_2html_plugin      = 1
let g:loaded_gzip              = 1
let g:loaded_rrhelper          = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zipPlugin         = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_tarPlugin         = 1
let g:loaded_vimballPlugin     = 1

" show the current line
set cul

" show the filename in the bottom of the window
set modeline
set ls=2

" allow backspacing over everything in insert-mode
set backspace=indent,eol,start

set shortmess=aoOTt

" If we have 'live substitution', enable it
if exists('&inccommand')
  set inccommand=nosplit
endif

" autoreads
" set autoread
" autocmd FocusGained,CursorHold ?* if getcmdwintype() == '' | checktime | endif

" set autoread
" " TODO: check what's with this
" augroup checktime
"     au!
"     if !has("gui_running")
"         "silent! necessary otherwise throws errors when using command
"         "line window.
"         autocmd BufEnter        * silent! checktime
"         autocmd CursorHold      * silent! checktime
"         autocmd CursorHoldI     * silent! checktime
"         "these two _may_ slow things down. Remove if they do.
"         " autocmd CursorMoved     * silent! checktime
"         " autocmd CursorMovedI    * silent! checktime
"     endif
" augroup END

set title

let &errorformat="%f:%l:%c:%m"

" C stuff
set cino+=(0             "Align paramater lists after newline under '('

set dictionary+=$HOME\words.txt

" }}}

" {{{ Mappings

" Leader mappings
let mapleader = "\<Space>"
nnoremap <Leader>sz :set scb!<CR> " syncronized scroll
nnoremap <Leader>db :call DeleteInactiveBufs()<CR>
nnoremap <Leader>dd :diffthis<CR>
nnoremap <Leader>do :diffoff<CR>
nnoremap <Leader>dp :diffput<CR>
nnoremap <Leader>dg :diffget<CR>
nnoremap <Leader>du :diffupdate<CR>
" nnoremap <Leader>m  :CtrlPMRUFiles<CR>
nnoremap <Leader>m  :Telescope frecency<CR>
nnoremap <Leader>st :call StripTrailingWhitespaces()<cr>
nnoremap <Leader>sw :set wrap!<CR>
nnoremap <Leader>tc :tabclose<CR>
nnoremap <Leader>tn :tabnew<CR>
nnoremap <silent><Leader>/ :nohlsearch<CR>
nnoremap <silent><Leader>c :call ToggleColorColumn()<CR>

nnoremap <silent><leader>S z=
nnoremap <silent><leader>s :set spell!<CR>

nnoremap <leader>ov :exe ':silent !code %'<CR>:redraw!<CR>
nnoremap <Leader>e  :Ack  <C-R>=FindRootDirectory()<CR>\<C-Left><C-Left><C-Left><C-Left><C-Right><Right>
nnoremap <Leader>r  :Ack <C-R><C-W> <C-R>=FindRootDirectory()<CR><C-Left><C-Left><C-Left><C-Left><C-Right><Right><CR>

vmap <Leader>ld :Linediff<CR>
vmap ;' V'<O#if 0<Esc>'>o#endif<Esc>
nnoremap <C-s> :w<CR>

imap jj <Esc>

cnoremap <c-v> <c-r>+
map! <S-Insert> <C-R>+

" replace the selection with the buffer
vmap r "_dp

" c: Change into the blackhole register to not clobber the last yank
nnoremap c "_c

nnoremap gp `[v`]

" Replace a word with yanked text
nnoremap <leader>rp viw"0p

" Navigate 5x faster when holding down Ctrl
nmap <c-j> 5j
nmap <c-k> 5k
nmap <c-h> 5h
nmap <c-l> 5l
vmap <c-j> 5j
vmap <c-k> 5k
vmap <c-h> 5h
vmap <c-l> 5l

" Move normally between wrapped lines
nmap j gj
nmap k gk

" window navigation
nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-l> :wincmd l<CR>
tnoremap <silent> <A-k> :wincmd k<CR>
tnoremap <silent> <A-j> :wincmd j<CR>
tnoremap <silent> <A-h> :wincmd h<CR>
tnoremap <silent> <A-l> :wincmd l<CR>

" To map <Esc> to exit terminal-mode
tnoremap <Esc> <C-\><C-n>

" resize windows
nmap <silent> <S-k> :resize +5<CR>
nmap <silent> <S-j> :resize -5<CR>
nmap <silent> <S-l> :vertical resize +5<CR>
nmap <silent> <S-h> :vertical resize -5<CR>

" go to previous visited locations
nmap <silent> <C-t>  <C-o>
nmap <silent> <A-Left>  <C-o>
nmap <silent> <A-Right> <C-i>

" buffer navigation
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>

nnoremap ]t :tabnext<CR>
nnoremap [t :tabprevious<CR>

nnoremap ]l :lnext<CR>
nnoremap [l :lprev<CR>
map <C-Down> ]c
map <C-Up> [c
"

" faster indentaion
nmap > >>
nmap < <<

" F* mappings
nnoremap <F2> :cprevious<CR>
nnoremap <F3> :cnext<CR>
nnoremap <F10> :call ToggleNumber()<cr>

" play macros with Q
nnoremap Q @a
vnoremap Q :norm @a<cr>
nnoremap qq ZZ<CR>

" search but don't jump to the next word
nnoremap * *``

" Fix for legacy vi inconsistency
map Y y$

" Remap VIM 0 to first non-blank character
map 0 ^

" }}}

" {{{ Autocmds
au FileType qf set nowrap

" Set row highlight
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END

" Makefiles

au FileType make setl noexpandtab " use real tabs
au FileType make setl shiftwidth=8 " standard shift width
au FileType make setl tabstop=8 " use standard tab size

" Set window position variable which is used in the diff mapping
augroup WinPos
    autocmd!
    autocmd WinEnter * call MapDiffCmd(winnr())
augroup END

augroup AutoSwap
        autocmd!
        autocmd SwapExists *  call AS_HandleSwapfile(expand('<afile>:p'), v:swapname)
augroup END

function! MapDiffCmd(number)
    if (a:number == 1)
      map <C-Right> :diffput<CR>
      map <C-Left> :diffget<CR>
    elseif (a:number == 2)
      map <C-Right> :diffget<CR>
      map <C-Left> :diffput<CR>
    else
    endif
endfunction

function! AS_HandleSwapfile (filename, swapname)
  " if swapfile is older than file itself, just get rid of it
  if getftime(v:swapname) < getftime(a:filename)
          call delete(v:swapname)
          let v:swapchoice = 'e'
  endif
endfunction

" autocmd! bufwritepost init.vim source %

" }}}

" {{{ Plugins

" Plug 'inkarkat/vim-mark'
let g:mw_no_mappings = 1

" TODO: candidate for replacement
nnoremap <leader>n <cmd>lua require('telescope.builtin').find_files({
\   prompt_title = "Project files",
\   previewer = false,
\   cwd = vim.call('FindRootDirectory')
\ })<CR>

" Plug 'mhinz/vim-signify'
let g:signify_disable_by_default = 0
let g:signify_vcs_list = [ 'svn', 'git' ]

" " Plug 'ctrlpvim/ctrlp.vim'
" " TODO: candidate for replacement. Seems frecency is a good one
" let g:ctrlp_max_history = 4000
" let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
" let g:ctrlp_use_caching = 0

" Plug 'yssl/QFEnter' " quickfix options and mappings
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>']
let g:qfenter_keymap.vopen = ['v']
let g:qfenter_keymap.hopen = ['s']
let g:qfenter_keymap.topen = ['t']

" Plug 'cocopon/vaffle.vim' " file manager
function! s:customize_vaffle_mappings() abort
  " Customize key mappings here
  nmap <buffer> <Bslash> <Plug>(vaffle-open-root)
  nmap <buffer> u        <Plug>(vaffle-open-parent)
  nmap <buffer> K        <Plug>(vaffle-mkdir)
  nmap <buffer> N        <Plug>(vaffle-new-file)
endfunction

augroup vimrc_vaffle
  autocmd!
  autocmd FileType vaffle call s:customize_vaffle_mappings()
augroup END

" Plug 'airblade/vim-rooter'
let g:rooter_silent_chdir = 1
let g:rooter_patterns = ['.git', '.svn', 'util', 'plugin.xml']
let g:rooter_manual_only = 1

" Plug 'wincent/ferret'
let g:FerretAutojump = 0
let g:FerretHlsearch = 1
let g:FerretMap=0
let g:FerretExecutableArguments = {
      \   'rg': '-H -S --sort path --column --line-number --no-heading --ignore-file '.$USERPROFILE.'/ignore'
      \ }

" }}}

" {{{ Functions and commands

" Toggle ColorColumn
function! ToggleColorColumn()
    if &colorcolumn != ''
        setlocal colorcolumn&
    else
        setlocal colorcolumn=100
    endif
endfunction

" toggle between number and relativenumber
function! ToggleNumber()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set relativenumber
  endif
endfunc

function! StripTrailingWhitespaces()
  " save last search & cursor position
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction

function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction

" Scratchpad
command! -nargs=0 Scratch enew | call Scratch()
command! -nargs=0 SScratch split | Scratch
command! -nargs=0 VScratch vsplit | Scratch
" define function to turn current buffer into a scratch buffer
function! Scratch()
  setlocal buftype=nofile bufhidden=hide noswapfile
endfunction

function! ToggleVerbose()
    if !&verbose
        set verbosefile=$HOME\vim_undo\vb.txt
        set verbose=12
    else
        set verbose=0
        set verbosefile=
    endif
endfunction

let s:fontsize = 12
function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "GuiFont! Consolas:h" . s:fontsize
endfunction

noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a

function! Redir(cmd, rng, start, end)
  for win in range(1, winnr('$'))
    if getwinvar(win, 'scratch')
      execute win . 'windo close'
    endif
  endfor
  if a:cmd =~ '^!'
    let cmd = a:cmd =~' %'
      \ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
      \ : matchstr(a:cmd, '^!\zs.*')
    if a:rng == 0
      let output = systemlist(cmd)
    else
      let joined_lines = join(getline(a:start, a:end), '\n')
      let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
      let output = systemlist(cmd . " <<< $" . cleaned_lines)
    endif
  else
    redir => output
    execute a:cmd
    redir END
    let output = split(output, "\n")
  endif
  vnew
  let w:scratch = 1
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  call setline(1, output)
endfunction

command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

" }}}

if (has("win32") && (g:configForWork == 1))
  let userProfile = substitute($USERPROFILE,'\\','/','g')

  " Work specific things
  source $USERPROFILE/AppData/Local/nvim/eb.vim
endif

" ex: set foldmethod=marker
