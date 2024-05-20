debug.setmetatable("", {
    __index = string
})

tobase = function(x, base)
    local result = {}
    
    if x == 0 then return "0" end

    while x > 0 do
        local digit = x % base

        result[#result + 1] = digit < 10 and digit or string.char(55 + digit)

        x = math.floor(x / base)
    end
    


    return string.reverse(table.concat(result))
end

table.randpop = function(self)
    if #self == 0 then return end

    return table.remove(self, math.random(#self))
end

string.split = function(self, separator, plain, keep)
    local result, index

    result = {}
    index  = 1
    plain  = plain == nil or plain
    keep   = not not tern(keep == nil, false, keep) and 0 or 1
    
    if separator == nil then
        for i, chr in self do result[i] = chr end

        return result
    end

    while true do
        local start, fin = self:find(separator, index, plain)
        
        if not start then
            if index <= #self then
                result[#result + 1] = self:sub(index)
            end

            break
        end
        
        result[#result + 1] = self:sub(index, start - keep)

        index = fin + 1
    end

    return result
end

string.trim = function(self)
    local result = self:gsub("^%s*", ""):gsub("%s*$", "")
    
    return result
end

function checktable(tbl)
    local match

    for i, v in ipairs(tbl) do
        if v:match("thing I'm looking for") then
            match = v
            break
        end
    end

    if not match then print("you didnt find anything") end

    return match
end

function shallow(oldtbl)
    local newtbl = {}

    for key, v in pairs(oldtbl) do
        newtbl[key] = v
    end

    return newtbl
end

function ishallow(oldtbl)
    local newtbl = {}

    for i, v in ipairs(oldtbl) do
        newtbl[i] = v
    end

    return newtbl
end

local RoF = {0,
33,
34,
35,
36,
37
}

local WeaponMods ={
09,
10,
11,
12,
13,
14,
15,
18
}

local ArmorMods = {
    01,
    02,
    03,
 --   04,
    05,
    06,
    07,
    11,
    12,
    13,
    14,
    15
}

local perseed = {}
local obj = {}
local items = {}
local start = false
local startwep = false
local startarm = false
local Block = 0
local BlockCount = 0
local temp = {}
local mods = {}
local byte

local TypeToIcon = {
    1,
    2,
    4,
    3,
    6,
    5,
    1,
    7
}

local Targeting = {
    102,
    103,
    104,
}
local Steal = {
    144,
    145,
}
local CmdX = {
    179,
    180,
}
local ItemUp = {
    40,
    41,
    42
}

for line in io.lines("modules/Master_Seed.lua") do
    
    if BlockCount > 0 then
        if Block >= BlockCount then
        Block = 0
        BlockCount = 0
        end
        Block = Block+1
        --[[if string.len(tobase(temp[Block],16)) == 1 then
            byte = tobase(temp[Block],16)
        else 
            byte = "0"tobase(temp[Block],16)
        end]]
        perseed[#perseed+1] = string.gsub(line,"0x","0x"..tobase(temp[Block],16))

    else
        perseed[#perseed+1] = line
        end

    if string.match(line,"Club1") then 
        start = true 
        startwep = true
    end

    if string.match(line,"M92F") then 
        startwep = false 
        startarm = true 
    end

    if start and line=="" then
        if startwep then
            local mods = {
                Targeting[math.random(3)],
                Steal[math.random(2)],
                CmdX[math.random(2)],
                09,
                10,
                11,
                12,
                13,
                14,
                15,
                18
            } 
            temp[2] = math.random(WeaponModMin,WeaponModMax)
            temp[3] = math.random(8)
            temp[4] = math.random(OffMin,OffMax)
            temp[5] = math.random(RngMin,RngMax)
            temp[6] = math.random(BltMin,BltMax)
            temp[8] = math.random(OffPlusMin,OffPlusMax)
            temp[9] = math.random(RngPlusMin,RngPlusMax)
            temp[10] = math.random(BltPlusMin,BltPlusMax)
            temp[7] = temp[6] + temp[10]
            temp[11] = math.random(1,temp[2])
            temp[12] = RoF[math.random(#RoF)]
            for i = 1, 9, 1 do
                if temp[11] > i and math.random() > 0.5 then
                temp[12+i] = table.randpop(mods)
                else
                temp[12+i] = 0
                end
            end
            temp[1] = TypeToIcon[temp[3]]
            BlockCount = 21
            Block = 0
        elseif startarm then
            local mods = {
            ItemUp[math.random(3)],
            01,
            02,
            03,
            05,
            06,
            07,
            11,
            12,
            13,
            14,
            15
            }
            temp[1] = math.random(ArmorModMin,ArmorModMax)
            temp[2] = math.random(DefMin,DefMax)
            temp[3] = math.random(PEnMin,PEnMax)
            temp[4] = math.random(CrtMin,CrtMax)
            temp[5] = math.random(DefPlusMin,DefPlusMax)
            temp[6] = math.random(PEnPlusMin,PEnPlusMax)
            temp[7] = math.random(CrtPlusMin,CrtPlusMax)
            temp[8] = math.random(1,temp[1])
            for i = 1, 10, 1 do
                if temp[8] > i and math.random() > 0.5 then
                temp[8+i] = table.randpop(mods)
                else
                temp[8+i] = 0
                end
            end
            BlockCount = 18
            Block = 0 
            end
        end
    end
    

local fh = io.open("per-seed.lua","w")

for i, v in ipairs(perseed) do
    fh:write(perseed[i], "\n")

end

fh:close()


print("Weapon Shuffle Complete")
