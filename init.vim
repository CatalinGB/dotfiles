lua << EOF
if vim.fn.has("win32") == 1 then
  vim.g.configForWork        = 1
  vim.g.python3_host_prog    = 'C:/ProgramData/chocolatey/bin/python3.12.EXE'
  vim.g.python_host_prog     = 'C:/Python27/python.exe'
  vim.g.loaded_perl_provider = 0
  vim.g.loaded_node_provider = 0
  vim.g.loaded_ruby_provider = 0
end

vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

local root_patterns = {'.git', '.svn', 'util', 'plugin.xml'}

-- {{{ Plugins func

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
  {
    "inkarkat/vim-mark",
    lazy = false,
    event = "VeryLazy",
    dependencies = {
      "inkarkat/vim-ingo-library"
    },
    init = function()
        vim.g.mw_no_mappings = 1
        vim.g.mwDefaultHighlightingPalette = 'extended'
    end,
  },

  {
    "wincent/ferret",
    enabled = false,
    init = function()
        vim.g.FerretAutojump = 0
        vim.g.FerretHlsearch = 1
        vim.g.FerretMap = 0
        vim.g.FerretQFCommands = 0
        vim.g.FerretExecutableArguments = {
          rg = '-H -S --sort path --column --line-number --no-heading --ignore-file ~/ignore'
        }
    end
  },

  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    init = function()
      vim.cmd([[
          hi BqfPreviewBorder guifg=#3e8e2d ctermfg=71
          hi BqfPreviewTitle guifg=#3e8e2d ctermfg=71
          hi BqfPreviewThumb guibg=#3e8e2d ctermbg=71
          hi link BqfPreviewRange Search
      ]])

      require('bqf').setup({
          preview = {
              win_height = 35,
              winblend = 5,
          },
      })
    end
  },

  {
    "mangelozzi/nvim-rgflow.lua",
    init = function()
    require("rgflow").setup(
    {
        default_trigger_mappings  = false,
        default_ui_mappings       = true,
        default_quickfix_mappings = true,

        cmd_flags = ("--smart-case -H -S --sort path --column --line-number --no-heading --ignore-file "..os.getenv("USERPROFILE").."/ignore")
    })
    end
  },

  { "Olical/vim-enmasse", cmd = "EnMasse" },

  { "yssl/QFEnter", enabled = false },

  {
    "airblade/vim-rooter",
    enabled = false,
    init = function()
      vim.g.rooter_silent_chdir = 1
      vim.g.rooter_patterns     = {'.git', '.svn', 'util', 'plugin.xml'}
      vim.g.rooter_manual_only  = 1
    end
  },

  -- {{{ Tabline
  {
    "nanozuki/tabby.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
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
              tab.is_current() and '» ' or ' ',
              tab.number(),
              tab.name(),
              tab.close_btn('x'), -- show a close button
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
              win.is_current() and '»' or ' ',
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
    end,
  },
  -- }}}

  -- {{{ Dial.nvim
  {
    "monaqa/dial.nvim",
    event = "VeryLazy",
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
  -- }}}

  {
    "mhinz/vim-signify",
    enabled=false,
    ft = {'c', 'xml', 'm4', 'h', 'c.m4', 'h.m4'},
    init = function()
      vim.g.signify_disable_by_default = 0
      vim.g.signify_vcs_list = { 'svn', 'git' }
    end
  },


  { "kshenoy/vim-signature", event = "VeryLazy" },

  -- {{{ todo-comments
  {
    "folke/todo-comments.nvim",
    config = function()
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
    end,
  },
  -- }}}

  { "AndrewRadev/linediff.vim", cmd = "Linediff" },

  { "mbbill/undotree" },

  -- {{{ Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    opts = {
      highlight = { enable = true },
      indent = { enable = false },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
  },
  -- }}}

  {
    "cocopon/vaffle.vim",
    init = function()
      local function customize_vaffle_mappings()
        vim.api.nvim_buf_set_keymap(0, 'n', 'U', '<Plug>(vaffle-open-root)', { noremap = false, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', 'u', '<Plug>(vaffle-open-parent)', { noremap = false, silent = true })
      end

      vim.api.nvim_create_augroup('vimrc_vaffle', { clear = true })
      vim.api.nvim_create_autocmd('FileType', { group = 'vimrc_vaffle', pattern = 'vaffle', callback = customize_vaffle_mappings })
    end
  },

  { "nlknguyen/papercolor-theme", priority = 1000 },

  { "rakr/vim-one", priority = 1000 },

  -- {{ Mini.nvim
  {
    "echasnovski/mini.nvim",
    init = function()
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

      require('mini.pairs').setup()

      -- gS, go split TODO: it seems it removes characters
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

      -- {{{ mini.surround
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
      -- }}}

      require('mini.diff').setup()
      vim.keymap.set('n', '<leader>go', ':lua MiniDiff.toggle_overlay()<CR>', { desc = 'Toggle Diff Overlay' })

      -- TODO: replace tabby with this one after removing the buffers from the tab
      -- require('mini.tabline').setup({})

      require('mini.splitjoin').setup()

    end,

    vim.keymap.set("n", "<leader>n", function()
          MiniPick.builtin.files({}, {
            source = {
              cwd = vim.fs.root(0, root_patterns),
            },
          })
        end, { desc = "Find files in project" })

  },
  -- }}

  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },

  {
    'akinsho/toggleterm.nvim',
    event = "VeryLazy",
    version = "*",
    config = true
  },

  {
     "folke/trouble.nvim",
     enabled=false,
     cmd = "Trouble",
     dependencies = { "nvim-tree/nvim-web-devicons" },
     opts = {},
  },

  {
      "ctrlpvim/ctrlp.vim",
      init = function()
        vim.g.ctrlp_max_history = 4000
        vim.g.ctrlp_user_command = 'rg %s --files --color=never --glob ""'
        vim.g.ctrlp_use_caching = 0
      end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 900
    end,
    opts = {}
  },

  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  {
    "tenxsoydev/size-matters.nvim",
    init = function()
      require("size-matters").setup()
    end,
  },

}
)
-- }}}

