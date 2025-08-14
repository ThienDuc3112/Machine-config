-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
  "html",
  "cssls",
  "ts_ls",
  "tailwindcss",
  "gopls",
  -- "sqls",
  "clangd",
  -- "pylsp",
  "hdl_checker",
  "rust_analyzer",
}
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

lspconfig.jsonls.setup {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

lspconfig.pylsp.setup {
  on_attach = nvlsp.on_attach,
  filetypes = { "python" },
  settings = {
    configurationSources = { "flake8" },
    formatCommand = { "black" },
    pylsp = {
      plugins = {
        -- jedi_completion = {fuzzy = true},
        -- jedi_completion = {eager=true},
        jedi_completion = {
          include_params = true,
        },
        jedi_signature_help = { enabled = true },
        jedi = {
          extra_paths = { "~/projects/work_odoo/odoo14", "~/projects/work_odoo/odoo14" },
          -- environment = {"odoo"},
        },
        pyflakes = { enabled = true },
        -- pylint = {args = {'--ignore=E501,E231', '-'}, enabled=true, debounce=200},
        pylsp_mypy = { enabled = false },
        pycodestyle = {
          enabled = true,
          ignore = { "E501", "E231" },
          maxLineLength = 120,
        },
        yapf = { enabled = true },
      },
    },
  },
}

-- Lua language server configuration
lspconfig.lua_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_dir = function(fname)
    -- Try to find a proper root using Git or Lua config files
    local root = lspconfig.util.find_git_ancestor(fname)
    if root then
      return root -- If Git repository exists, use it as the root
    end
    -- Otherwise, fallback to finding Lua configuration files
    local root_pattern = lspconfig.util.root_pattern(
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml",
      ".git"
    )
    -- If no root config found, fallback to current working directory
    return root_pattern(fname) or vim.fn.getcwd()
  end,
  single_file_support = true, -- Support for single Lua files
}

lspconfig.sqls.setup {
  on_attach = function(client, _)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
