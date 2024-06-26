-- {{{ Mandatory editor settings
if vim.fn.has("win32") == 1 then
  vim.g.configForWork        = 1
  vim.g.python3_host_prog    = 'C:/ProgramData/chocolatey/bin/python3.12.EXE'
  vim.g.python_host_prog     = 'C:/Python27/python.exe'
  vim.g.loaded_perl_provider = 0
  vim.g.loaded_node_provider = 0
  vim.g.loaded_ruby_provider = 0
end
--}}}

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

  -- {{{ Mini.nvim
  {
    "echasnovski/mini.nvim",
    init = function()
      require('mini.basics').setup()

      require('mini.ai').setup()

      require('mini.align').setup({
        mappings = {
          start = '<Enter>',
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

      -- {{{ mini.surround
      require('mini.surround').setup({
        mappings = {
          add            = 'S', -- Add surrounding in Normal and Visual modes
          delete         = 'ds', -- Delete surrounding
          replace        = 'cs', -- Replace surrounding
          update_n_lines = 'sn', -- Update `n_lines`

          suffix_last    = 'l', -- Suffix to search with "prev" method
          suffix_next    = 'n', -- Suffix to search with "next" method
        },
        n_lines = 120,
      })
      -- }}}

      require('mini.diff').setup()
      vim.keymap.set('n', '<leader>go', ':lua MiniDiff.toggle_overlay()<CR>', { desc = 'Toggle Diff Overlay' })

      -- TODO: replace tabby with this one after removing the buffers from the tab
      -- require('mini.tabline').setup({})
      vim.o.showtabline = 2
      vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'

      require('mini.splitjoin').setup()

      -- {{{ Mini.clues
      local miniclue = require('mini.clue')
      miniclue.setup({
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },

        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      })
      -- }}}

      require('mini.bracketed').setup()

      require('mini.git').setup()

      -- {{{ mini.hipatterns
      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        highlighters = {
          fixme = { pattern = '%f[%w]()FIXME:()%f[%W]', group = 'MiniHipatternsFixme' },
          hack  = { pattern = '%f[%w]()HACK:()%f[%W]',  group = 'MiniHipatternsHack'  },
          error = { pattern = '%f[%w]()ERROR:()%f[%W]', group = 'MiniHipatternsHack'  },
          warn  = { pattern = '%f[%w]()WARN:()%f[%W]',  group = 'MiniHipatternsHack'  },
          todo  = { pattern = '%f[%w]()TODO:()%f[%W]',  group = 'MiniHipatternsTodo'  },
          note  = { pattern = '%f[%w]()NOTE:()%f[%W]',  group = 'MiniHipatternsNote'  },

          hex_color = hipatterns.gen_highlighter.hex_color(),
        },

      })
    -- }}}

    require('mini.notify').setup({
      lsp_progress = {
        enable = false,
      },
    })

    require('mini.operators').setup()

    require('mini.trailspace').setup()

    end, -- end of mini

  },
  -- }}}

  -- {{{ Mark:
  {
    "inkarkat/vim-mark",
    event = "VeryLazy",
    dependencies = {
      "inkarkat/vim-ingo-library"
    },
    init = function()
        vim.g.mw_no_mappings               = 1
        vim.g.mwDefaultHighlightingPalette = 'extended'
    end,
  },
  -- }}}

  -- {{{ RipGrep plugins
  {
    "wincent/ferret",
    dependencies = {
      "yssl/QFEnter",
    },
    init = function()
      vim.g.FerretAutojump            = 0
      vim.g.FerretHlsearch            = 1
      vim.g.FerretMap                 = 0
      vim.g.FerretQFCommands          = 0
      vim.g.FerretExecutableArguments = { rg = '-H -S --sort path --column --line-number --no-heading --ignore-file '..vim.env.HOME..'/ignore' }

      vim.g.qfenter_keymap = {
        open = { '<CR>' },
        vopen = { '<C-v>' },
        hopen = { '<C-s>' },
        topen = { '<C-t>' },
      }

      -- keep the quickfix window open
      vim.cmd('autocmd FileType qf nnoremap <buffer> <C-t> <C-w><CR><C-w>T')

    end
  },

  { "Olical/vim-enmasse", cmd = "EnMasse" },

  --}}}

  -- {{{ Tabline
  {
    "nanozuki/tabby.nvim",
    enabled = true,
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      vim.o.showtabline = 2
      vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'
      local theme = {
        fill = 'TabLineFill',
        head = 'TabLine',
        current_tab = { fg = '#F8FBF6', bg = '#887a95', style = 'italic' },
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
        default = {
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.new{ elements = {"true", "false"} },
          augend.constant.new{ elements = {"TRUE", "FALSE"} },
          augend.constant.new{ elements = {"E_OK", "E_NOT_OK"} },
          augend.constant.new{ elements = {"DCM_INITIAL", "DCM_CANCEL", "DCM_E_PENDING", "DCM_E_FORCE_RCRRP"} },
        },
      }

      vim.keymap.set("n", "<C-a>", function() require("dial.map").manipulate("increment", "normal") end)
      vim.keymap.set("n", "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end)
      vim.keymap.set("n", "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end)
      vim.keymap.set("n", "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end)
      vim.keymap.set("v", "<C-a>", function() require("dial.map").manipulate("increment", "visual") end)
      vim.keymap.set("v", "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end)
      vim.keymap.set("v", "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end)
      vim.keymap.set("v", "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end)
    end,
  },
  -- }}}

  -- {{{ Marks.nvim
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    init = function()
      require'marks'.setup({})
    end,
  },
  --}}}

  { "AndrewRadev/linediff.vim", cmd = "Linediff" },

  { "mbbill/undotree" },

  { "bfrg/vim-cpp-modern" },

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
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua" },
				auto_install = true,
				highlight = { enable = true },
			})
		end,
  },
  -- }}}

  -- {{{ Vaffle
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
  -- }}}

  { "nlknguyen/papercolor-theme", priority = 1000 },

  { "rakr/vim-one", priority = 1000 },

  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },

  {
      "ctrlpvim/ctrlp.vim",
      init = function()
        vim.g.ctrlp_max_history = 4000
        vim.g.ctrlp_user_command = 'rg %s --files --color=never --glob ""'
        vim.g.ctrlp_use_caching = 0
      end,
  },

  -- {{{ indent-blankline.nvim
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
  -- }}}

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
    -- zoom plugin
    "tenxsoydev/size-matters.nvim",
    init = function()
      require("size-matters").setup()
    end,
  },

  {
    -- TODO: check this one, seems interesting
    "LeonHeidelbach/trailblazer.nvim",
    enabled=false,
    init = function()
        require("trailblazer").setup({})
    end,
  },

  { "folke/neodev.nvim", opts = {} },

  -- {{{ nvim-cmp
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- other sources
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',

    },
    config = function()
      local cmp = require 'cmp'
      local cmp_kinds = { Text = '  ', Method = '  ', Function = '  ', Constructor = '  ',
        Field = '  ', Variable = '  ', Class = '  ', Interface = '  ', Module = '  ', Property = '  ',
        Unit = '  ', Value = '  ', Enum = '  ', Keyword = '  ', Color = '  ',
        File = '  ', Reference = '  ', Folder = '  ', EnumMember = '  ', Constant = '  ', Struct = '  ',
        Event = '  ', Operator = '  ', TypeParameter = '  ' }
      local border_opts = { border = "rounded", winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None" }
      cmp.setup {
        formatting = {
          fields = { 'abbr', 'kind' },
          format = function(_, item) item.kind = (cmp_kinds[item.kind] or '') .. item.kind return item end,
        },
        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },
        experimental = { ghost_text = true },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Replace }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Replace }),
          ['<C-e>'] = cmp.mapping.scroll_docs(-4),
          ['<C-y>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = function(fallback) if cmp.visible() and cmp.get_active_entry() then cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }) else fallback() end end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        },
      }
    end,
  },
  -- }}}

  -- {{{ nvim-lspconfig
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true, event = "VeryLazy" },
      { 'williamboman/mason-lspconfig.nvim', event = "VeryLazy", },

      -- Additional lua configuration, makes nvim tinkering amazing!
      'folke/neodev.nvim',
    },
    config = function()

      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
          if desc then desc = ' ' .. desc end
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end
        nmap('<leader>k', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<leader>K', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_) vim.lsp.buf.format() end, { desc = 'Format current buffer with LSP' })

        -- Range formatting via motion.
        -- https://github.com/neovim/neovim/issues/14680
        local operator_register = function(name, fn)
          _G[name] = function(type)
            if type == nil then vim.opt.opfunc = 'v:lua.' .. name return 'g@' -- calls back to this function
            end
            -- boilerplate save, see :help g@
            local sel_save = vim.opt.selection
            local reg_save = vim.fn.getreginfo('"')
            local cb_save = vim.opt.clipboard
            local visual_marks_save = { vim.fn.getpos("'<"), vim.fn.getpos("'>") }

            -- boilerplate setup
            vim.opt.clipboard = ''
            vim.opt.selection = 'inclusive'

            local status, err = pcall(fn, type)

            -- boilerplate restore
            vim.fn.setreg('"', reg_save)
            vim.fn.setpos("'<", visual_marks_save[0])
            vim.fn.setpos("'>", visual_marks_save[1])
            vim.opt.clipboard = cb_save
            vim.opt.selection = sel_save

            if not status then
              error(err)
            end
          end
        end
        operator_register('op_format_code', function(type)
          vim.lsp.buf.format {
            range = {
              ['start'] = vim.api.nvim_buf_get_mark(0, '['),
              ['end'] = vim.api.nvim_buf_get_mark(0, ']'),
            },
          }
        end)
      end

      -- Enable the following language servers
      local servers = {
        -- clangd = {
        --   cmd = { 'clangd', '--background-index' }, -- Adjust the command as needed
        --   filetypes = { 'c', 'cpp', 'c.m4', 'h.m4' }, -- Specify the filetypes you're working with
        --   root_dir = function(fname)
        --     -- Customize this function to return the root directory for your project
        --     return vim.fs.root(vim.fn.expand('%:p'), root_patterns) or vim.fn.getcwd()
        --   end,
        -- },
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- tsserver = {},
        -- html = { filetypes = { 'html', 'twig', 'hbs'} },

        lua_ls = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim', 'require' } },
            workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Ensure the servers above are installed
      local mason_lspconfig = require('mason-lspconfig')

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
          }
        end
      }
    end
  },
  -- }}}

  {
    "levouh/tint.nvim",
    init = function()
      require("tint").setup({
        tint = -15,  -- Darken colors, use a positive value to brighten
        saturation = 0.6,  -- Saturation to preserve
      })
    end,

  },

}
)
-- }}}