-- {{{ Mappings

vim.keymap.set("n", "<leader>r", function()
   require('rgflow').open(vim.fn.expand("<cword>"), nil, vim.fs.root(0, root_patterns), nil)
end, {noremap = true})

vim.keymap.set("n", "<leader>e", function()
   require('rgflow').open(nil, nil, vim.fs.root(0, root_patterns), nil)
end, {noremap = true})

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Synchronized scroll
map('n', '<Leader>sz', ':set scb!<CR>', opts)

-- Delete inactive buffers
map('n', '<Leader>db', ':call DeleteInactiveBufs()<CR>', opts)

map('n', '<Leader>dd', ':diffthis<CR>', opts)
map('n', '<Leader>do', ':diffoff<CR>', opts)
map('n', '<Leader>dp', ':diffput<CR>', opts)
map('n', '<Leader>dg', ':diffget<CR>', opts)
map('n', '<Leader>du', ':diffupdate<CR>', opts)
map('v', '<Leader>ld', ':Linediff<CR>', opts)

map('n', '<Leader>m', ':CtrlPMRUFiles<CR>', opts)
map('n', '<Leader>st', ':call StripTrailingWhitespaces()<CR>', opts)
map('n', '<Leader>sw', ':set wrap!<CR>', opts)
map('n', '<Leader>tc', ':tabclose<CR>', opts)
map('n', '<Leader>tn', ':tabnew<CR>', opts)
map('n', '<Leader>/', ':nohlsearch<CR>', opts)
map('n', '<Leader>c', ':call ToggleColorColumn()<CR>', opts)
map('n', '<leader>S', ':Pick spellsuggest<CR>', opts)
map('n', '<leader>ov', ':exe ":silent !code %"<CR>:redraw!<CR>', opts)

-- Ack current word
-- local rootDir = vim.fn["FindRootDirectory"]()
-- map('n', '<Leader>e', ':Ack  <C-R>='..rootDir..'<C-Left><C-Left><C-Left><C-Left><C-Right><Right>', opts)
--
-- -- Ack word under cursor
-- map('n', '<Leader>r', ':Ack <C-R><C-W> <C-R>=FindRootDirectory()<CR><C-Left><C-Left><C-Left><C-Left><C-Right><Right><CR>', opts)

-- Remap jj to <Esc> in insert mode
map('i', 'jj', '<Esc>', {noremap = true})

-- Paste from clipboard in insert mode
map('i', '<S-Insert>', '<C-R>+', opts)

-- Replace the selection with the buffer
map('v', 'r', '"_dp', opts)

-- Change into the black hole register to not clobber the last yank
map('n', 'c', '"_c', opts)

-- Select last visual block
map('n', 'gp', '`[v`]', opts)

-- Find file under cursor in the same window
map('n', 'gf', 'gF', opts)

-- Replace a word with yanked text
map('n', '<leader>rp', 'viw"0p', opts)

-- Navigate 5x faster when holding down Ctrl
map('n', '<C-j>', '5j', { noremap = true })
map('n', '<C-k>', '5k', { noremap = true })
map('n', '<C-h>', '5h', { noremap = true })
map('n', '<C-l>', '5l', { noremap = true })
map('v', '<C-j>', '5j', { noremap = true })
map('v', '<C-k>', '5k', { noremap = true })
map('v', '<C-h>', '5h', { noremap = true })
map('v', '<C-l>', '5l', { noremap = true })

-- Move normally between wrapped lines
map('n', 'j', 'gj', { noremap = true })
map('n', 'k', 'gk', { noremap = true })

-- Window navigation
map('n', '<A-k>', ':wincmd k<CR>', opts)
map('n', '<A-j>', ':wincmd j<CR>', opts)
map('n', '<A-h>', ':wincmd h<CR>', opts)
map('n', '<A-l>', ':wincmd l<CR>', opts)
map('t', '<A-k>', '<C-\\><C-N>:wincmd k<CR>', opts)
map('t', '<A-j>', '<C-\\><C-N>:wincmd j<CR>', opts)
map('t', '<A-h>', '<C-\\><C-N>:wincmd h<CR>', opts)
map('t', '<A-l>', '<C-\\><C-N>:wincmd l<CR>', opts)

-- To map <Esc> to exit terminal-mode
map('t', '<Esc>', '<C-\\><C-n>', opts)

-- Resize windows
map('n', '<S-k>', ':resize +5<CR>', opts)
map('n', '<S-j>', ':resize -5<CR>', opts)
map('n', '<S-l>', ':vertical resize +5<CR>', opts)
map('n', '<S-h>', ':vertical resize -5<CR>', opts)

-- Go to previous visited locations
map('n', '<C-t>', '<C-o>', opts)
map('n', '<A-Left>', '<C-o>', opts)
map('n', '<A-Right>', '<C-i>', opts)

-- Buffer navigation
map('n', ']b', ':bnext<CR>', opts)
map('n', '[b', ':bprevious<CR>', opts)

map('n', ']t', ':tabnext<CR>', opts)
map('n', '[t', ':tabprevious<CR>', opts)

map('n', ']l', ':lnext<CR>', opts)
map('n', '[l', ':lprev<CR>', opts)
map('n', '<C-Down>', ']c', opts)
map('n', '<C-Up>', '[c', opts)

-- Faster indentation
map('n', '>', '>>', opts)
map('n', '<', '<<', opts)

-- F* mappings
map('n', '<F2>', ':cprevious<CR>', opts)
map('n', '<F3>', ':cnext<CR>', opts)
map('n', '<F10>', ':call ToggleNumber()<CR>', opts)

-- Play macros with Q
map('n', 'Q', '@a', opts)
map('v', 'Q', ':norm @a<CR>', opts)
map('n', 'qq', 'ZZ<CR>', opts)

-- Search but don't jump to the next word
map('n', '*', '*``', opts)

-- Fix for legacy vi inconsistency
map('n', 'Y', 'y$', opts)

-- Remap VIM 0 to first non-blank character
map('n', '0', '^', opts)

-- }}}

