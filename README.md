#openscad-lark

An OpenSCAD module for the lark build system.

##Example

```lua
local openscad = require('openscad')

lark.task{'stl', function()
    local output = 'foo.stl'
    local model = openscad.model('foo.scad')
    table.insert(model.vars, 'Width=100')
    table.insert(model.vars, 'Height=100')
    openscad.exec(output, model)
end}
```

##Install

Copy openscad.lua into the project `lark_modules/` directory.

    wget -O lark_modules/openscad.lua https://raw.githubusercontent.com/bmatsuo/openscad-lark/master/openscad.lua
