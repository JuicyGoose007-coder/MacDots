-- clangd needs compile_commands.json (CMake: -DCMAKE_EXPORT_COMPILE_COMMANDS=ON)
-- or compile_flags.txt to know include paths and flags.
return {
	cmd = { "clangd" },
	filetypes = { "c", "cpp" },
	root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
}
