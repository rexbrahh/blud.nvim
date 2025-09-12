return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make", -- downloads prebuilt libs if available, else builds
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "stevearc/dressing.nvim",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local ok, avante = pcall(require, "avante")
    if not ok then return end

    local endpoint = os.getenv("OPENAI_API_BASE")
      or os.getenv("OPENROUTER_API_BASE")
      or "https://api.openai.com/v1"

    local model = os.getenv("OPENAI_MODEL") or os.getenv("OPENROUTER_MODEL")
    local api_key_name = (os.getenv("OPENROUTER_API_KEY") and "OPENROUTER_API_KEY") or "OPENAI_API_KEY"

    local openai_conf = { endpoint = endpoint }
    if model and #model > 0 then openai_conf.model = model end
    if api_key_name then openai_conf.api_key_name = api_key_name end

    avante.setup({
      provider = "openai",
      providers = {
        openai = openai_conf,
      },
      behaviour = {
        auto_set_keymaps = false,
      },
    })

    -- Minimal keymaps (use <Plug> mappings to stay future-proof)
    local map = vim.keymap.set
    map({ "n", "v" }, "<leader>aa", "<Plug>(AvanteAsk)", { desc = "Avante: Ask" })
    map({ "n", "v" }, "<leader>aA", "<Plug>(AvanteAskNew)", { desc = "Avante: Ask (new chat)" })
    map({ "n", "v" }, "<leader>ac", "<Plug>(AvanteChat)", { desc = "Avante: Chat" })
    map("v", "<leader>ae", "<Plug>(AvanteEdit)", { desc = "Avante: Edit selection" })
    map("n", "<leader>ar", "<Plug>(AvanteRefresh)", { desc = "Avante: Refresh" })
    map("n", "<leader>az", function() require("avante.api").zen_mode() end, { desc = "Avante: Zen mode" })

    local has_any_key = os.getenv("OPENROUTER_API_KEY") or os.getenv("OPENAI_API_KEY")
    if endpoint:match("openrouter%.ai") and not has_any_key then
      vim.schedule(function()
        vim.notify(
          "Avante: Set OPENROUTER_API_KEY (or OPENAI_API_KEY) and optionally OPENAI_MODEL/OPENROUTER_MODEL.",
          vim.log.levels.WARN
        )
      end)
    elseif (not endpoint or endpoint == "https://api.openai.com/v1") and not has_any_key then
      vim.schedule(function()
        vim.notify("Avante: Set OPENAI_API_KEY to enable the OpenAI provider.", vim.log.levels.WARN)
      end)
    end
  end,
}
