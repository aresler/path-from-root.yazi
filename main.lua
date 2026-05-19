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

		local prefix, err = Command("git"):arg({ "rev-parse", "--show-prefix" }):output()
		if not prefix or not prefix.status.success then
			local error = err or prefix and prefix.stderr
			notify(tostring(error), "error", "Error")
			return
		end

		local relative_path = trim_newlines(prefix.stdout) .. hovered_file_name
		ya.clipboard(relative_path)
		notify(string.format("%s is copied", relative_path))
	end,
}
