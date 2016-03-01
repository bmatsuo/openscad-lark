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
    args = {'-o', output, '-m', 'lark'}
    if scad.deps_file then
        table.insert(args, '-d')
        table.insert(args, scad.deps_file)
    end
    if scad.vars and #scad.vars > 0 then
        table.insert(args, '-D')
        for _, var in pairs(scad.vars or {}) do
            table.insert(args, var)
        end
    end
    table.insert(args, scad.path)
    return args
end

openscad.exec = function(output, scad, opt)
    bin = getbin(scad)
    args = openscad.args(output, scad)
    lark.exec(bin, args, opt)
end

openscad.start = function(output, scad, opt)
    bin = getbin(scad)
    args = openscad.args(output, scad)
    lark.start(bin, args, opt)
end

return openscad
