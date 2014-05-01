-- Helper script to quickly equip a ship with a core profile, for mission purposes.
-- Takes a pilot and a profile name, and re-specs that pilot according to the profile.
-- 
-- Example usage: p:coreProfile("medium")
function pilot.coreProfile(p, profile)
   -- Table of profiles indexed by profile name.
   -- Each profile contains core outfits for all sizes. The script will use the largest possible.
   local profiles =  {
                  low = 
                        {
                           small = {hull = "Unicorp C-2 Light Plating", engine = "Unicorp Hawk 300 Engine", system = "Unicorp PT-200 Core System"},
                           medium = {hull = "Unicorp D-8 Medium Plating",  engine = "Unicorp Falcon 1200 Engine", system = "Unicorp PT-600 Core System"},
                           large = {hull = "Unicorp C-16 Heavy Plating",  engine = "Unicorp Eagle 6500 Engine", system = "Unicorp PT-1200 Core System"}
                        },
                  medium = 
                        {
                           small = {hull = "Schafer & Kane Light Combat Plating",  engine = "Nexus Dart 300 Engine", system = "Milspec Orion 2301 Core System"},
                           medium = {hull = "Schafer & Kane Medium Combat Plating Alpha",  engine = "Nexus Arrow 550 Engine", system = "Milspec Orion 3701 Core System"},
                           large = {hull = "Schafer & Kane Heavy Combat Plating Alpha",  engine = "Nexus Bolt 4500 Engine", system = "Milspec Gemini 3308 Core System"}
                        },
                  high = 
                        {
                           small = {hull = "Schafer & Kane Light Combat Plating",  engine = "Tricon Zephyr Engine", system = "Milspec Orion 5501 Core System"},
                           medium = {hull = "Schafer & Kane Medium Combat Plating Gamma",  engine = "Tricon Cyclone Engine", system = "Milspec Orion 5501 Core System"},
                           large = {hull = "Schafer & Kane Heavy Combat Plating Gamma",  engine = "Tricon Typhoon Engine", system = "Milspec Orion 9901 Core System"}
                        },
                  low_trader = 
                        {
                           small = {hull = "Unicorp Small Cargo Hull",  engine = "Melendez Ox Engine", system = "Unicorp PT-200 Core System"},
                           medium = {hull = "Unicorp Medium Cargo Hull",  engine = "Melendez Buffalo Engine", system = "Unicorp PT-600 Core System"},
                           large = {hull = "Unicorp Large Cargo Hull",  engine = "Melendez Mammoth Engine", system = "Unicorp PT-1200 Core System"}
                        },
                  high_trader = 
                        {
                           small = {hull = "Schafer &amp; Kane Small Cargo Hull",  engine = "Melendez Ox XL Engine", system = "Milspec Orion 2302 Core System"},
                           medium = {hull = "Schafer &amp; Kane Medium Cargo Hull",  engine = "Melendez Buffalo XL Engine", system = "Milspec Orion 3702 Core System"},
                           large = {hull = "Schafer &amp; Kane Large Cargo Hull",  engine = "Melendez Mammoth XL Engine", system = "Milspec Orion 4802 Core System"}
                        },
               }
   
   -- Before doing anything drastic, make sure the profile passed is valid.
   if profiles[profile] == nil then
      warn("pilot.coreProfile: " .. profile .. " is not a valid profile")
      return
   end
   
   profile = profiles[profile]
   
   -- Strip the cores, but leave all other equipment intact.
   p:rmOutfit("cores")
   
   local sizes = {"large", "medium", "small"}
   local ctypes = {"hull", "engine", "system"}

   -- For checking whether all cores were properly populated.
   local equipped = {}
   for _, ctype in ipairs(ctypes) do
      equipped[ctype] = 0
   end
   
   -- Attempt to fit the cores in the selected profile onto the ship.
   -- Start with the large slots and work down to the small ones.
   for _, size in ipairs(sizes) do
      for _, ctype in ipairs(ctypes) do
      local success = 0
         repeat -- This is in a repeat..until loop, because it's possible for the ship to have multiple core slots of the same type.
            success = p:addOutfit(profile[size][ctype])
            equipped[ctype] = equipped[ctype] + success
         until success == 0
      end
   end
   
   -- Now we must make sure all core types got at least one core outfit, and if not, warn.
   for _, ctype in ipairs(ctypes) do
      if equipped[ctype] == 0 then
         warn("pilot.coreProfile: failed to equip " .. ctype .. " core on pilot " .. p:name() .. ".")
      end
   end
end
