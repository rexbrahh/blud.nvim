local M = {}

local function find_upward(dir, names)
  return vim.fs.find(names, { upward = true, type = "file", path = dir })[1]
end

local function add_task(tasks, name, cmd, cwd, tags)
  tasks[#tasks + 1] = {
    name = name,
    tags = tags,
    builder = function()
      return {
        cmd = cmd,
        cwd = cwd,
      }
    end,
  }
end

local function read_json(path)
  if not path then
    return nil
  end
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end
  local decoded_ok, data = pcall(vim.json.decode, table.concat(lines, "\n"))
  return decoded_ok and data or nil
end

local function cmake_tasks(tasks, dir, tag)
  local cmakelists = find_upward(dir, "CMakeLists.txt")
  if not cmakelists or vim.fn.executable("cmake") ~= 1 then
    return
  end

  local root = vim.fs.dirname(cmakelists)
  local presets = read_json(root .. "/CMakePresets.json")
    or read_json(root .. "/CMakeUserPresets.json")
  if presets then
    for _, preset in ipairs(presets.configurePresets or {}) do
      if not preset.hidden then
        add_task(
          tasks,
          "cmake configure " .. preset.name,
          { "cmake", "--preset", preset.name },
          root,
          { tag.BUILD }
        )
      end
    end
    for _, preset in ipairs(presets.buildPresets or {}) do
      if not preset.hidden then
        add_task(
          tasks,
          "cmake build " .. preset.name,
          { "cmake", "--build", "--preset", preset.name },
          root,
          { tag.BUILD }
        )
      end
    end
    for _, preset in ipairs(presets.testPresets or {}) do
      if not preset.hidden then
        add_task(
          tasks,
          "ctest " .. preset.name,
          { "ctest", "--preset", preset.name },
          root,
          { tag.TEST }
        )
      end
    end
  else
    add_task(
      tasks,
      "cmake configure",
      { "cmake", "-S", root, "-B", root .. "/build" },
      root,
      { tag.BUILD }
    )
    add_task(tasks, "cmake build", { "cmake", "--build", root .. "/build" }, root, { tag.BUILD })
    add_task(
      tasks,
      "ctest",
      { "ctest", "--test-dir", root .. "/build", "--output-on-failure" },
      root,
      { tag.TEST }
    )
  end

  if vim.fn.executable("ninja") == 1 then
    local ninja_files = {}
    if vim.fn.filereadable(root .. "/build.ninja") == 1 then
      ninja_files[#ninja_files + 1] = root .. "/build.ninja"
    end
    for _, search_dir in ipairs({ root .. "/build", root .. "/out" }) do
      if vim.fn.isdirectory(search_dir) == 1 then
        vim.list_extend(
          ninja_files,
          vim.fs.find("build.ninja", { path = search_dir, type = "file", limit = 20 })
        )
      end
    end
    for _, ninja_file in ipairs(ninja_files) do
      local build_dir = vim.fs.dirname(ninja_file)
      local relative = vim.fs.relpath(root, build_dir) or build_dir
      add_task(tasks, "ninja " .. relative, { "ninja", "-C", build_dir }, root, { tag.BUILD })
      add_task(
        tasks,
        "ninja test " .. relative,
        { "ninja", "-C", build_dir, "test" },
        root,
        { tag.TEST }
      )
    end
  end
end

local function bazel_tasks(tasks, dir, tag)
  local marker = find_upward(dir, { "MODULE.bazel", "WORKSPACE.bazel", "WORKSPACE" })
  if not marker then
    return
  end
  local executable = vim.fn.executable("bazelisk") == 1 and "bazelisk" or "bazel"
  if vim.fn.executable(executable) ~= 1 then
    return
  end
  local root = vim.fs.dirname(marker)
  add_task(
    tasks,
    executable .. " build //...",
    { executable, "build", "//..." },
    root,
    { tag.BUILD }
  )
  add_task(tasks, executable .. " test //...", { executable, "test", "//..." }, root, { tag.TEST })
end

local function zig_tasks(tasks, dir, tag)
  local build_file = find_upward(dir, "build.zig")
  if not build_file or vim.fn.executable("zig") ~= 1 then
    return
  end
  local root = vim.fs.dirname(build_file)
  add_task(tasks, "zig build", { "zig", "build" }, root, { tag.BUILD })
  add_task(tasks, "zig build test", { "zig", "build", "test" }, root, { tag.TEST })
end

local function go_tasks(tasks, dir, tag)
  local module = find_upward(dir, "go.mod")
  if not module or vim.fn.executable("go") ~= 1 then
    return
  end
  local root = vim.fs.dirname(module)
  add_task(tasks, "go build ./...", { "go", "build", "./..." }, root, { tag.BUILD })
  add_task(tasks, "go test ./...", { "go", "test", "./..." }, root, { tag.TEST })
end

function M.register()
  local overseer = require("overseer")
  local tag = require("overseer.constants").TAG

  overseer.register_template({
    name = "systems",
    cache_key = function(opts)
      return table.concat({
        find_upward(opts.dir, "CMakeLists.txt") or "",
        find_upward(opts.dir, { "MODULE.bazel", "WORKSPACE.bazel", "WORKSPACE" }) or "",
        find_upward(opts.dir, "build.zig") or "",
        find_upward(opts.dir, "go.mod") or "",
      }, ":")
    end,
    generator = function(opts, cb)
      local tasks = {}
      cmake_tasks(tasks, opts.dir, tag)
      bazel_tasks(tasks, opts.dir, tag)
      zig_tasks(tasks, opts.dir, tag)
      go_tasks(tasks, opts.dir, tag)
      cb(tasks)
    end,
  })
end

return M
