require "Config"
console.clear()
if Seed == 0 then

    RandomSeed = math.random(999999999)
    RandomSeed = string.format("%09d", RandomSeed)
    math.randomseed(RandomSeed)
    
else

    RandomSeed = Seed
    math.randomseed(Seed)

end

if WeaponShuffle == true then
    if Override == 0 then
        dofile("modules/Weapon_Shuffle.lua")
    elseif Override == 1 then
        dofile("modules/Weapon_Shuffle_Club.lua")
    elseif Override == 2 then
        dofile("modules/Weapon_Shuffle_HP.lua")
    end
end

if PEShuffle == true then
    
    dofile("modules/PE_Shuffle.lua")

end

dofile("modules/Main.lua")

print("Seed:"..string.format("%09d",RandomSeed))
