-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        { "\\", ":Neotree reveal<CR>", { desc = "NeoTree reveal" } },
    },
    opts = {
        filesystem = {
            window = {
                mappings = {
                    ["\\"] = "close_window",
                    ["Y"] = function(state)
                        -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
                        -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
                        local node = state.tree:get_node()
                        local filepath = node:get_id()
                        local filename = node.name
                        local modify = vim.fn.fnamemodify

                        local results = {
                            filepath,
                            modify(filepath, ":."),
                            modify(filepath, ":~"),
                            filename,
                            modify(filename, ":r"),
                            modify(filename, ":e"),
                        }

                        vim.ui.select({
                            "1. Absolute path: " .. results[1],
                            "2. Path relative to CWD: " .. results[2],
                            "3. Path relative to HOME: " .. results[3],
                            "4. Filename: " .. results[4],
                            "5. Filename without extension: " .. results[5],
                            "6. Extension of the filename: " .. results[6],
                        }, { prompt = "Choose to copy to clipboard:" }, function(choice)
                            local i = tonumber(choice:sub(1, 1))
                            local result = results[i]
                            vim.fn.setreg('"', result)
                            vim.notify("Copied: " .. result)
                        end)
                    end,
                },
            },
            filtered_items = {
                visible = true,
            },
        },
    },
}
