-- jdtls keeps an index per project in its -data dir; sharing one dir
-- across projects corrupts it, so derive the dir from the root.
return {
	cmd = function(dispatchers, config)
		local root = config.root_dir or vim.fn.getcwd()
		local data = vim.fn.stdpath("cache") .. "/jdtls/" .. root:gsub("/", "_")
		return vim.lsp.rpc.start({ "jdtls", "-data", data }, dispatchers)
	end,
	filetypes = { "java" },
	root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", ".git" },
}
