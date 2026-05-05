local function fail(message)
  vim.api.nvim_err_writeln("[docker-install-mason] " .. message)
  vim.cmd("cquit")
end

local function load_plugin(name)
  local ok, lazy = pcall(require, "lazy")
  if not ok then
    fail("lazy.nvim is not available: " .. tostring(lazy))
  end

  local loaded, err = pcall(lazy.load, { plugins = { name } })
  if not loaded then
    fail(("failed to load %s: %s"):format(name, tostring(err)))
  end
end

local function refresh_registry(registry)
  local refreshed = false
  local refresh_ok = true
  local refresh_err = nil

  registry.refresh(function(success, err)
    refresh_ok = success ~= false
    refresh_err = err
    refreshed = true
  end)

  local completed = vim.wait(60000, function()
    return refreshed
  end, 100)

  if not completed then
    fail("timed out refreshing Mason registry")
  end

  if not refresh_ok then
    fail("failed to refresh Mason registry: " .. tostring(refresh_err))
  end
end

local function unique_append(target, seen, name)
  if not seen[name] then
    seen[name] = true
    target[#target + 1] = name
  end
end

local function install_packages(registry, package_names)
  local pending = 0
  local failures = {}

  for _, package_name in ipairs(package_names) do
    local ok, pkg = pcall(registry.get_package, package_name)
    if not ok then
      failures[#failures + 1] = ("%s: %s"):format(package_name, tostring(pkg))
    elseif pkg:is_installed() then
      print(("[docker-install-mason] already installed %s"):format(package_name))
    else
      print(("[docker-install-mason] installing %s"):format(package_name))
      pending = pending + 1
      pkg:install({}, function(success, result)
        if not success or not pkg:is_installed() then
          failures[#failures + 1] = ("%s: %s"):format(package_name, tostring(result))
        end
        pending = pending - 1
      end)
    end
  end

  local completed = vim.wait(600000, function()
    return pending == 0
  end, 200)

  if not completed then
    fail("timed out installing Mason packages")
  end

  if #failures > 0 then
    fail("Mason package installation failed:\n" .. table.concat(failures, "\n"))
  end
end

load_plugin("mason.nvim")
load_plugin("mason-lspconfig.nvim")

local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
  fail("mason.nvim failed to load: " .. tostring(mason))
end
mason.setup()

local registry_ok, registry = pcall(require, "mason-registry")
if not registry_ok then
  fail("mason-registry failed to load: " .. tostring(registry))
end

refresh_registry(registry)

local lsp_servers = {
  "biome",
  "eslint",
  "html",
  "cssls",
  "tailwindcss",
  "jsonls",
  "lua_ls",
  "gopls",
  "basedpyright",
  "ruff",
  "bashls",
  "zls",
  "rust_analyzer",
  "clangd",
  "yamlls",
  "marksman",
  "dockerls",
  "docker_compose_language_service",
  "svelte",
  "astro",
  "graphql",
  "prismals",
  "taplo",
  "lemminx",
  "terraformls",
  "ansiblels",
  "cmake",
}

local dap_packages = {
  "codelldb",
  "delve",
  "debugpy",
  "js-debug-adapter",
}

local mappings = require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package
local packages = {}
local seen = {}
local missing_mappings = {}

for _, server_name in ipairs(lsp_servers) do
  local package_name = mappings[server_name]
  if package_name then
    unique_append(packages, seen, package_name)
  else
    missing_mappings[#missing_mappings + 1] = server_name
  end
end

if #missing_mappings > 0 then
  fail("missing Mason package mappings for LSP servers: " .. table.concat(missing_mappings, ", "))
end

for _, package_name in ipairs(dap_packages) do
  unique_append(packages, seen, package_name)
end

local unavailable = {}
for _, package_name in ipairs(packages) do
  if not registry.has_package(package_name) then
    unavailable[#unavailable + 1] = package_name
  end
end

if #unavailable > 0 then
  fail("Mason registry does not contain packages: " .. table.concat(unavailable, ", "))
end

install_packages(registry, packages)
print(("[docker-install-mason] verified %d Mason packages"):format(#packages))
