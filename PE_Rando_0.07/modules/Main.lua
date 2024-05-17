---@diagnostic disable: need-check-nil, duplicate-set-field
-- +==== INSTRUCTIONS ====+ --
--
--    1. Place this script into the same folder as a previous per-seed file
--    2. Run this script either in the Bizhawk lua console or via lua binaries
--    3. The previous Per-Seed file will be overwriten with a rerolled item pool, and an Item_spoiler text file will be created in the same folder
--


 
-- +==== LOGIC BELOW ====+ --

local flags, seed, inverse_seed, checks, locations
local location_pool, item_names, location_names
local key_items, key_items_pool, normal_items
local normal_items_pool, healing_pool, tool_pool
local temp_pool, handle, rules, key_item_logic
local location_delimeters, osort, padding

   -- == FUNCTIONS == --

osort = table.sort

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

table.shallow = function(self, tbl)
    if #tbl == 0 then
        for k, v in pairs(tbl) do
            self[k] = v 
        end
    else
        for _, v in ipairs(tbl) do
            self[#self + 1] = v 
        end
    end

    return self
end

table.hashmap = function(self)
    local t = {}

    for _, v in ipairs(self) do
        t[v] = true
    end

    return t
end

table.unhashmap = function(self)
    local t = {}

    for k, _ in pairs(self) do
        t[#t + 1] = k
    end

    return t
end

table.keys = function(self)
    local t = {}

    for k, _ in pairs(self) do
        t[#t + 1] = k 
    end

    return t
end

table.values = function(self)
    local t = {}

    for _, v in pairs(self) do
        t[#t + 1] = v 
    end

    return t
end

table.duplicate = function(self, value, amount)
    for i = 1, amount, 1 do
        self[#self + 1] = value 
    end

    return self
end

table.shuffle = function(self)
    local t = table.shallow({}, self)

    self = {}

    for i = 1, #t, 1 do
        self[i] = table.randpop(t)
    end

    return self
end

table.merge = function(self, ...)
    for _, tbl in ipairs({ ... }) do
        for k, v in pairs(tbl) do
            self[k] = v
        end
    end

    return self
end

table.invert = function(self)
    local t = table.shallow({}, self)

    self = {}
    
    if #t == 0 then
        for k, v in pairs(t) do
            self[v] = k
        end
    else
        for i, v in ipairs(t) do
            self[v] = i
        end
    end

    return self
end

table.random = function(self)
    return self[math.random(#self)]
end

table.randoms = function(self, amount)
    local t = {}

    for i = 1, amount or 1, 1 do
        t[#t + 1] = table.random(self)
    end

    return t
end

table.contains = function(self, value)
    for i, v in ipairs(self) do
        if v == value then return true end
    end

    return false
end

table.sort = function(self, func)
    osort(self, func)

    return self
end

table.reduce = function(self, func, init)
    for i, v in ipairs(self) do
        if init == nil then
            init = v
        else
            init = func(i, v, init)
        end
    end

    return init
end

function rulecheck(rule)
    for _, v in ipairs(rule) do
        local inv, pass

        inv  = string.sub(v, 1, 1) == "!"
        pass = flags[inv and string.sub(v, 2) or v]
        
        if inv then pass = not pass end

        if not pass then return false end
    end

    return true
end

   -- == DECLARATIONS == --

seed = {
    SeedPD10 = 0x01,
    SeedPD23 = 0x01
}
rules = {
    blue_card = {
        fuse = { "f1", "f2", "f3", "bckey" },
        gckey = { "f1", "f2", "f3", "bckey", "gckey" },
        ekey = { "f1", "f2", "f3", "bckey", "gckey", "ekey" }
    },
    f1 = {
        fuse = { "f1", "f2", "f3", "bckey" },
        gckey = { "f1", "f2", "f3", "bckey", "gckey" },
        ekey = { "f1", "f2", "f3", "bckey", "gckey", "ekey" }
    },
    f2 = {
        fuse = { "f1", "f2", "f3", "bckey" },
        gckey = { "f1", "f2", "f3", "bckey", "gckey" },
        ekey = { "f1", "f2", "f3", "bckey", "gckey", "ekey" }
    },
    f3 = {
        fuse = { "f1", "f2", "f3", "bckey" },
        gckey = { "f1", "f2", "f3", "bckey", "gckey" },
        ekey = { "f1", "f2", "f3", "bckey", "gckey", "ekey" }
    },
    green_card = {
        gckey = { "f1", "f2", "f3", "bckey", "gckey" },
        ekey = { "f1", "f2", "f3", "bckey", "gckey", "ekey" }
    },
    elevator_key = {
        ekey = { "f1", "f2", "f3", "bckey", "gckey", "ekey" }
    },
    gate_key = {
        gor_pkey = { "!gkey", "!pkey" }
    },
    pump_key = {
        gor_pkey = { "!gkey", "!pkey" }
    },
    zoo_key = {
        wmem = { "zkey", "wmem" }
    },
    weapon_memo = {
        wmem = { "zkey", "wmem" }
    }
}

flags = {
    f1    = false,
    f2    = false,
    f3    = false,
    wmem  = false,
    zkey  = false,
    ekey  = false,
    gkey  = false,
    pkey  = false,
    bckey = false,
    gckey = false,
}

checks = {
    tkey = { 
        "SeedCH05", "SeedCH06", "SeedCH07", "SeedCH10", "SeedCH11",
        "SeedCH12", "SeedCH13"
    },
    rkey = {
        "SeedCH14", "SeedCH15", "SeedCH16", "SeedCH17", "SeedCH18", 
        "SeedCH19", "SeedCH20", "SeedCH21", "SeedCH22"
    },
    zkey = {
        "SeedCP09", "SeedCP10", "SeedCP11", "SeedCP12", "SeedCP16",
        "SeedCP17", "SeedCP18", "SeedCP19", "SeedCP20", "SeedCP21",
        "SeedCP22", "SeedCP23", "SeedCP24", "SeedSH01", "SeedSH02",
        "SeedSH11", "SeedSH12", "SeedSH13", "SeedSH14", "SeedSH15",
        "SeedSH16", "SeedSH17", "SeedSH18"
    },
    akey = {
        "SeedHS10", "SeedHS11", "SeedHS12", "SeedHS13", "SeedHS14"
    },
    skey = {
        "SeedPD30", "SeedPD31", "SeedPD32"
    },
    lkey = {
        "SeedPD13"
    },
    ekey = {
        "SeedHS34"
    },
    wkey = {
        "SeedWH09", "SeedWH10", "SeedWH11", "SeedWH12", "SeedWH13"
    },
    kkey = {
        "SeedMU30", "SeedMU31", "SeedMU32", "SeedMU33", "SeedMU34",
        "SeedMU35", "SeedMU36", "SeedMU37"
    },
    fuse = {
        "SeedHS20", "SeedHS21", "SeedHS22"
    },
    wmem = {
        "SeedSH03", "SeedSH04", "SeedSH05", "SeedSH06", "SeedSH07",
        "SeedSH08", "SeedSH09", "SeedSH10"
    },
    bckey = {
        "SeedHS15", "SeedHS16", "SeedHS17", "SeedHS18", "SeedHS19"
    },
    sjunk = {
        "SeedPD06", "SeedPD07", "SeedPD08", "SeedPD09",
        "SeedPD11", "SeedPD12", "SeedPD14", "SeedPD15", "SeedPD16",
        "SeedPD17", "SeedPD18", "SeedPD19", "SeedPD20", "SeedPD21",
        "SeedPD22", "SeedPD24", "SeedPD25", "SeedPD26", "SeedPD27",
        "SeedPD28", "SeedPD29", "SeedPD33" --"SeedPD23"
    },
    gckey = {
        "SeedHS23", "SeedHS24", "SeedHS25", "SeedHS26", "SeedHS27",
        "SeedHS28", "SeedHS29", "SeedHS30", "SeedHS31", "SeedHS32",
        "SeedHS33"
    },
    gor_pkey = {
        "SeedSW01", "SeedSW02", "SeedSW03", "SeedSW04", "SeedSW05",
        "SeedSW06", "SeedSW07", "SeedSW08", "SeedSW09"
    }
}

locations = {
    SeedCH02 = "F1: Backstage Chest",
    SeedCH03 = "B1: Save Chest",
    SeedCH04 = "B1: Theater Corpse",
    SeedCH05 = "B1: Diary",
    SeedCH06 = "B1: Diary Closet",
    SeedCH07 = "B1: Parrot Closet",
    SeedCH08 = "B1: Clown Locker",
    SeedCH09 = "B1: Burned Pair Locker",
    SeedCH10 = "B1: Prop Room: Chest",
    SeedCH11 = "B1: Prop Room: Hidden Chest",
    SeedCH12 = "B1: Prop Room: Rat Cabinet",
    SeedCH13 = "B1: Backstage",
    SeedCH14 = "Sewers: Stairway Chest",
    SeedCH15 = "Sewers: Ghost Girl: Left Back Chest",
    SeedCH16 = "Sewers: Ghost Girl: Right Chest",
    SeedCH17 = "Sewers: Ghost Girl: Left Front Chest",
    SeedCH18 = "Sewers: Hidden Chest Room: Left Chest",
    SeedCH19 = "Sewers: Hidden Chest Room: Center Chest",
    SeedCH20 = "Sewers: Hidden Chest Room: Right Chest",
    SeedCH21 = "Sewers: Hidden Chest Room: Hidden Chest",
    SeedCH22 = "Sewers: Gator",
    SeedPD01 = "Baker's Office: Baker Permit 1",
    SeedPD02 = "D2 Locker Room: Right Locker",
    SeedPD03 = "D2 Locker Room: Left Locker",
    SeedPD04 = "D2 Meeting Room: Baker Permit 2",
    SeedPD05 = "D2 Wayne & Torres: Free Gun ",
    SeedPD06 = "D3 Entrance: Hamaya",
    SeedPD07 = "D3 Main Hall: Cop's Ammo",
    SeedPD08 = "D3 Main Hall: Nix's Ammo",
    SeedPD09 = "D3 Save Room: Warner's Ammo",
    --SeedPD10 = "D3 Locker Room: Left Locker",
    SeedPD11 = "D3 Locker Room: Right Locker",
    SeedPD12 = "D3 locker Room: Cop's Ammo",
    SeedPD13 = "D2/3 Locker Room: Locked locker",
    SeedPD14 = "D3 Wayne & Torres: Torres' Gun",
    SeedPD15 = "D3 Kennel: Cathy's Ammo",
    SeedPD16 = "D3 Meeting Room: CM Vest2 Chest",
    SeedPD17 = "D3 Barred Staircase: Cops' Ammo",
    SeedPD18 = "Holding Cells: Left Chest",
    SeedPD19 = "Holding Cells: Right Chest",
    SeedPD20 = "Interigation: Chest",
    SeedPD21 = "Interigation: Table Sparkle",
    SeedPD22 = "Save Office: Desk Chest",
    SeedPD23 = "Save Office: Floor Chest",
    SeedPD24 = "Locker Key Cop",
    SeedPD25 = "Medical Office: Daniel Ammo",
    SeedPD26 = "Big Bad Wolf: Chest",
    SeedPD27 = "Big Bad Wolf: Drop",
    SeedPD28 = "Big Bad Wolf: Cop",
    SeedPD29 = "Big Bad Wolf, Backroom: Chest",
    SeedPD30 = "Storage: Left Chest",
    SeedPD31 = "Storage: Center Chest",
    SeedPD32 = "Storage: Right Chest",
    SeedPD33 = "Kerberos: Drop",
    SeedCP01 = "Entrance Trunk",
    SeedCP02 = "Entrance Chest",
    SeedCP03 = "Gate: Left Chest",
    SeedCP04 = "Gate: Right Chest",
    SeedCP05 = "Courtyard Chest",
    SeedCP06 = "Courtyard Tool",
    SeedCP07 = "Office: Drawer",
    SeedCP08 = "Office: Cabinet",
    SeedCP09 = "Office: Locked Cabinet",
    SeedCP10 = "Snake Exhibit: Right Front Chest",
    SeedCP11 = "Snake Exhibit: Left Chest",
    SeedCP12 = "Snake Exhibit: Right Back Chest",
    SeedCP13 = "Back Courtyard: Ammo Chest",
    SeedCP14 = "Figure 8: Right Chest",
    SeedCP15 = "Figure 8: Left Chest",
    SeedCP16 = "Gazebo: Left Chest",
    SeedCP17 = "Gazebo: Right Chest",
    SeedCP18 = "Behind Gazebo Save: Chest",
    SeedCP19 = "Forest Maze SW: Chest",
    SeedCP20 = "Forest Maze Bridge: Chest",
    SeedCP21 = "Forest Mase Dock: Chest",
    SeedCP22 = "Forest Maze E: Backup Tool Chest",
    SeedCP23 = "Arch: Stat Chest",
    SeedCP24 = "Arch: Yolo Tool",
    SeedSH01 = "Apartment: Ammo Chest",
    SeedSH02 = "Outside Apartment: Trash Card",
    SeedSH03 = "Gun Shop: North West Chest",
    SeedSH04 = "Gun Shop: North East Chest",
    SeedSH05 = "Gun Shop: Behind Counter Chest",
    SeedSH06 = "Gun Shop: South East Chest",
    SeedSH07 = "Gun Shop: Green Box",
    SeedSH08 = "Gun Shop: Red Box",
    SeedSH09 = "Gun Shop: Shotgun Rack",
    SeedSH10 = "Gun Shop: Rifle Rack",
    SeedSH11 = "Pharmacy: Back Chest",
    SeedSH12 = "Pharmacy: Far Right Chest",
    SeedSH13 = "Pharmacy Backroom: Left Chest",
    SeedSH14 = "Pharmacy Backroom: Right Chest",
    SeedSH15 = "Pharmacy: Left Shelf",
    SeedSH16 = "Pharmacy Back Shelf",
    SeedSH17 = "Pharmacy: Behind Counter",
    SeedSH18 = "Pharmacy: Right Shelf",
    SeedHS01 = "Outside: Maeda Mayoke",
    SeedHS02 = "Lobby: Corner Ammo Chest",
    SeedHS03 = "Lobby: Closet Chest",
    SeedHS04 = "Basement, Storage: North Chest",
    SeedHS05 = "Basement, Storage: South Chest",
    SeedHS06 = "Basement, Storage: Shelf Sparkle",
    SeedHS07 = "Basement, Save Office: Chest",
    SeedHS08 = "Basement, Save Office: Drawer",
    SeedHS09 = "Basement, Morgue: Chest",
    SeedHS10 = "Basement, Autopsy: Chest 1",
    SeedHS11 = "Basement, Autopsy: Chest 2",
    SeedHS12 = "Basement, Crematory: Chest",
    SeedHS13 = "Basement, Crematory: Sparkle",
    SeedHS14 = "Basement, Crematory: Corpse",
    SeedHS15 = "Basement, Back Hall: 50/50 Chest",
    SeedHS16 = "Basement, Collapsed Stairs: Sparkle",
    SeedHS17 = "Basement, Clean Room: Right Chest",
    SeedHS18 = "Basement, Clean Room: Left Chest",
    SeedHS19 = "Basement, Clean Room: Sparkle",
    SeedHS20 = "Emergency Room: Chest",
    SeedHS21 = "Flashback Room: Chest",
    SeedHS22 = "Flashback Room: Nurse",
    SeedHS23 = "F1 Back Hall: Chest",
    SeedHS24 = "Nitrogen Storage: Chest",
    SeedHS25 = "Nitrogen Storage: King Bacterium",
    SeedHS26 = "F13, Research lab: Chest",
    SeedHS27 = "F13, Research Lab: Counter",
    SeedHS28 = "F13, Research Lab: Shelf",
    SeedHS29 = "F13, Kennel: Chest",
    SeedHS30 = "F13, Sperm Bank: South Chest",
    SeedHS31 = "F13, Sperm Bank: North Chest",
    SeedHS32 = "F13, Sperm Bank: Sparkle 1",
    SeedHS33 = "F13, Sperm Bank: Sparkle 2",
    SeedHS34 = "Roof: Spider Woman",
    SeedWH01 = "Outside: Left Chest (Hidden)",
    SeedWH02 = "Outside: Right Chest",
    SeedWH03 = "Entrance: Forklift Chest",
    SeedWH04 = "Tom & Jerry: Chest",
    SeedWH05 = "Tom & Jerry: Sparkle",
    SeedWH06 = "Save Room: Upper North Chest",
    SeedWH07 = "Save Room: Lower North Chest",
    SeedWH08 = "Save Room: South Chest",
    SeedWH09 = "Before Descent: NW Chest",
    SeedWH10 = "Before Descent: NE Chest",
    SeedWH11 = "Before Descent: SW Chest",
    SeedWH12 = "Giant Enemy Crab",
    SeedWH13 = "Steam Sparkle",
    SeedCT01 = "Entrance: Left Chest",
    SeedCT02 = "Entrance; Right Chest",
    SeedCT03 = "Save Street: South Chest",
    SeedCT04 = "Save Street: North Chest",
    SeedCT05 = "Antique Shop: Chest",
    SeedCT06 = "Antique Shop: Shelf",
    SeedCT07 = "Sewer Entrance: Chest",
    SeedCT08 = "Sewer Entrance: Maeda",
    SeedCT09 = "Sewer Maze, A/4: Sparkle",
    SeedCT10 = "Sewer Maze, B/1: Chest",
    SeedCT11 = "Sewer Maze, B/3: Sparkle",
    SeedCT12 = "Sewer Maze, B/6: Chest",
    SeedCT13 = "Sewer Maze, C/2: Chest",
    SeedCT14 = "Sewer Maze, C/6: Sparkle",
    SeedCT15 = "Sewer Maze, D/3: Chest",
    SeedCT16 = "Sewer Maze, D/8: Chest",
    SeedCT17 = "Sewer Maze, D/11: Chest",
    SeedCT18 = "Sewer Maze, E/4: Chest",
    SeedCT19 = "Sewer Maze, E/10: Sparkle",
    SeedCT20 = "Sewer Maze, F/9: Chest",
    SeedCT21 = "Sewer Exit, Catwalk: Chest",
    SeedCT22 = "Pump Station, Exterior: Gator Chest",
    SeedCT23 = "Pump Station, Exterior: Catwalk Chest",
    SeedCT24 = "Pump Station, Control Room: Chest",
    SeedSW01 = "Platform: Bench Chest",
    SeedSW02 = "Platform: Save Chest",
    SeedSW03 = "Exit: Chest",
    SeedSW04 = "Mole Tunnel: Chest",
    SeedSW05 = "Centipede Drop",
    SeedSW06 = "Subway Car: Chest 1",
    SeedSW07 = "Subway Car: Chest 2",
    SeedSW08 = "Subway Car: Chest 3",
    SeedSW09 = "Bridge Cop",
    SeedMU01 = "F1, Klamp Pursuit, Jurasic Park: Chest",
    SeedMU02 = "F1, Klamp Pursuit, Dino Skull: Chest",
    SeedMU03 = "F1, Klamp Pursuit, Troodon Hall: Right Chest",
    SeedMU04 = "F1, Klamp Pursuit, Troodon Hall: Left Chest",
    SeedMU05 = "F1, Storage Hall: Chest",
    SeedMU06 = "F1, Storage Room: Sout East Chest",
    SeedMU07 = "F1, Storage Room: South Chest",
    SeedMU08 = "F1, Storage Room: North Chest",
    SeedMU09 = "F1, Storage Room: Hidden Right Chest",
    SeedMU10 = "F1, Storage Room: Hidden Left Chest",
    SeedMU11 = "F1, Tribal Staircase: Chest",
    SeedMU12 = "F1, Stone Head Room: Chest",
    SeedMU13 = "F1, Fire Escape: Chest",
    SeedMU14 = "F2, Gemstone Staircase: Right Chest",
    SeedMU15 = "F2, Gemstone Staircase: Left Chest",
    SeedMU16 = "F3, Fire Escape: Chest",
    SeedMU17 = "F2, Festive Room: Chest",
    SeedMU18 = "F3, Pterodactyl Ambush: Chest",
    SeedMU19 = "F3, Stegosaurus Room: Chest",
    SeedMU20 = "F2, Museum Tent: Chest 1",
    SeedMU21 = "F2, Museum Tent: Chest 2",
    SeedMU22 = "F2, Security Office: Chest",
    SeedMU23 = "F4, Security Storage: SE Chest",
    SeedMU24 = "F4, Security Storage: SW Chest",
    SeedMU25 = "F4, Security Storage: NW Chest",
    SeedMU26 = "F4, Security Storage: Center Chest",
    SeedMU27 = "F2, Klamp's Office: Maeda",
    SeedMU28 = "F2, Klamp's Office: Klamp",
    SeedMU29 = "F4, Forgotten Landing: Chest",
    SeedMU30 = "F1, T-Rex Drop",
    SeedMU31 = "F2, Broken Display: Right Chest",
    SeedMU32 = "F3, Triceratops Drop",
    SeedMU33 = "F1, T-Rex: Left Chest",
    SeedMU34 = "F1, T-Rex: Right Chest",
    SeedMU35 = "F2, Broken Display: Left Chest",
    SeedMU36 = "F3, Final Approach: Right Chest",
    SeedMU37 = "F3, Final Approach: Left Chest",
}

key_items = {
    fuse_1 = 0XCE,
    fuse_2 = 0XCF,
    fuse_3 = 0XD0,
    narita = 0XCB,
    mayoke = 0XCC,
    hamaya = 0XCD,
    zoo_key = 0XCA,
    tool_kit  = 0X35,
    pump_key  = 0XD4,
    gate_key  = 0XDB,
    klamp_key = 0XD5,
    super_junk   = 0X0B,
    locker_key   = 0XD7,
    storage_key  = 0XD6,
    autopsy_key  = 0XD1,
    theater_key  = 0XC8,
    weapon_memo  = 0XD8,
    elevator_key = 0XDA,
    rehearse_key   = 0XC9,
    blue_card_key  = 0XD2,
    warehouse_key  = 0XDC,
    green_card_key = 0XD3,
    super_tool_kit = 0X36
}

normal_items = {
    --[[nothing = 0x00,]] bullets6 = 0x01, bullets15 = 0x02, bullets30 = 0x03,
    dnabullets15 = 0x04, rocket9 = 0x05, medicine1 = 0x06, medicine2 = 0x07,
    medicine3 = 0x08, medicine4 = 0x09, full_recovery = 0x0a, --duper_junk = 0x0c,
    cure_p = 0x0d, cure_d = 0x0e, cure_c = 0x0f, cure_m = 0x10, fullcure = 0x11,
    revive = 0x12, junk = 0x14, trading_card = 0x15, tool = 0x16, super_tool = 0x17,
    --[[item24 = 0x18, item25 = 0x19, ammo_crate = 0x1a, rocket_crate = 0x1b,
    maeda_crate = 0x1c,]] offense1 = 0x1d, offense2 = 0x1e, offense3 = 0x1f,
    offense4 = 0x20, range1 = 0x21, range2 = 0x22, range3 = 0x23, range4 = 0x24,
    bullet_cap1 = 0x25, bullet_cap2 = 0x26, bullet_cap3 = 0x27, bullet_cap4 = 0x28,
    defense1 = 0x29, defense2 = 0x2a, defense3 = 0x2b, defense4 = 0x2c, cr_evade1 = 0x2d,
    cr_evade2 = 0x2e, cr_evade3 = 0x2f, cr_evade4 = 0x30, pe1 = 0x31, pe2 = 0x32,
    pe3 = 0x33, pe4 = 0x34, --[[toolkit = 0x35, super_toolkit = 0x36,]] mod_permit = 0x37,
    --[[chrysler_key1 = 0x38, chrysler_key2 = 0x39, chrysler_key3 = 0x3a,
    chrysler_key4 = 0x3b, chrysler_key5 = 0x3c, chrysler_key6 = 0x3d,
    chrysler_key7 = 0x3e,]] club1 = 0x3f, club2 = 0x40, club3 = 0x41, club4 = 0x42,
    club5 = 0x43, m84f = 0x44, m9 = 0x45, m9_2 = 0x46, m9_3 = 0x47, m8000 = 0x48,
    m96 = 0x49, m96r = 0x4a, p220 = 0x4b, p220_2 = 0x4c, p228 = 0x4d, p226 = 0x4e,
    p229 = 0x4f, m1911a1 = 0x50, m1911a2 = 0x51, m1911a3 = 0x52, m1911a4 = 0x53,
    m1911a5 = 0x54, p8 = 0x55, usp = 0x56, usp_2 = 0x57, usp_3 = 0x58, mark23 = 0x59,
    g19 = 0x5a, g23 = 0x5b, g22 = 0x5c, g20 = 0x5d, m712 = 0x5e, ppk = 0x5f,
    am44 = 0x60, maeda_gun = 0x61, ppsh41 = 0x62, sp1c = 0x63, usp_tu = 0x64,
    ak_47 = 0x65, de50ae7 = 0x66, --[[debug_smg = 0x67,]] m870 = 0x68, m870_2 = 0x69,
    m500 = 0x6a, m500_2 = 0x6b, maverick = 0x6c, s12 = 0x6d, m10b = 0x6e, m11 = 0x6f,
    m10 = 0x70, mp5k = 0x71, mp5pdw = 0x72, mp5a5 = 0x73, mp5sd6 = 0x74, micro_uz = 0x75,
    mini_uz = 0x76, full_uz = 0x77, p90 = 0x78, m16a1 = 0x79, m16a2 = 0x7a, sg550 = 0x7b,
    sar = 0x7c, g3a3 = 0x7d, type64 = 0x7e, xm177e2 = 0x7f, psg_1 = 0x80, fa_mas = 0x81,
    mag = 0x82, m203 = 0x83, m203_2 = 0x84, m203_3 = 0x85, m203_4 = 0x86, m203_5 = 0x87,
    m203_6 = 0x88, m79 = 0x89, m79_2 = 0x8a, m79_3 = 0x8b, m79_4 = 0x8c, m79_5 = 0x8d,
    m79_6 = 0x8e, hk40 = 0x8f, at4 = 0x90, at4_1 = 0x91, law_80 = 0x92,
    --[[maeda_gun_wb = 0x93,]] m92f = 0x94, dress = 0x95, n_vest = 0x96, n_protector = 0x97,
    n_jacket = 0x98, n_suit = 0x99, n_armor = 0x9a, kv_vest1 = 0x9b, kv_protector = 0x9c,
    kv_jacket = 0x9d, kv_suit1 = 0x9e, kv_armor1 = 0x9f, sp_vest1 = 0xa0, sp_vest2 = 0xa1,
    sp_protector = 0xa2, sp_jacket = 0xa3, sp_suit1 = 0xa4, sp_suit2 = 0xa5,
    sp_armor1 = 0xa6, sp_armor2 = 0xa7, sv_vest1 = 0xa8, sv_vest2 = 0xa9,
    sv_protector = 0xaa, sv_jacket = 0xab, sv_suit1 = 0xac, sv_suit2 = 0xad,
    sv_armor1 = 0xae, sv_armor2 = 0xaf, cr_vest1 = 0xb0, cr_vest2 = 0xb1,
    cr_protector = 0xb2, cr_jacket = 0xb3, cr_suit1 = 0xb4, cr_suit2 = 0xb5,
    cr_armor1 = 0xb6, cr_armor2 = 0xb7, b_vest1 = 0xb8, b_vest2 = 0xb9,
    b_protector = 0xba, b_jacket1 = 0xbb, b_jacket2 = 0xbc, b_suit1 = 0xbd,
    b_suit2 = 0xbe, b_armor = 0xbf, cm_vest1 = 0xc0, cm_vest2 = 0xc1, cm_protector = 0xc2,
    cm_jacket = 0xc3, cm_suit1 = 0xc4, cm_armor1 = 0xc5, cm_armor2 = 0xc6, --[[cm_suit2 = 0xc7,
    medal = 0xd9,]] gsp_tcard = 0xdd, p38_tcard = 0xde, bhawk_tcard = 0xdf,
    kasul_tcard = 0xe0, ppks_tcard = 0xe1, m1_tcard = 0xe2, mk5_tcard = 0xe3,
    mp44_tcard = 0xe4, bar_tcard = 0xe5, mg42_tcard = 0xe6, m29_tcard = 0xe7,
    m73_tcard = 0xe8, type38_tcard = 0xe9, type3_tcard = 0xea, eagle_tcard = 0xeb
}

key_item_logic = {
    [key_items.klamp_key] = function()
        table.shallow(location_pool, checks.kkey)
    end,
    [key_items.locker_key] = function()
        table.shallow(location_pool, checks.lkey)
    end,
    [key_items.super_junk] = function()
        table.shallow(location_pool, checks.sjunk)
    end,
    [key_items.theater_key] = function()
        table.shallow(location_pool, checks.tkey)
    end,
    [key_items.storage_key] = function()
        table.shallow(location_pool, checks.skey)
    end,
    [key_items.autopsy_key] = function()
        table.shallow(location_pool, checks.akey)
    end,
    [key_items.rehearse_key] = function()
        table.shallow(location_pool, checks.rkey)
    end,
    [key_items.warehouse_key] = function()
        table.shallow(location_pool, checks.wkey)
    end,  
    [key_items.blue_card_key] = function()
        flags.bckey = true

        table.shallow(location_pool, checks.bckey)

        if rulecheck(rules.blue_card.fuse)  then table.shallow(location_pool, checks.fuse)  end
        if rulecheck(rules.blue_card.gckey) then table.shallow(location_pool, checks.gckey) end
        if rulecheck(rules.blue_card.ekey)  then table.shallow(location_pool, checks.ekey)  end
    end,
    [key_items.fuse_1] = function()
        flags.f1 = true

        if rulecheck(rules.f1.fuse)  then table.shallow(location_pool, checks.fuse)  end
        if rulecheck(rules.f1.gckey) then table.shallow(location_pool, checks.gckey) end
        if rulecheck(rules.f1.ekey)  then table.shallow(location_pool, checks.ekey)  end
    end,
    [key_items.fuse_2] = function()
        flags.f2 = true

        if rulecheck(rules.f2.fuse)  then table.shallow(location_pool, checks.fuse)  end
        if rulecheck(rules.f2.gckey) then table.shallow(location_pool, checks.gckey) end
        if rulecheck(rules.f2.ekey)  then table.shallow(location_pool, checks.ekey)  end
    end,
    [key_items.fuse_3] = function()
        flags.f3 = true

        if rulecheck(rules.f3.fuse)  then table.shallow(location_pool, checks.fuse)  end
        if rulecheck(rules.f3.gckey) then table.shallow(location_pool, checks.gckey) end
        if rulecheck(rules.f3.ekey)  then table.shallow(location_pool, checks.ekey)  end
    end,
    [key_items.green_card_key] = function()
        flags.gckey = true

        if rulecheck(rules.green_card.gckey) then table.shallow(location_pool, checks.gckey) end
        if rulecheck(rules.green_card.ekey)  then table.shallow(location_pool, checks.ekey)  end
    end,
    [key_items.elevator_key] = function()
        flags.ekey = true

        if rulecheck(rules.green_card.ekey) then table.shallow(location_pool, checks.ekey)  end
    end,
    [key_items.gate_key] = function()
        if rulecheck(rules.gate_key.gor_pkey) then table.shallow(location_pool, checks.gor_pkey) end
        
        flags.gkey = true
    end,
    [key_items.pump_key] = function()
        if rulecheck(rules.pump_key.gor_pkey) then table.shallow(location_pool, checks.gor_pkey) end
    
        flags.pkey = true
    end,
    [key_items.zoo_key] = function()
        flags.zkey = true
        
        table.shallow(location_pool, checks.zkey)
        
        if rulecheck(rules.zoo_key.wmem) then table.shallow(location_pool, checks.wmem) end
    end,
    [key_items.weapon_memo] = function()
        flags.wmem = true
        
        if rulecheck(rules.weapon_memo.wmem) then table.shallow(location_pool, checks.wmem) end
    end
}

location_delimeters = {
    SeedCH02 = "Carnegie Hall\n",
    SeedPD01 = "\nNYPD Station\n",
    SeedCP01 = "\nCentral Park\n",
    SeedSH01 = "\nSoho\n",
    SeedHS01 = "\nHospital\n",
    SeedWH01 = "\nWarehouse\n",
    SeedCT01 = "\nChina Town\n",
    SeedSW01 = "\nSewers\n",
    SeedMU01 = "\nMuseum\n",
    SeedPE01 = "\n\n Parasite Energy\n"
}

per_seed           = {}
temp_pool          = {}
tool_pool          = {}
inverse_seed       = {}
item_spoiler_lines = {}

healing_pool = { normal_items.medicine1 }

item_names = table.invert(
                table.merge({},
                    table.shallow({}, key_items),
                    table.shallow({}, normal_items)
                )
            )

location_pool = table.hashmap(table.shallow({}, table.keys(locations)))

key_items_pool    = table.shallow({}, table.values(key_items))
normal_items_pool = table.shallow({}, table.values(normal_items))

location_pool.SeedPD23 = nil

for k, check in pairs(checks) do
    for _, v in ipairs(check) do
        location_pool[v] = nil
    end
end

location_pool = table.unhashmap(location_pool)

if Override == 0 then

    table.duplicate(normal_items_pool, normal_items.pe3, 1)
    table.duplicate(normal_items_pool, normal_items.junk, 3)
    table.duplicate(normal_items_pool, normal_items.range3, 1)
    table.duplicate(normal_items_pool, normal_items.rocket9, 2)
    table.duplicate(normal_items_pool, normal_items.rocket9, 2)
    table.duplicate(normal_items_pool, normal_items.offense3, 1)
    table.duplicate(normal_items_pool, normal_items.defense3, 1)
    table.duplicate(normal_items_pool, normal_items.cure_m, 2)
    table.duplicate(normal_items_pool, normal_items.cure_d, 2)
    table.duplicate(normal_items_pool, normal_items.cure_p, 3)
    table.duplicate(normal_items_pool, normal_items.cr_evade3, 1)
    table.duplicate(normal_items_pool, normal_items.bullet_cap3, 1)

    table.duplicate(healing_pool, normal_items.medicine2, 3)
    table.duplicate(healing_pool, normal_items.medicine3, 4)
    table.duplicate(healing_pool, normal_items.medicine4, 2)

    table.duplicate(tool_pool, normal_items.tool, 7)
    table.duplicate(tool_pool, normal_items.super_tool, 7)

       -- == LOGIC == --

    table.shallow(temp_pool, table.shuffle(key_items_pool))
    table.shallow(temp_pool, table.randoms(healing_pool, 30))
    table.shallow(temp_pool, table.randoms(tool_pool, 10))

    table.duplicate(temp_pool, normal_items.dna_bullets15, 2)
    table.duplicate(temp_pool, normal_items.bullets30, 1)
    table.duplicate(temp_pool, normal_items.rocket9, 2)
    table.duplicate(temp_pool, normal_items.revive, 5)

    for i = 1, #table.keys(locations) - #temp_pool - 1, 1 do
        temp_pool[#temp_pool + 1] = table.randpop(normal_items_pool)
    end

    for _, v in ipairs(temp_pool) do
        seed[table.randpop(location_pool)] = v

        if key_item_logic[v] then key_item_logic[v]() end

    end

    inverse_seed = table.invert(table.shallow({}, seed))

elseif Override == 1 then

    table.duplicate(normal_items_pool, normal_items.pe3, 1)
    table.duplicate(normal_items_pool, normal_items.junk, 3)
    table.duplicate(normal_items_pool, normal_items.defense3, 1)
    table.duplicate(normal_items_pool, normal_items.cure_m, 2)
    table.duplicate(normal_items_pool, normal_items.cure_d, 2)
    table.duplicate(normal_items_pool, normal_items.cure_p, 3)
    table.duplicate(normal_items_pool, normal_items.cr_evade3, 1)

    table.duplicate(healing_pool, normal_items.medicine2, 4)
    table.duplicate(healing_pool, normal_items.medicine3, 6)
    table.duplicate(healing_pool, normal_items.medicine4, 4)

    table.duplicate(tool_pool, normal_items.tool, 7)
    table.duplicate(tool_pool, normal_items.super_tool, 7)

       -- == LOGIC == --

    table.shallow(temp_pool, table.shuffle(key_items_pool))
    table.shallow(temp_pool, table.randoms(healing_pool, 35))
    table.shallow(temp_pool, table.randoms(tool_pool, 15))

    table.duplicate(temp_pool, normal_items.dna_bullets15, 2)
    table.duplicate(temp_pool, normal_items.revive, 5)

    for i = 1, #table.keys(locations) - #temp_pool - 1, 1 do
        temp_pool[#temp_pool + 1] = table.randpop(normal_items_pool)
    end

    for _, v in ipairs(temp_pool) do
        seed[table.randpop(location_pool)] = v

        if key_item_logic[v] then key_item_logic[v]() end

    end

    inverse_seed = table.invert(table.shallow({}, seed))

elseif Override == 2 then

    table.duplicate(normal_items_pool, normal_items.pe3, 1)
    table.duplicate(normal_items_pool, normal_items.range3, 1)
    table.duplicate(normal_items_pool, normal_items.offense3, 1)
    table.duplicate(normal_items_pool, normal_items.defense3, 1)
    table.duplicate(normal_items_pool, normal_items.cr_evade3, 1)
    table.duplicate(normal_items_pool, normal_items.bullet_cap3, 1)

    table.duplicate(healing_pool, normal_items.medicine2, 3)
    table.duplicate(healing_pool, normal_items.medicine3, 4)
    table.duplicate(healing_pool, normal_items.medicine4, 2)

    table.duplicate(tool_pool, normal_items.tool, 7)
    table.duplicate(tool_pool, normal_items.super_tool, 7)

       -- == LOGIC == --

    table.shallow(temp_pool, table.shuffle(key_items_pool))
    table.shallow(temp_pool, table.randoms(healing_pool, 30))
    table.shallow(temp_pool, table.randoms(tool_pool, 10))

    table.duplicate(temp_pool, normal_items.dna_bullets15, 2)
    table.duplicate(temp_pool, normal_items.mod_permit, 25)
    table.duplicate(temp_pool, normal_items.revive, 5)

    for i = 1, #table.keys(locations) - #temp_pool - 1, 1 do
        temp_pool[#temp_pool + 1] = table.randpop(normal_items_pool)
    end

    for _, v in ipairs(temp_pool) do
        seed[table.randpop(location_pool)] = v

        if key_item_logic[v] then key_item_logic[v]() end

    end

end

    inverse_seed = table.invert(table.shallow({}, seed))


    handle = io.open("item_spoiler.txt", "w")

    for _, v in ipairs(table.sort(table.shallow({}, table.keys(locations)))) do
        if location_delimeters[v] then
            group = location_delimeters[v]

            item_spoiler_lines[group] = {}
        end

        table.insert(item_spoiler_lines[group], v)
    end

    for header, group in pairs(item_spoiler_lines) do
        handle:write(header)

        padding = #locations[table.reduce(group, function(_, a, b) return #locations[a] > #locations[b] and a or b end, "SeedCH05")]

        for i, v in ipairs(group) do
            handle:write("\t" .. locations[v] .. string.rep(" ", padding - #locations[v]) .. "\t(" .. v ..") - " .. tostring(item_names[seed[v]]) .. "\n")
        end
    end

    handle:write(string.rep("\n", 16) .. " Key Item Only Spoilers\n")

    padding = #table.reduce(table.keys(key_items), function(i, a, b) return #a > #b and a or b end, "")

    for item, v in pairs(key_items) do
        handle:write("\t" .. item .. string.rep(" ", padding - #item) .. "\tis located at\t(" .. inverse_seed[v] .. ") " .. locations[inverse_seed[v]] .. "\n")
    end

    handle:close()

    for line in io.lines("per-seed.lua") do
        local modline, capture

        capture = string.match(line, "(Seed%a%a%d%d)%s+=%s0x%x%x?")

        if capture and capture ~= "SeedCH01" and string.sub(line, 5, 6) ~= "PE" then
            modline = capture .. string.rep("\t", 4) .. "=\t0x" .. tobase(seed[capture], 16)
        end
        
        if string.match(line, "SeedWindowColor") then

            menucolor = math.random(16777215)
            modline = "SeedWindowColor".. string.rep("\t", 3) .. "=\t0x00" .. tobase(menucolor,16)
            
        end
        if string.match(line, "SeedNum") then

            modline = "SeedNum".. string.rep("\t", 5) .. "=\t" .. RandomSeed
        end
        
        per_seed[#per_seed + 1] = modline or line
    end

    handle = io.open("per-seed.lua", "w")

    for _, v in ipairs(per_seed) do handle:write(v .. "\n") end

    handle:close()

    print("Item Shuffle Complete\n")

