RS = {}
RS.serializer = [[
local a=table.concat;local function b(table,c,d)d[c]="{"c=c+1;local e=false;for f,g in pairs(table)do e=true;local h=type(f)if h=="string"then d[c]=f.."="elseif h=="number"then d[c]="["..f.."]="elseif h=="boolean"then d[c]="["..tostring(f).."]="else d[c]="notsupported="end;c=c+1;local i=type(g)if i=="table"then c=b(g,c,d)elseif i=="string"then d[c]='"'..g..'"'elseif i=="number"then d[c]=g elseif i=="boolean"then d[c]=tostring(g)else d[c]='"Not Supported"'end;d[c+1]=","c=c+2 end;if e then c=c-1 end;d[c]="}"return c end;function serialize(g)local d={}local i=type(g)if i=="table"then b(g,1,d)elseif i=="string"then return'"'..g..'"'elseif i=="number"then return g elseif i=="boolean"then return tostring(g)else return'"Not Supported"'end;return a(d)end;function deserialize(j)if j==nil then return nil else return load("return "..j)()or nil end end
]]

------------------------------------------------------------------------
---------------------------START Serializer-----------------------------
------------------------------------------------------------------------
local concat = table.concat
local function internalSerialize(table, tC, t)
    t[tC] = "{"
    tC = tC + 1
    local hasValue = false
    for key, value in pairs(table) do
        hasValue = true
        local keyType = type(key)
        if keyType == "string" then
            t[tC] = key .. "="
        elseif keyType == "number" then
            t[tC] = "[" .. key .. "]="
        elseif keyType == "boolean" then
            t[tC] = "[" .. tostring(key) .. "]="
        else
            t[tC] = "notsupported="
        end
        tC = tC + 1

        local check = type(value)
        if check == "table" then
            tC = internalSerialize(value, tC, t)
        elseif check == "string" then
            t[tC] = '"' .. value .. '"'
        elseif check == "number" then
            t[tC] = value
        elseif check == "boolean" then
            t[tC] = tostring(value)
        else
            t[tC] = '"Not Supported"'
        end
        t[tC + 1] = ","
        tC = tC + 2
    end
    if hasValue then
        tC = tC - 1
    end
    t[tC] = "}"
    return tC
end

function serialize(value)
    local t = {}
    local check = type(value)

    if check == "table" then
        internalSerialize(value, 1, t)
    elseif check == "string" then
        return '"' .. value .. '"'
    elseif check == "number" then
        return value
    elseif check == "boolean" then
        return tostring(value)
    else
        return '"Not Supported"'
    end

    return concat(t)
end

function deserialize(s)
    if s == nil then return nil
    else
    return load("return " .. s)() or nil
    end
end 



function shiftElement(arr, index, direction)
    local len = #arr
    if index < 1 or index > len then
        system.print("Invalid index")
        return
    end

    if direction == "up" then
        if index > 1 then
            arr[index], arr[index - 1] = arr[index - 1], arr[index]
        else
            system.print("Cannot shift up further")
        end
    elseif direction == "down" then
        if index < len then
            arr[index], arr[index + 1] = arr[index + 1], arr[index]
        else
            system.print("Cannot shift down further")
        end
    else
        print("Invalid direction (use 'up' or 'down')")
    end
end

function tablelength(t)
    local c = 0
    for _ in pairs(t) do
        c = c + 1
    end
    return c
end

function deep_copy(t)
    if type(t) ~= "table" then
        return t
    end
    local t2 = {}
    for k, v in pairs(t) do
        t2[k] = deep_copy(v)
    end
    return t2
end


function replace_first_number_with_N(str)
    if tonumber(str) then
        return str
    else
        local first_char = str:sub(1, 1)
        if tonumber(first_char) then
            return "n" .. str:sub(2)
        else
            return str
        end
    end
end
function clean_string(str)
    local cleaned = str:gsub(' ', 'SPACES')
    cleaned = cleaned:gsub('[^%w ]', '')
    return cleaned:gsub('SPACES', '_')
end

function reformatString(str)
    if string.sub(str,1,6) == "assets" then
        return str
    end
    local s = clean_string(str)
    s = replace_first_number_with_N(s)
    return s
end
--assets.prod.novaquark.com/3630/3c0960de-527c-49d6-946f-5112cdcb62a0.jpg

function stringToTable(str, S)
    local S = S or ','
    local axes = {}
    for axis in str:gmatch('[^'..S..']+') do
        axes[#axes + 1] = type(axis)=="string" and axis or deserialize(axis)
    end
    return axes
end

function formatRGBAH(str)
    local t = stringToTable(str)
    if #t == 5 and tonumber(t[1]) and tonumber(t[2]) and tonumber(t[3]) and tonumber(t[4]) and tonumber(t[5]) then
        return t
    else
        system.print("Wrong typing format: num1,num2,num3,num4,num5")
        return nil
    end
end

function formatRGB(str)
    local t = stringToTable(str)
    if #t == 3 and tonumber(t[1]) and tonumber(t[2]) and tonumber(t[3]) then
        return t
    else
        system.print("Wrong typing format: num1,num2,num3")
        return nil
    end
end

function formatPoint(str)
    local t = stringToTable(str)
    if #t == 2 and tonumber(t[1]) and tonumber(t[2])then
        return t
    else
        system.print("Wrong typing format: num1,num2")
        return nil
    end
end

function checkString2TableN(str, n)
    local t = stringToTable(str)
    if #t == n then
        return t
    else
        local add = "var"
        local nn = n-1
        for i = 1, nn do
            add = add..",var"
        end
            
        system.print("Wrong typing format: "..add)
        return nil
    end
end

function concatenateTableValues(tbl)
    local result = ""
    local function concatBranch(branch)
        for _, v in ipairs(branch) do
            if type(v) == "table" then
                concatBranch(v)  -- Recurse into nested tables
            else
                result = result .. tostring(v) .. " "
            end
        end
    end
    concatBranch(tbl)
    return result
end

function find_close_points(cursor, point_cloud, dist)
    if point_cloud and cursor then
        local closest_index = nil
        local closest_indexes = {}

        for i, point in ipairs(point_cloud) do
            local dx = cursor.cx - point.x
            local dy = cursor.cy - point.y
            local distance = math.sqrt(dx^2 + dy^2)

            if distance < dist then
                closest_index = i
                table.insert(closest_indexes,i)
            end
        end

        if closest_index then
            return closest_index, closest_indexes
        else
            return nil
        end
    else
        return nil
    end
end