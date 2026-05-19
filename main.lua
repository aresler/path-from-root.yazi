--- @type fun(): Url|nil
local get_hovered_file = ya.sync(function()
	local hovered = cx.active.current.hovered
	return hovered and hovered.url
end)

--- @param str string|nil
local function trim_newlines(str)
	return (str or ""):gsub("[\r\n]", "")
end

--- @param content string
--- @param level? "info"|"warn"|"error"
--- @param title? string
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
		local hovered_file = get_hovered_file()

		if not hovered_file or hovered_file.name == "" then
			notify("Nothing is copied. No hovered file", "warn")
			return
		end

		local cwd = hovered_file.parent

		local prefix, err = Command("git"):arg({ "rev-parse", "--show-prefix" }):cwd(tostring(cwd)):output()
		if not prefix or not prefix.status.success then
			local error = err or prefix and prefix.stderr
			notify(tostring(error), "error", "Error")
			return
		end

		local relative_path = trim_newlines(prefix.stdout) .. hovered_file.name
		ya.clipboard(relative_path)
		notify(string.format("%s is copied", relative_path))
	end,
}
