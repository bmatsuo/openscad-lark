local doc = require('doc')
local openscad =
    doc.desc[[
    Utilities for compiling OpenSCAD models.  Models are defined using the
    openscad.model() function and compiled using openscad.exec() or
    openscad.start().  To manually construct and execute OpenSCAD commands the
    helper function openscad.args() can be used.
    ]] ..
    {}

local function getbin(scad)
    if scad and scad.bin then
        return scad.bin
    end
    return 'openscad'
end

openscad.model =
    doc.desc[[Define a new OpenSCAD model]] ..
    doc.sig[[path => model]] ..
    doc.param[[path  An OpenSCAD file path (with a .scad extension)]] ..
    function(path)
        return {path = path, vars = {}}
    end

openscad.args =
    doc.desc[[Return command line arguments for an invokation of OpenSCAD]] ..
    doc.sig[[(output, model, opt) => args]] ..
    doc.param[[output    The output filename]] ..
    doc.param[[model     The input model returned from openscad.model()]] ..
    doc.param[[opt       Execution options]] ..
    doc.param[[opt.vars  OpenSCAD variable assignments]] ..
    function(output, scad, opt)
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

openscad.exec =
    doc.desc[[Analogous to lark.exec() for OpenSCAD commands]] ..
    doc.sig[[(output, model, opt) => (output, error)]] ..
    doc.param[[output    The output filename]] ..
    doc.param[[model     The input model returned from openscad.model()]] ..
    doc.param[[opt       Execution options understood by lark.exec()]] ..
    doc.param[[opt.vars  OpenSCAD variable assignments]] ..
    function(output, scad, opt)
        local bin = getbin(scad)
        local args = openscad.args(output, scad)
        return lark.exec(cmd(bin, args, opt))
    end

openscad.start =
    doc.desc[[Analogous to lark.start() for OpenSCAD commands]] ..
    doc.sig[[(output, model, opt) => ()]] ..
    doc.param[[output    The output filename]] ..
    doc.param[[model     The input model returned from openscad.model()]] ..
    doc.param[[opt       Execution options understood by lark.start()]] ..
    doc.param[[opt.vars  OpenSCAD variable assignments]] ..
    function(output, scad, opt)
        local bin = getbin(scad)
        local args = openscad.args(output, scad)
        lark.start(cmd(bin, args, opt))
    end

return openscad
