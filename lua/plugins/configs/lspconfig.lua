local present, lspconfig = pcall(require, "lspconfig")

if not present then
   return
end

local M = {}

require("plugins.configs.others").lsp_handlers()

function M.on_attach(client, _)
   client.resolved_capabilities.document_formatting = false
   client.resolved_capabilities.document_range_formatting = false

   require("core.mappings").lspconfig()
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
   properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
   },
}

lspconfig.sumneko_lua.setup {
   on_attach = M.on_attach,
   capabilities = capabilities,

   settings = {
      Lua = {
         diagnostics = {
            globals = { "vim" },
         },
         workspace = {
            library = {
               [vim.fn.expand "$VIMRUNTIME/lua"] = true,
               [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
         },
      },
   },
}

lspconfig.pyright.setup {
  on_attach = function(client, bufnr)
     client.resolved_capabilities.document_formatting = false
     vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>", {})
     vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", {})
     vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {})
     -- vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")  # auto format when save
     vim.api.nvim_buf_set_keymap(bufnr, "n", "ge", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", {})
  end,
}

-- requires a file containing user's lspconfigs
local addlsp_confs = require("core.utils").load_config().plugins.options.lspconfig.setup_lspconf

if #addlsp_confs ~= 0 then
   require(addlsp_confs).setup_lsp(M.on_attach, capabilities)
end

return M
