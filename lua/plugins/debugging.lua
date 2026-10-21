vim.pack.add({
    { src = "https://github.com/mfussenegger/nvim-dap.git" },
    { src = "https://github.com/rcarriga/nvim-dap-ui.git" },
    { src = "https://github.com/nvim-neotest/nvim-nio.git" },
    { src = "https://github.com/mxsdev/nvim-dap-vscode-js" },
})

local dap = require("dap")
local dapui = require("dapui")
local utils = require("dap.utils")

dapui.setup()
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

local debug_root = vim.fn.stdpath("data") .. "/site/debuggers"
local js_debug_path = debug_root .. "/vscode-js-debug"

-- 2. Pure Lua recursive file finder (handles layout changes cleanly)
local function locate_server_script(dir)
    local handle = vim.uv.fs_scandir(dir)
    if not handle then return nil end

    while true do
        local name, type = vim.uv.fs_scandir_next(handle)
        if not name then break end

        local full_path = dir .. "/" .. name
        if type == "directory" then
            local found = locate_server_script(full_path)
            if found then return found end
        elseif type == "file" and name == "dapDebugServer.js" then
            return full_path
        end
    end
    return nil
end

-- 3. Automatic Bootstrap Pipeline (Downloads & Extracts tar.gz payload)
local function bootstrap_js_debug()
    local existing_path = locate_server_script(js_debug_path)
    if existing_path then
        return existing_path
    end

    vim.notify("Bootstrapping clean standalone vscode-js-debug server...", vim.log.levels.INFO)

    vim.fn.delete(js_debug_path, "rf")
    vim.fn.mkdir(js_debug_path, "p")

    -- Query the GitHub API to dynamically parse the target download URL for the .tar.gz bundle
    local api_cmd = "curl -s https://api.github.com/repos/microsoft/vscode-js-debug/releases/latest " ..
    "| grep -o 'https://.*js-debug-dap-.*\\.tar\\.gz' | head -n 1"
    local download_url = vim.trim(vim.fn.system(api_cmd))

    if download_url == "" or not download_url:find("http") then
        -- Hard fallback if grep parsing fails or network is restricted
        download_url = "https://github.com"
    end

    local tar_path = debug_root .. "/js-debug-payload.tar.gz"

    -- Fetch asset and extract natively using tar
    vim.fn.system({ "curl", "-L", "-s", "-o", tar_path, download_url })
    vim.fn.system({ "tar", "-xzf", tar_path, "-C", js_debug_path })
    vim.fn.delete(tar_path)

    local discovered_path = locate_server_script(js_debug_path)
    if discovered_path then
        vim.notify("vscode-js-debug initialized automatically at: " .. discovered_path, vim.log.levels.INFO)
        return discovered_path
    end

    return nil
end

-- 4. Dynamic Execution Bind
local debug_server_js = bootstrap_js_debug()

dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "node",
        args = {
            debug_server_js or "",
            "${port}",
        },
    },
}

if not debug_server_js then
    vim.notify("Dynamic initialization failed. Run :messages to check errors.", vim.log.levels.WARN)
end

for _, language in ipairs({ "typescript", "javascript" }) do
    dap.configurations[language] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process ID",
            processId = utils.pick_process,
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
                local co = coroutine.running()
                return coroutine.create(function()
                    vim.ui.input({
                        prompt = "Enter URL: ",
                        default = "http://localhost:3000",
                    }, function(url)
                        if url == nil or url == "" then
                            return
                        else
                            coroutine.resume(co, url)
                        end
                    end)
                end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
        },
        {
            name = "----- ↓ launch.json configs ↓ -----",
            type = "",
            request = "launch",
        },
    }
end
