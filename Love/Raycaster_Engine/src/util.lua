-- print a formatted table
function print_table(table, formatting, tabs)
    local formatting = formatting or "classic"
    if(formatting == "tab") then
        local tabs = tabs or ""
        print(tabs .. "{")
        for key, value in pairs(table) do
            if(type(value) == "table") then
                print_table(value, "tab", tabs..'\t')
            else
                print(tabs..'\t', key, "=", value)
            end
        end
        print(tabs .. "}")
    else
        print(table_string(table))
    end
end

function table_string(table)
    local str = "{ "
    local index = 1
    for key, value in pairs(table) do
        if(index > 1) then str = str .. ", " end
        index = index + 1
        if(type(value) == "table") then
            str = str .. table_string(value)
        else
            str = str .. (key == "x" and "x = " or "") .. (key == "y" and "y = " or "") .. (type(value) == "boolean" and (value == true and "true" or "false") or value)
        end
    end
    str = str .. " }"
    return str
end

function UUID()
    local fn = function(x)
        local r = love.math.random(16) - 1
        r = (x == "x") and (r + 1) or (r % 4) + 9
        return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

-- Constants

Color = {}
Color.red = {1, 0, 0}
Color.green = {0, 1, 0}
Color.blue = {0, 0, 1}
Color.white = {1, 1, 1}
Color.black = {0, 0, 0}
Color.gray = {0.2, 0.2, 0.2}
