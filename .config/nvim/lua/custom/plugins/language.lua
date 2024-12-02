return {
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
        opts = {
            name = ".venv",
            auto_refresh = false,
            search_venv_managers = false,
            dap_enabled = true,
        },
        event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
        branch = "regexp",
        keys = {
            { "<leader>vs", "<cmd>VenvSelect<cr>" },
            { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
        },
    },
    {
        "j-hui/fidget.nvim",
        opts = {},
    },
    { -- LSP Configuration & Plugins

        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "j-hui/fidget.nvim", opts = {} },
            { "folke/neodev.nvim", opts = {} },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc) vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc }) end
                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
                    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                    map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                    map("K", vim.lsp.buf.hover, "Hover Documentation")
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        map("<leader>th", function() vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled()) end, "[T]oggle Inlay [H]ints")
                    end
                end,
            })
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
            -- require("lspconfig")["pylsp"].setup({
            --     capabilities = capabilities,
            -- })
            local servers = {
                pylsp = {
                    plugins = {
                        -- jedi_completion = {fuzzy = true},
                        -- jedi_completion = {eager=true},
                        jedi_completion = {
                            include_params = true,
                        },
                        jedi_signature_help = { enabled = true },
                        rope_completion = { enabled = true },
                        rope_auto_import = { enabled = true },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
            }
            require("mason").setup()
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua", -- Used to format Lua code
                "flake8", -- Used for Python
                "isort", -- Used for Python
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },

    -- {
    --     "pmizio/typescript-tools.nvim",
    --     dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    --     opts = {
    --         tsserver_file_preferences = {
    --             includeInlayParameterNameHints = "all",
    --             includeCompletionsForModuleExports = true,
    --             format_on_save = false,
    --         },
    --     },
    -- },

    { -- Autoformat
        "stevearc/conform.nvim",
        lazy = false,
        keys = {
            {
                "<leader>f",
                function() require("conform").format({ async = true, lsp_fallback = true }) end,
                mode = "",
                desc = "[F]ormat buffer",
            },
        },
        opts = {
            notify_on_error = true,
            format_on_save = function(bufnr)
                local disable_filetypes =
                    { c = true, cpp = true, typescript = false, javascript = false, python = false, typescriptreact = false, javascriptreact = false }
                return {
                    timeout_ms = 2000,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                json = { { "prettierd", "prettier" } },
                -- javascript = { { "prettierd", "prettier" } },
                markdown = { { "markdownlint" } },
                -- typescript = { { "prettierd", "prettier" } },
            },
        },
    },

    { -- Autocompletion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then return end
                    return "make install_jsregexp"
                end)(),
                dependencies = {},
            },
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim",
            {
                "hrsh7th/cmp-nvim-lsp",
                event = "InsertEnter",
                dependencies = {
                    "L3MON4D3/LuaSnip", -- Snippet engine
                    "saadparwaiz1/cmp_luasnip", -- Snippet completion source
                    "hrsh7th/cmp-nvim-lsp", -- LSP completion source
                    "hrsh7th/cmp-buffer", -- Buffer completion source
                    "hrsh7th/cmp-path", -- Path completion source
                },
                config = function()
                    local cmp = require("cmp")
                    local luasnip = require("luasnip")
                    local lspkind = require("lspkind")

                    cmp.setup({
                        snippet = {
                            expand = function(args) luasnip.lsp_expand(args.body) end,
                        },
                        mapping = cmp.mapping.preset.insert({
                            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                            ["<C-f>"] = cmp.mapping.scroll_docs(4),
                            ["<C-Space>"] = cmp.mapping.complete(),
                            ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept the currently selected item
                            ["<C-e>"] = cmp.mapping.abort(),
                            ["<C-l>"] = cmp.mapping(function()
                                if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
                            end, { "i", "s" }),
                            ["<C-h>"] = cmp.mapping(function()
                                if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
                            end, { "i", "s" }),
                        }),
                        sources = cmp.config.sources({
                            { name = "nvim_lsp" },
                            { name = "luasnip" },
                            { name = "buffer" },
                            { name = "path" },
                        }),
                        formatting = {
                            format = lspkind.cmp_format({ with_text = true, maxwidth = 50, mode = "symbol" }),
                        },
                    })

                    local capabilities = require("cmp_nvim_lsp").default_capabilities()
                end,
            },
            "hrsh7th/cmp-path",
        },
    },
}