-- {{{ Scratchpad
local function scratch()
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'hide'
  vim.bo.swapfile = false
end

vim.api.nvim_create_user_command('Scratch', function() vim.cmd('enew') scratch() end, { nargs = 0 })
vim.api.nvim_create_user_command('SScratch', function() vim.cmd('split') vim.cmd('enew') scratch() end, { nargs = 0 })
vim.api.nvim_create_user_command('VScratch', function() vim.cmd('vsplit') vim.cmd('enew') scratch() end, { nargs = 0 })
-- }}}

-- TODO: replace vim-rooter
local augroup = vim.api.nvim_create_augroup('AutoCD', {})

vim.api.nvim_create_autocmd({ 'VimEnter', 'BufEnter', 'BufReadPost' }, {
    desc = 'Automatically change current directory by matching root pattern',
    group = augroup,
    callback = function(args)
        local root = vim.fs.root(vim.api.nvim_buf_get_name(args.buf), root_patterns)

        if root ~= nil then
            vim.api.nvim_set_current_dir(root)
        end
    end,
})

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

if vim.g.neovide then
  vim.g.neovide_fullscreen = false
  vim.g.neovide_cursor_animation_length = 0
end
EOF

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
" set directory=~/vim_undo
" set backupdir=~/vim_undo

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
let g:loaded_matchit           = 1

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

set title

let &errorformat="%f:%l:%c:%m"

" C stuff
set cino+=(0             "Align paramater lists after newline under '('

set dictionary+=$HOME\words.txt

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

function! ToggleVerbose()
    if !&verbose
        set verbosefile=$HOME\vim_undo\vb.txt
        set verbose=12
    else
        set verbose=0
        set verbosefile=
    endif
endfunction

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

" TODO list
"
" [ ] remap quickfix window map for split(now on C-X)
" [ ] which-key takes a lot of time in C-R

" ex: set foldmethod=marker
