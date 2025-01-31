# buffermod  

This plugin yields functions to open buffer from strings and modify buffer names when opened.

## Installation 
You can use any plugin manager to install this plugin.

### Lazyvim
```lua
{"RTO6000/buffermod",
config = function()
  require('buffermod').setup({
  -- Here goes your configuration.
  })
  end
}
```

## Configuration

These options are supported:
    - `open_all_files = true | false | nil` If set to `true` and if the renamed buffer is a directory, open all files in that directory instead of opening the directory.
    - `patterns` Yields a number of `pattern` structs for configuring this plugin. It is described in the [Pattern](#The-pattern) section.
### The pattern struct.
This struct has to yield a regex, which the buffername is being compared to.
The other necessary parameter is the pattern, i.e the function is being called, 
with the table it surrounds. This is useful if you want to store additional parameters in there.
```lua
 {regex = ".*",
  rename=function(str,pattern) return str.."1"  end,
 }
```

### Example
This is a example configuration:
```lua
{   mapping = { }, -- Empty I don't want to leak anything
    regex = "%w+%.%w-%w",
    rename = function(str,table) 
        local delimiter = "%."
        local pool = string.match(str, "^[^%.]+") -- Match everything before the first .
        local new_str=""
        str= string.gsub(str,"%.","/")
        new_str = string.gsub(str,'-',"/tc/")
        new_str = string.gsub(new_str,pool,table.mapping[pool])
        return new_str
    end
}
```
## Commands 
The following commands have been implemented:
    * `OPENCURSOR`

## NOTES
Most of the functions were generated using ChatGPT and only slightly modfied by me.
Still it took some time to build this little plugin, because I am not experienced in lua.
