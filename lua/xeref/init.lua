local M = {}

function M.setup()
	vim.api.nvim_create_user_command("Xeref", M.copy_method_ref, {})
end

function M.copy_method_ref()
	local ts_utils = require("nvim-treesitter.ts_utils")
	local parsers = require("nvim-treesitter.parsers")
	local bufnr = vim.api.nvim_get_current_buf()

	if parsers.get_buf_lang() ~= "ruby" then
		print("xeref currently only supports Ruby")
		return
	end

	-- Find the smallest treesitter node that contains the cursor
	local node = ts_utils.get_node_at_cursor()

	if not node then
		print("No Treesitter node found at cursor")
		return
	end

	-- Traverse up the syntax tree
	local method_name
	local class_and_namespaces = {}
	while node do
		local node_type = node:type()
		if node_type == "method" or node_type == "singleton_method" then
			for child in node:iter_children() do
				if child:type() == "identifier" then
					method_name = vim.treesitter.get_node_text(child, bufnr)
				end
			end
		elseif node_type == "class" or node_type == "module" then
			for child in node:iter_children() do
				if child:type() == "constant" then
					table.insert(class_and_namespaces, vim.treesitter.get_node_text(child, bufnr))
				elseif child:type() == "scope_resolution" then -- Matches "module Foo::Bar"
					for scope_child in child:iter_children() do
						if scope_child:type() == "constant" then
							table.insert(class_and_namespaces, vim.treesitter.get_node_text(scope_child, bufnr))
						end
					end
				end
			end
		end

		if node:parent() == nil then
			break
		end
		node = node:parent()
	end

	if not method_name then
		print("Cursor is not inside a method")
		return
	end

	-- GrandParent::Parent#method
	local method_ref = table.concat(vim.fn.reverse(class_and_namespaces), "::") .. "#" .. method_name

	-- Copy the method ref to register synced with system clipboard
	vim.fn.setreg("+", method_ref)

	print("Copied " .. method_ref)
end

return M
