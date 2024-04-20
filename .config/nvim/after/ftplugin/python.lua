-- Execute function to set venv for python files

local loaded, project_nvim = pcall(require, "project_nvim.project")
if not loaded then
	print("Error: failed to load the project_nvim.project module")
	return
end

local project_dir, _ = project_nvim.get_project_root()
if not project_dir then
	print("Error: failed to get project root")
	return
end
local venv = project_dir .. "/.venv/bin/activate"
print(venv)
if vim.fn.filereadable(venv) == 1 then
	vim.fn.system("source " .. venv)
else
	print("Error: failed to activate venv")
end
