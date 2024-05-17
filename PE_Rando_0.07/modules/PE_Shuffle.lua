local tobase = function(x, base)
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

local perseed = {}
local i = 0
local Skip = 0
local PE = 0
local startpe = false
local Heal1 = 1
local Heal2 = 2
local Heal3 = 4
local Detox = 8
local Medic = 16
local Barrier = 32
local EnergyShot = 64
local Scan = 128
local Slow = 256
local Haste = 512
local Confuse = 1024
local GeneHeal = 2048
local Preraise = 4096
local FullRecover = 262144
local Liberate = 524288
local PEAbilities ={
	1,		--Heal1
	2,		--Heal2
	4,		--Heal3
	8,		--Detox
	16,		--Medic 
	32,		--Barrier 
	64,		--EnergyShot 
	128,	--Scan
	256,	--Slow
	512,	--Haste
	1024,	--Confuse
	2048,	--GeneHeal
	4096,	--Preraise
	262144,	--FullRecover
	524288,	--Liberate
}

local LevelSkip ={3,2,2,2,2,2,2,3,2,3,2,2,3,2,2}

for line in io.lines("per-seed.lua") do
    if string.match(line,"SeedCH01") then
		PE = table.randpop(PEAbilities)
        perseed[#perseed+1] = string.gsub(line,"0x%g%g%g%g%g%g%g%g", "0x00"..string.rep("0",6-#tobase(PE,16))..tobase(PE,16))
    end
	if string.match(line,"SeedPE01") then
	startpe = true
	Skip = table.randpop(LevelSkip)+1
	end 

	if startpe == true then
	i = i + 1
	if i == Skip and i<35 then
		Skip = Skip + table.randpop(LevelSkip)
		PE = table.randpop(PEAbilities) + PE
	end
	perseed[#perseed+1] = string.gsub(line,"0x%g%g%g%g%g%g%g%g", "0x00"..string.rep("0",6-#tobase(PE,16))..tobase(PE,16))
	
		if i == 38 then
		startpe = false
		end
	elseif not string.match(line,"SeedCH01") then
	perseed[#perseed+1] = line
	end
end
	local fh = io.open("per-seed.lua","w")

	for i, v in ipairs(perseed) do
		fh:write(perseed[i], "\n")
	
	end
	
	fh:close()
	
	print("Parasite Abilites Shuffle Complete")