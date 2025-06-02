local get_hovered_file = ya.sync(function()
	return cx.active.current.hovered.name
end)

return {
	entry = function()
		local hovered_file_name = get_hovered_file()
		local output, err =
			Command("git"):arg({ "ls-tree", "--full-name", "--name-only", "HEAD", hovered_file_name }):output()

		if output.stderr ~= "" then
			ya.notify({
				title = "Error",
				content = output.stderr,
				timeout = 3,
				level = "error",
			})
		else
			if output.stdout == "" then
				ya.notify({
					title = "",
					content = "Nothing is copied. The file is probably not in git index",
					timeout = 3,
					level = "info",
				})
			else
				ya.clipboard(output.stdout:gsub("[\r\n]", ""))
				ya.notify({
					title = "",
					content = string.format("%s is copied", output.stdout),
					timeout = 3,
					level = "info",
				})
			end
		end
	end,
}
