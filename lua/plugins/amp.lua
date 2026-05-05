-- Amp Plugin
return {
  "sourcegraph/amp.nvim",
  branch = "main",
  cmd = { "AmpStart", "AmpStop", "AmpStatus", "AmpTest" },
  opts = { auto_start = false, log_level = "info" },
}