-- {{{ Mappings

local map  = vim.api.nvim_set_keymap
local mapf = vim.keymap.set
local opts = { noremap = true, silent = true }

map('n', '<Leader>e', ':lua PrepRgCommand()<CR>', { noremap = true, silent = true, desc = "Call ripgrep in the root directory" })
map('n', '<Leader>r', ':lua PrepRgCommand(\'cword\')<CR>', { noremap = true, silent = true, desc = "Call ripgrep with <cword> in the root directory" })
mapf("n", "<leader>n", function() MiniPick.builtin.files({}, { source = { cwd = GetRootDir(), }, }) end, { desc = "Find files in project" })

-- Synchronized scroll
map('n', '<Leader>sz', ':set scb!<CR>',                  { noremap = true, silent = true, desc = "Sync scroll between windows" })

-- Delete inactive buffers
map('n', '<Leader>db', ':call DeleteInactiveBufs()<CR>', { noremap = true, silent = true, desc = "Delette inactive buffers" })

map('n', '<Leader>dd', ':diffthis<CR>',                  { noremap = true, silent = true, desc = "Diff this file" })
map('n', '<Leader>do', ':diffoff<CR>',                   { noremap = true, silent = true, desc = "Diff off" })
map('n', '<Leader>dp', ':diffput<CR>',                   { noremap = true, silent = true, desc = "Diff put" })
map('n', '<Leader>dg', ':diffget<CR>',                   { noremap = true, silent = true, desc = "Diff get" })
map('n', '<Leader>du', ':diffupdate<CR>',                { noremap = true, silent = true, desc = "Diff update" })
map('v', '<Leader>ld', ':Linediff<CR>',                  { noremap = true, silent = true, desc = "Line diff" })

map('n', '<Leader>m',  ':CtrlPMRUFiles<CR>',             { noremap = true, silent = true, desc = "Browse MRU files" })
map('n', '<Leader>st', ':lua MiniTrailspace.trim()<CR>', { noremap = true, silent = true, desc = "Trim trailing spaces" })
map('n', '<Leader>sw', ':set wrap!<CR>',                 { noremap = true, silent = true, desc = "Toggle wrap" })
map('n', '<Leader>tc', ':tabclose<CR>',                  { noremap = true, silent = true, desc = "Tab close" })
map('n', '<Leader>tn', ':tabnew<CR>',                    { noremap = true, silent = true, desc = "Tab new" })
map('n', '<Leader>/',  ':nohlsearch<CR>',                { noremap = true, silent = true, desc = "Clear search term" })
map('n', '<Leader>c',  ':call ToggleColorColumn()<CR>',  { noremap = true, silent = true, desc = "Toggle 100 collumn marker" })
map('n', 'z=',         ':Pick spellsuggest<CR>',         { noremap = true, silent = true, desc = "Pick spelling suggestion" })
map('n', '<leader>ov', ':exe ":silent !code %"<CR>',     { noremap = true, silent = true, desc = "Open in VS-Code" })

-- Remap jj to <Esc> in insert mode
map('i',  'jj',         '<Esc>',                    {noremap = true})

-- Paste from clipboard in insert mode
map('i',  '<S-Insert>', '<C-R>+',                   opts)
mapf('c', '<C-v>',      '<C-R>+'                        )

-- Change into the black hole register to not clobber the last yank
-- map('n',  'c',          '"_c',                      opts)

-- Select last visual block
map('n',  'gp',         '`[v`]',                    opts)

-- Find file under cursor in the same window
map('n',  'gf',         'gF',                       opts)

-- highlight selected word
map('v',  '//',         'y/\\V<C-R>"<CR>',          { noremap = true, silent = true })

-- Navigate 5x faster when holding down Ctrl
map('n',  '<C-j>',      '5j',                       { noremap = true })
map('n',  '<C-k>',      '5k',                       { noremap = true })
map('n',  '<C-h>',      '5h',                       { noremap = true })
map('n',  '<C-l>',      '5l',                       { noremap = true })
map('v',  '<C-j>',      '5j',                       { noremap = true })
map('v',  '<C-k>',      '5k',                       { noremap = true })
map('v',  '<C-h>',      '5h',                       { noremap = true })
map('v',  '<C-l>',      '5l',                       { noremap = true })

-- Window navigation
map('n',  '<A-k>',      ':wincmd k<CR>',            opts)
map('n',  '<A-j>',      ':wincmd j<CR>',            opts)
map('n',  '<A-h>',      ':wincmd h<CR>',            opts)
map('n',  '<A-l>',      ':wincmd l<CR>',            opts)
map('t',  '<A-k>',      '<C-\\><C-N>:wincmd k<CR>', opts)
map('t',  '<A-j>',      '<C-\\><C-N>:wincmd j<CR>', opts)
map('t',  '<A-h>',      '<C-\\><C-N>:wincmd h<CR>', opts)
map('t',  '<A-l>',      '<C-\\><C-N>:wincmd l<CR>', opts)

-- Resize windows
map('n',  '<S-k>',      ':resize +5<CR>',           opts)
map('n',  '<S-j>',      ':resize -5<CR>',           opts)
map('n',  '<S-l>',      ':vertical resize +5<CR>',  opts)
map('n',  '<S-h>',      ':vertical resize -5<CR>',  opts)

-- To map <Esc> to exit terminal-mode
map('t',  '<Esc>',      '<C-\\><C-n>',              opts)

-- Go to previous visited locations
map('n',  '<C-t>',      '<C-o>',                    opts)
map('n',  '<A-Left>',   '<C-o>',                    opts)
map('n',  '<A-Right>',  '<C-i>',                    opts)


-- Buffer navigation
map('n', '<C-Down>', ']c',               opts)
map('n', '<C-Up>',   '[c',               opts)
map('n', ']t',       ':tabnext<CR>',     opts)
map('n', '[t',       ':tabprevious<CR>', opts)

-- Faster indentation
map('n',  '>',          '>>',                       opts)
map('n',  '<',          '<<',                       opts)

-- F* mappings
map('n',  '<F2>',       ':cprevious<CR>',           opts)
map('n',  '<F3>',       ':cnext<CR>',               opts)
map('n',  '<F10>',      ':call ToggleNumber()<CR>', opts)

-- Play macros with Q
map('n',  'Q',          '@a',                       opts)
map('v',  'Q',          ':norm @a<CR>',             opts)
map('n',  'qq',         'ZZ<CR>',                   opts)

-- Search but don't jump to the next word
map('n',  '*',          '*``',                      opts)

-- Fix for legacy vi inconsistency
map('n',  'Y',          'y$',                       opts)

-- Remap VIM 0 to first non-blank character
map('n',  '0',          '^',                        opts)

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

-- {{{ Auto-root
local augroup = vim.api.nvim_create_augroup('AutoCD', {})

vim.api.nvim_create_autocmd({ 'VimEnter', 'BufEnter', 'BufReadPost' }, {
    desc = 'Automatically change current directory by matching root pattern',
    group = augroup,
    callback = function(args)
        local root = GetRootDir()

        if root ~= nil then
            vim.api.nvim_set_current_dir(root)
        end
    end,
})
-- }}}

-- {{{ Editor settings
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

if vim.g.neovide then
  vim.g.neovide_fullscreen = false
  vim.g.neovide_cursor_animation_length = 0
end

-- Boost performance of rendering long lines
vim.opt.synmaxcol = 300

-- How many lines to scroll at a time, make scrolling appear faster
-- vim.opt.scrolljump = 5

if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors              = true
  vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
end

vim.cmd.colorscheme('one')

vim.cmd.syntax     = 'on'
vim.opt.mouse      = 'a'
vim.opt.encoding   = 'utf-8'
vim.scriptencoding = 'utf-8'

vim.opt.clipboard:append('unnamedplus')
vim.opt.foldmethod = "marker"
vim.opt.foldmarker = "{{{,}}}"
vim.opt.autochdir  = true

-- This makes vim act like all other editors, buffers can exist in the background without being in a window.
vim.opt.hidden = true

vim.opt.undofile   = true
vim.opt.undodir    = vim.env.HOME .. '/vim_undo'
vim.opt.undolevels = 10000
vim.opt.undoreload = 10000

-- Set the location for swap files and backup files
vim.opt.directory = vim.env.HOME .. '/vim_undo'
vim.opt.backupdir = vim.env.HOME .. '/vim_undo'

-- Search settings
vim.opt.hlsearch   = true
vim.opt.incsearch  = true

-- Flashes matching brackets or parentheses
vim.opt.showmatch = true

-- Indentation settings
vim.opt.autoindent  = true
vim.opt.smarttab    = true
vim.opt.shiftwidth  = 2
vim.opt.softtabstop = 2
vim.opt.tabstop     = 2
vim.opt.expandtab   = true

-- Scroll settings
vim.opt.scrolloff = 5

-- Language menu
vim.opt.langmenu = 'none'

-- Autoindent (alternative setting)
vim.opt.ai = true

-- Command line completion settings
vim.opt.wildmenu = true
vim.opt.wildmode = 'full'

vim.opt.visualbell = true

vim.opt.history = 1000

-- Disable built-in plugins
vim.g.loaded_2html_plugin      = 1
vim.g.loaded_gzip              = 1
vim.g.loaded_rrhelper          = 1
vim.g.loaded_tarPlugin         = 1
vim.g.loaded_zipPlugin         = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_tarPlugin         = 1
vim.g.loaded_vimballPlugin     = 1
vim.g.loaded_matchit           = 1

-- Show the current line
vim.opt.cul = true

-- Show the filename in the bottom of the window
vim.opt.modeline   = true
vim.opt.laststatus = 2

-- Allow backspacing over everything in insert-mode
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.shortmess = 'aoOTt'

-- If we have 'live substitution', enable it
if vim.fn.exists('&inccommand') == 1 then
  vim.opt.inccommand = 'nosplit'
end

vim.opt.title = true

-- Set error format
vim.opt.errorformat = "%f:%l:%c:%m"

-- Set dictionary
vim.opt.dictionary:append(vim.env.HOME .. '\\words.txt')

-- C indentation settings
vim.opt.cino = vim.opt.cino + '(0'

--}}}

-- {{{ Autocmds

-- Set nowrap for quickfix file type
vim.api.nvim_create_autocmd('FileType', {pattern = 'qf', command = 'set nowrap'})

-- Set row highlight on window enter and leave
vim.api.nvim_create_augroup('BgHighlight', {clear = true })
vim.api.nvim_create_autocmd('WinEnter', {group = 'BgHighlight', command = 'set cul'})
vim.api.nvim_create_autocmd('WinLeave', {group = 'BgHighlight', command = 'set nocul'})

vim.api.nvim_create_autocmd('FileType', {pattern = 'make', command = 'setlocal noexpandtab shiftwidth=8 tabstop=8'})

local autoswap_group = vim.api.nvim_create_augroup('AutoSwap', { clear = true })

local function AS_HandleSwapfile(filename, swapname)
    if vim.fn.getftime(swapname) < vim.fn.getftime(filename) then
        vim.fn.delete(swapname)
        vim.v.swapchoice = 'e'
    end
end

vim.api.nvim_create_autocmd('SwapExists', {
    group = autoswap_group,
    callback = function(args)
        AS_HandleSwapfile(vim.fn.expand('<afile>:p'), args.file)
    end
})
--}}}

--{{{ Functions

function GetRootDir()
  local root_patterns = {'.git', '.svn', 'util', 'plugin.xml'}
  return vim.fs.root(vim.fn.expand('%:p'), root_patterns) or vim.fn.getcwd()
end

function PrepRgCommand(search_term)
    local root_dir = GetRootDir()
    local current_word = ''
    local move_to_term = ''
    if search_term == 'cword' then
      current_word = vim.fn.expand('<cword>')
    else
      move_to_term = '<C-Left><C-Left><C-Left><C-Left><C-Right><Right>'
    end
    local cmd = ':Ack ' .. current_word .. ' ' .. root_dir..move_to_term

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), 'n', true)
end

function ToggleColorColumn()
    if vim.wo.colorcolumn ~= '' then
        vim.wo.colorcolumn = ''
    else
        vim.wo.colorcolumn = '100'
    end
end

function ToggleNumber()
    if vim.wo.relativenumber then
        vim.wo.relativenumber = false
        vim.wo.number = true
    else
        vim.wo.relativenumber = true
    end
end

function DeleteInactiveBufs()
    local current_buffer = vim.api.nvim_get_current_buf()
    local buffers = vim.api.nvim_list_bufs()

    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) and buf ~= current_buffer then
            vim.api.nvim_command('bdelete ' .. buf)
        end
    end
end

function ToggleVerbose()
    if vim.o.verbose == 0 then
        vim.o.verbosefile = vim.fn.expand('$HOME/vim_undo/vb.txt')
        vim.o.verbose = 12
    else
        vim.o.verbose = 0
        vim.o.verbosefile = ''
    end
end
vim.api.nvim_create_user_command('ToggleVerbose', function() ToggleVerbose() end, {})

function Redir(cmd, rng, start, _end)
    for win = 1, vim.fn.winnr('$') do
        if vim.fn.getwinvar(win, 'scratch') ~= '' then
            vim.cmd(win .. 'windo close')
        end
    end

    local output
    if cmd:sub(1, 1) == '!' then
        local shell_cmd = cmd:find(' %%') and cmd:gsub(' %%', ' ' .. vim.fn.expand('%:p')) or cmd:sub(2)
        if rng == 0 then
            output = vim.fn.systemlist(shell_cmd)
        else
            local joined_lines = table.concat(vim.fn.getline(start, _end), '\n')
            local cleaned_lines = joined_lines:gsub("'", "\\'")
            output = vim.fn.systemlist(shell_cmd .. " <<< $" .. cleaned_lines)
        end
    else
        output = vim.fn.split(vim.fn.execute(cmd), "\n")
    end

    vim.cmd('vnew')
    vim.api.nvim_buf_set_var(0, 'scratch', true)
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'wipe'
    vim.bo.buflisted = false
    vim.bo.swapfile = false
    vim.fn.setline(1, output)
end

vim.api.nvim_create_user_command('Redir', function(opts)
    local range = opts.line1 ~= opts.line2
    Redir(opts.args, range and 1 or 0, opts.line1, opts.line2)
end, { nargs = 1, complete = 'command', range = true, bar = true })

function CopyMatches(reg)
    local hits = {}
    vim.cmd([[ %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne ]])
    local register = reg == '' and '+' or reg
    vim.fn.setreg(register, table.concat(hits, "\n") .. "\n")
end
vim.api.nvim_create_user_command('CopyMatches', function(opts) CopyMatches(opts.reg) end, { register = true })

--}}}

if vim.fn.has("win32") == 1 and vim.g.configForWork == 1 then
  local userProfile = vim.fn.substitute(vim.env.USERPROFILE, '\\', '/', 'g')

  -- Work specific things
  vim.cmd('source ' .. userProfile .. '/AppData/Local/nvim/eb.lua')
end

-- TODO list
