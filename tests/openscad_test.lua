local openscad = require('openscad')

local function find_flag(args, flag)
    for i, v in pairs(args) do
        if type(i) == 'number' and v == flag then
            return i
        end
    end
    return nil
end

local model = openscad.model('foo.scad')
model.deps_file = 'foo.deps'
table.insert(model.vars, 'N=3')
local args = openscad.args('foo.stl', model)
print(table.concat(args, ' '))
assert(args[#args] == 'foo.scad')

local i = -1

i = find_flag(args, '-D')
assert(i)
assert(args[i+1] == 'N=3')

i = find_flag(args, '-d')
assert(i)
assert(args[i+1] == 'foo.deps')
