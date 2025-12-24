local get_hovered_file = ya.sync(function()
	return cx.active.current.hovered and cx.active.current.hovered.name or nil
end)

local function trim_newlines(str)
	return (str or ""):gsub("[\r\n]", "")
end

local function notify(content, level, title)
	ya.notify({
		title = title or "",
		content = content,
		timeout = 3,
		level = level or "info",
	})
end

return {
	entry = function()
		local hovered_file_name = get_hovered_file()

		if not hovered_file_name or hovered_file_name == "" then
			notify("Nothing is copied. No hovered file", "warn")
			return
		end

		-- Ask git for repo root and current prefix so untracked files still work.
		local root_output = Command("git"):arg({ "rev-parse", "--show-toplevel" }):output()
		if root_output.stderr ~= "" or root_output.stdout == "" then
			notify("Nothing is copied. Not inside a git repo", "warn")
			return
		end

		local prefix_output = Command("git"):arg({ "rev-parse", "--show-prefix" }):output()
		if prefix_output.stderr ~= "" then
			notify(prefix_output.stderr, "error", "Error")
			return
		end

		local relative_path = trim_newlines(prefix_output.stdout) .. hovered_file_name
		ya.clipboard(relative_path)
		notify(string.format("%s is copied", relative_path))
	end,
}
