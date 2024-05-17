# Parasite Eve Local Randomizer
(created by chrisaegrimm, Kaktus021 & skooter0070)


[ How To Generate Seeds ]
    
    - Currently only Bizhawk 2.9 is recommended for seed generation. Static seeds are not currently
      working 100% so if you want to play the same seed with multple people you'll have to give
      them the "per-seed.lua" file you generate.
    - Open config to confirm your desired setting (Commented settings are not yet implemented)
    - Open the lua console in Bizhawk
    - Run the "Seed Generator.lua" script (This will generate "per-seed.lua" and
      "item_spoiler.txt")


[ How To Run the Randomizer ]

    - Must be using at least Bizhawk 2.7 (2.8 preferred)
    - Load your Parastie Eve game
    - Open the lua console
    - Run the "per-SCRIPT.lua" file
    - Press start on you controller to initialize the script


[ Game Changes ]

    - You will spawn in an unused room in the NYPD and Aya will NOT be wearing her jacket. (If she
      ever has her jacket on something is wrong and the script has crashed)
    - Following the doors south will take you to the Day 5 save, followed by the world map.
    - You can access most locations immediately.
        - Soho will become accessable after completing Central Park as normal.
        - Subway will become accessable from the world map if you find the "Gate Key". 
    - Most bosses/mini bosses can have key items instead of their usual drop, specifically items
	  unique to the boss and not found elsewhere. Be careful not to skip them.
    - When going through NYPD story progression you no longer have to go to the Museum. 


[ Features ]

    - You'll recieve 60 ammo at the start of the game
    - Cutscene skip is enabled this works for most cutscenes.
    - In most places Aya's movement speed has been increased.
    - In most save rooms you can warp to the world map by pressing L1+R1+O
      (In the top left of the screen [S] means you can warp [X] means you cannot)
    - You can leave the Hospital basement without fixing the power by save warping.
      Going back to the F1 elevator will teleport you to the basement.
    - The China town sewers now have a rudamentary map. Yellow squares are checks. (Rework in the
	  future)


[ Key Item Changes ]
    
    - To access the NYPD under attack you require the "Super Junk". (It may just be called "Junk"
	  when you pick it up, but will have the key item icon.)
    - To enter the Soho gun shop you now require a "Weapon Memo"
    - The entrance to Subway via the China Town sewers is not lock at the pump station without the
	  "Pump Key"
    - Subway will become accessable from the world map if you find the "Gate Key".
    - You don't need to insert the fuses in the Hospital basement, but you do need all 3 in your
	  inventory to fix the power
    - To climb the final staircase in the Museum now requires all three lucky charms; Narita,
	  Mayoke, and Hamaya
    - You can recieve a "Maeda gun" in the item pool, it's not the "plot" maeda gun. (You recieve
	  that one on the carrier. MAKE SURE YOU HAVE ROOM FOR IT! or have another gun with Maeda
	  rounds on you.)


[ Known Bugs ]

    - USING SAVE STATES COULD POTENTIALLY DESTROY CRRNTPROG VARIABLES AND THUS YOUR RUN.
    - Most of the time the chest on the floor of the 2F Save room in NYPD will be open. (It will
	  always be ammo if it's there)
    - In the Hospital basment office, the drawer will be open if you enter while holding the "Blue
	  Keycard", possbily missing an important check.
    - Music carries over after using a save-warp. Music selection seems to be tied to transitions,
	  which don't seem to consistently choose from the same address.
    - Autopsy Key and Fuse vanilla locations despawn / duplicate. This is awaiting a full Hospital
	  rework once check detection is implemented.
    - The only way to lock the Green Cardkey door is to also remove door collision. You can walk
	  through the Green door, but the transition is disabled.
    - The very first time you enter a battle, Aya's model may spaz out. There's some initial state
	  somewhere that I haven't found a way to change and won't happen again.


[ Credits ]

    - chrisaegrimm: Randomizer script, data mining, Archipelago integration (in progress)
    - Kaktus021: PE shuffle script, data mining, clean up, readme
    - Skooter0070: Weapon shuffle script, PE shuffle script, debugging
    
    - If you have any questions, feel free to contact chrisaegrimm, either through the Archipelago
	  Discord in #future-game-design/Parasite Eve (PSX) or in the Parasite Eve Speedrunners Discord
	  in #pe1. You can also contact me on my own Discord server, No Schmoos Allowed in
	  #parasite-eve. On my Twitch channel (chrisaegrimm), even when I'm offline, you can access
	  chat and type !discord to get an invite.
