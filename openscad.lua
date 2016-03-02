local openscad = {}

local function getbin(scad)
    if scad and scad.bin then
        return scad.bin
    end
    return 'openscad'
end

openscad.model = function(path)
    return {path = path, vars = {}}
end

openscad.args = function(output, scad, opt)
    local args = {'-o', output, '-m', 'lark'}
    if scad.deps_file then
        table.insert(args, '-d')
        table.insert(args, scad.deps_file)
    end
    for _, var in pairs(scad.vars or {}) do
        table.insert(args, '-D')
        table.insert(args, var)
    end
    table.insert(args, scad.path)
    return args
end

local function cmd(bin, args, opt)
    local cmd = {bin, args}
    if opt then
        for k, v in pairs(opt) do
            if type(k) == 'string' then
                cmd[k] = v
            end
        end
    end
    return cmd
end

openscad.exec = function(output, scad, opt)
    local bin = getbin(scad)
    local args = openscad.args(output, scad)
    lark.exec(cmd(bin, args, opt))
end

openscad.start = function(output, scad, opt)
    local bin = getbin(scad)
    local args = openscad.args(output, scad)
    lark.start(cmd(bin, args, opt))
end

return openscad
