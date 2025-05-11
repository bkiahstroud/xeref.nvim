# xeref.nvim

A Neovim plugin for copying the reference to a method that the cursor is within.

## Supported Languages

> [!NOTE]
> If you would like `xeref.nvim` to support a language not in this list, please
> open a ticket or submit a PR.

- Ruby

## Dependencies

- [nvim-treesitter][2]

## Installation

### Using [Lazy.nvim][1]

```lua
return {
  "bkiahstroud/xeref.nvim",
}
```

## Usage

`xeref.nvim` has no default keymaps. Its functionality is exposed via the
plugin's API or the `Xeref` command. Users may use either of these when defining
their own keymap, for example:

```lua
vim.keymap.set("n", "<leader>yr", function()
  require("xeref").copy_method_ref()
end)
-- or
vim.keymap.set("n", "<leader>yr", "<cmd>Xeref<cr>")
```

## Why "xeref"?

Portmanteau of "Xerox" and "reference".

[1]: https://github.com/folke/lazy.nvim
[2]: https://github.com/nvim-treesitter/nvim-treesitter
