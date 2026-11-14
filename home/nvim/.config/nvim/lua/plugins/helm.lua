-- Helm: sets the `helm` filetype for chart templates so helm_ls and the
-- treesitter helm parser attach instead of plain yaml
return {
  "qvalentin/helm-ls.nvim",
  ft = "helm",
  opts = {},
}
