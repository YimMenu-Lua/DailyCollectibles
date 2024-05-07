local daily_collectibles_tab = gui.get_tab("Daily Collectibles")

local challenges_tab     = daily_collectibles_tab:add_tab("Challenges")
local dead_drop_tab      = daily_collectibles_tab:add_tab("G's Cache")
local stash_house_tab    = daily_collectibles_tab:add_tab("Stash House")
local street_dealer_tab  = daily_collectibles_tab:add_tab("Street Dealers")
local shipwrecked_tab    = daily_collectibles_tab:add_tab("Shipwreck")
local hidden_cache_tab   = daily_collectibles_tab:add_tab("Hidden Caches")
local junk_skydive_tab   = daily_collectibles_tab:add_tab("Junk Energy Skydives")
local treasure_chest_tab = daily_collectibles_tab:add_tab("Treasure Chests")
local buried_stash_tab   = daily_collectibles_tab:add_tab("Buried Stashes")
local exotic_exports_tab = daily_collectibles_tab:add_tab("Exotic Exports")
local time_trials_tab    = daily_collectibles_tab:add_tab("Time Trials")

-- Credit to Senexis: https://github.com/Senexis/RDO-GG-Tunables/blob/main/public/data/daily_objectives.json https://github.com/Senexis/RDO-GG-Tunables/blob/main/public/data/weekly_objectives.json
local daily_challenges = {
  "Participate in a Land Race.",
  "Participate in a Bike Race.",
  "Participate in an Air Race.",
  "Participate in a Sea Race.",
  "Participate in a Rally Race.",
  "Participate in a GTA Race.",
  "Participate in a Non-Contact Race.",
  "Participate in a Team Deathmatch.",
  "Participate in a Deathmatch.",
  "Participate in a Vehicle Deathmatch.",
  "Participate in a Parachute Jump.",
  "Participate in a Last Team Standing.",
  "Participate in a Capture - Contend.",
  "Participate in a Capture - Hold.",
  "Participate in a Capture - Raid.",
  "Participate in a Capture - GTA.",
  "Participate in a Versus Mission.",
  "Complete a Contact Mission.",
  "Participate in a Survival.",
  "Hold up a store.",
  "Complete a Gang Attack.",
  "Participate in an Impromptu Race.",
  "Participate in One on One Deathmatch.",
  "Go to the Movies.",
  "Fly under a bridge in an Air Race.",
  "Ride on one of the Fairground Rides.",
  "Steal a vehicle from the military base.",
  "Mod a vehicle at a car mod shop.",
  "Perform a Stunt Jump.",
  "Deliver an Export vehicle to Simeon.",
  "Collect a Bounty.",
  "Kill a player while Off the Radar.",
  "Kill a revealed player.",
  "Bribe the Cops then cause havoc.",
  "Call a Mugger on another player.",
  "Use some Bull Shark Testosterone.",
  "Collect an Ammo Drop.",
  "Play a game of Darts.",
  "Play a round of Golf.",
  "Play a match of Tennis.",
  "Challenge a player at Arm Wrestling.",
  "Go for a round at the Shooting Range.",
  "Complete a Flight School lesson.",
  "Kill 10 players.",
  "Destroy 10 vehicles.",
  "Steal 10 vehicles.",
  "Escape a 3 star Wanted Level.",
  "Fall for 325 feet and survive.",
  "Parachute from 650 feet.",
  "Deploy your parachute near the ground.",
  "Perform a wheelie for 10 seconds.",
  "Participate in a Capture.",
  "Participate in the Featured Series.",
  "Participate in the Adversary Series.",
  "Participate in the Stunt Series.",
  "Participate in the Special Race Series.",
  "Participate in the Transform Series.",
  "Participate in the SASS Series.",
  "Participate in the Arena War Series.",
  "Participate in the Bunker Series.",
  "Participate in the Race Series.",
  "Participate in the Survival Series.",
  "Participate in a King of the Hill.",
  "Participate in a Client Job.",
  "Participate in VIP Work.",
  "Participate in Club Work.",
  "Participate in a Clubhouse Contract.",
  "Participate in a Business Battle.",
  "Participate in a Freemode Event.",
  "Participate in a Freemode Challenge.",
  "Complete a Lowrider mission.",
  "Complete a Dispatch mission.",
  "Complete a Heist Setup.",
  "Complete a Heist Finale.",
  "Complete a Doomsday Heist Prep.",
  "Complete a Doomsday Heist Setup.",
  "Complete a Doomsday Heist Finale.",
  "Participate in Come Out To Play.",
  "Participate in Siege Mentality.",
  "Participate in Hasta La Vista.",
  "Participate in Cross the Line.",
  "Participate in Hunting Pack.",
  "Participate in Keep the Pace.",
  "Participate in Offense Defense.",
  "Participate in Relay.",
  "Participate in Slasher.",
  "Participate in Extraction.",
  "Participate in Beast vs. Slasher.",
  "Participate in Drop Zone.",
  "Participate in Till Death Do Us Part.",
  "Participate in Sumo.",
  "Participate in Inch By Inch.",
  "Participate in Trading Places.",
  "Participate in Power Play.",
  "Participate in Entourage.",
  "Participate in Slipstream.",
  "Participate in Lost vs Damned.",
  "Participate in Deadline.",
  "Participate in Kill Quota.",
  "Participate in Turf Wars.",
  "Participate in Vehicle Vendetta.",
  "Participate in Collection Time.",
  "Participate in Juggernaut.",
  "Participate in Resurrection.",
  "Participate in Tiny Racers.",
  "Participate in Dawn Raid.",
  "Participate in Overtime Rumble.",
  "Participate in Power Mad.",
  "Participate in Overtime Shootout.",
  "Participate in Motor Wars.",
  "Participate in Bombushka Run.",
  "Participate in Stockpile.",
  "Participate in The Vespucci Job.",
  "Participate in Hunting Pack (Remix).",
  "Participate in Trading Places (Remix).",
  "Participate in Running Back (Remix).",
  "Participate in Sumo (Remix).",
  "Participate in Running Back.",
  "Participate in Every Bullet Counts.",
  "Participate in Rhino Hunt.",
  "Participate in In and Out.",
  "Participate in Bomb Ball.",
  "Participate in Buzzer Beater.",
  "Participate in Carnage.",
  "Participate in Tag Team.",
  "Participate in Games Masters.",
  "Participate in Here Come the Monsters.",
  "Participate in Wreck It.",
  "Participate in Hot Bomb.",
  "Participate in Flag War.",
  "Play the Shooting Range at a Bunker.",
  "Hire a player for your Motorcycle Club.",
  "Hire a player for your Organization.",
  "Set yourself as Looking for Work.",
  "Set yourself as Looking for an MC.",
  "Resupply the Cocaine Lockup.",
  "Resupply the Weed Farm.",
  "Resupply the Counterfeit Cash Factory.",
  "Resupply the Meth Lab.",
  "Resupply the Document Forgery Office.",
  "Resupply the Bunker.",
  "Source Special Cargo.",
  "Source Air-Freight Cargo.",
  "Source Vehicle Cargo.",
  "Sell Special Cargo.",
  "Sell Air-Freight Cargo.",
  "Sell Weapons.",
  "Sell Cocaine.",
  "Sell Weed.",
  "Sell Counterfeit Cash.",
  "Sell Meth.",
  "Sell Forged Documents.",
  "Export Vehicle Cargo.",
  "Sell Goods from your Nightclub.",
  "Complete Club Management.",
  "Order a drink from a bar.",
  "Dance in a player owned Nightclub.",
  "Relax in a hot tub.",
  "Fly a Drone.",
  "Drive an RC Bandito.",
  "Go Scuba Diving.",
  "Have a snowball fight.",
  "Get a headshot with the Double-Action Revolver.",
  "Rampage with the Stone Hatchet.",
  "Modify a MKII weapon.",
  "Modify an aircraft at your Hangar.",
  "Modify a vehicle at your Arena Workshop.",
  "Modify a vehicle at Benny's Original Motor Works.",
  "Modify a vehicle in the Mobile Operations Center.",
  "Modify a vehicle in the Avenger.",
  "Modify a vehicle at the Clubhouse.",
  "Visit The Diamond Casino & Resort.",
  "Complete a mission for The Diamond Casino & Resort.",
  "Spin the Lucky Wheel.",
  "Complete a Special Vehicle Work.",
  "Complete a Simeon Repo.",
  "Complete a Diamond Casino Heist Prep.",
  "Complete The Diamond Casino Heist Finale.",
  "Play any game in an Arcade.",
  "Dance in The Music Locker.",
  "Dance at the Cayo Perico beach party.",
  "Participate in the Street Race Series.",
  "Participate in the Pursuit Series.",
  "Visit the LS Car Meet.",
  "Visit the LS Car Meet with a Personal Vehicle.",
  "Drive an LS Car Meet vehicle in the Test Track.",
  "Spectate the Test Track inside the LS Car Meet.",
  "Participate in a Sprint at the LS Car Meet.",
  "Deliver an Exotic Exports Vehicle to the Docks.",
  "Complete a Planning Work mission.",
  "Complete a Contract for KDJ and Sessanta.",
  "Participate in a Scramble at the LS Car Meet.",
  "Participate in a Head-to-Head at the LS Car Meet.",
  "Complete 1 lap of the Time Trial at the LS Car Meet.",
  "Visit Record A Studios.",
  "Complete a Security Contract.",
  "Complete a Payphone Hit.",
  "Complete an Investigation for Dr. Dre.",
  "Complete a Short Trip.",
  "Participate in a HSW Race.",
  "Participate in the Community Series.",
  "Participate in the Cayo Perico Series.",
  "Participate in Assault on Cayo Perico.",
  "Visit The Freakshop.",
  "Complete a First Dose mission.",
  "Complete a Last Dose mission.",
  "Complete a Fooligan Job.",
  "Complete one fare during Taxi Work.",
  "Raid a Stash House.",
  "Collect G's Cache.",
  "Sell any product to a Street Dealer.",
  "Complete a Junk Energy Time Trial.",
  "Complete a Resupply Mission for the Acid Lab.",
  "Sell Acid.",
  "Complete a Project Overthrow mission.",
  "Complete an LSA Operation.",
  "Complete Slush Fund.",
  "Complete Scene of the Crime.",
  "Participate in the Drag Race Series.",
  "Participate in the Drift Race Series.",
  "Recover a vehicle using the Tow Truck.",
  "Photograph an animal for the LS Tourist Board."
}

local weekly_challenges = {
  "Complete 5 Fooligan Jobs.",
  "Complete the Assassination Bonus on 5 Payphone Hits.",
  "Complete 10 Security Contracts.",
  "Complete 3 Short Trips.",
  "Complete Don't Fuck with Dre.",
  "Complete the Elite Challenge for The Cayo Perico Heist.",
  "Complete The Cayo Perico Heist undetected.",
  "Complete The Cayo Perico Heist without dying.",
  "Complete The Cayo Perico Heist 2 times.",
  "Complete any Diamond Casino Heist Elite Challenge.",
  "Complete The Diamond Casino Heist 2 times.",
  "Rob the Daily Vault in The Diamond Casino Heist.",
  "Complete 5 Casino Works for Agatha Baker.",
  "Complete the Elite Challenge for The Data Breaches.",
  "Complete the Elite Challenge for The Bogdan Problem.",
  "Complete the Elite Challenge for The Doomsday Scenario.",
  "Complete The Doomsday Scenario.",
  "Participate in 10 Arena War modes.",
  "Win 3 Arena War modes.",
  "Complete 5 LSA Operations on Specialist.",
  "Complete 1 Project Overthrow Missions.",
  "Complete 5 Mobile Operations.",
  "Complete 5 Mobile Operations on Hard difficulty.",
  "Complete 5 Special Vehicle Works on Hard difficulty.",
  "Complete 5 Special Vehicle Works.",
  "Complete 10 Clubhouse Contracts.",
  "Complete 5 Motorcycle Club Challenges.",
  "Participate in 5 VIP Challenges.",
  "Complete 3 Heist finales.",
  "Complete all 10 waves of a Survival.",
  "Survive 5 waves in a Survival without dying.",
  "Participate in 6 Drag Races.",
  "Win 5 Races.",
  "Win 5 LS Car Meet Races.",
  "Beat the par time in 3 Time Trials.",
  "Beat the par time in 3 RC Bandito Time Trials.",
  "Win 3 Deathmatches.",
  "Win 3 Team Deathmatches.",
  "Win 3 Drag or Drift Races.",
  "Win 5 Adversary Modes.",
  "Participate in 6 Drift Races.",
  "Complete 25 fares during Taxi Work.",
  "Achieve a gold medal in 10 Junk Energy Skydives.",
  "Beat the par time in 3 Junk Energy Time Trials.",
  "Collect 3 player bounties.",
  "Deliver 3 Export vehicles to Simeon.",
  "Steal from 3 Stash Houses.",
  "Collect 3 G's Caches.",
  "Discover 3 Shipwrecks.",
  "Sell to 3 Street Dealers.",
  "Complete 3 Last Dose Missions.",
  "Complete 3 First Dose Missions.",
  "Collect 10 Hidden Caches.",
  "Complete 5 CEO or VIP Works.",
  "Win 3 Stunt Races.",
  "Win 3 Hotring Series Races.",
  "Win 3 Open Wheel Races.",
  "Win 3 RC Bandito Races.",
  "Win 3 Pursuit Races.",
  "Complete 5 Terrorbyte Client Jobs.",
  "Complete 5 Nightclub Management Missions.",
  "Sell $3,000,000 across all businesses.",
  "Earn $100,000 in wages as an Associate or Bodyguard.",
  "Complete 3 Business Resupply Missions.",
  "Complete 3 Gerald's Last Play Missions.",
  "Complete 3 Premium Deluxe Repo Work Missions.",
  "Complete 3 A Superyacht Life Missions.",
  "Complete 3 Bunker Research Missions.",
  "Complete the Ammu-Nation Contract 3 times.",
  "Complete a Salvage Yard Robbery without dying.",
  "Deliver 10 Exotic Exports vehicles.",
  "Complete 3 Auto Shop Contract Finales.",
  "Deliver 3 vehicles for the Auto Shop Service.",
  "Complete 3 Salvage Yard Robberies.",
  "Complete Scene of the Crime.",
  "Recover 10 vehicles using the Tow Truck.",
  "Photograph 10 animals for Shoot Animals photography.",
  "Create a Job in the Job Creator.",
  "Steal from 2 Armored Trucks.",
  "Take part in 5 Freemode Challenges.",
  "Participate in 5 Freemode Events.",
  "Successfully Complete 10 Stunt Jumps.",
  "Earn $50,000 Arcade daily earnings.",
  "Complete 5 Business Battles.",
  "Complete 3 Last Dose Missions on Hard.",
  "Eat 3 peyote.",
  "Earn $2,000,000 from selling Special Cargo.",
  "Earn $2,000,000 from selling Vehicle Cargo.",
  "Earn $50,000 from Nightclub daily earnings.",
  "Earn $2,000,000 from selling Product.",
  "Complete The Data Breaches.",
  "Complete The Bogdan Problem.",
  "Complete 3 First Dose Missions on Hard.",
  "Win in 3 Snowball Deathmatches.",
  "Win Beast vs. Slasher.",
  "Fight off the Gooch.",
  "Kill your clone in Clone Slasher."
}

local selected_dealer   = 0
local selected_cache    = 0
local selected_skydive  = 0
local selected_treasure = 0
local selected_stash    = 0
local selected_trial    = 0

local weekly_obj_id            = 0
local weekly_obj_override      = 0
local dead_drop_area           = 0
local dead_drop_loc            = 0
local stash_house_loc          = 0
local shipwrecked_loc          = 0
local max_cocaine              = 0
local max_meth                 = 0
local max_weed                 = 0
local max_acid                 = 0
local total_products           = 0
local all_products             = 0
local vehicle_location         = 0
local vehicle_index            = 0
local vehicle_order            = 0
local active_vehicle           = 0
local vehicle_bitset           = 0
local dead_drop_collected      = false
local stash_house_raided       = false
local shipwrecked_collected    = false
local exotic_reward_ready      = false
local safe_code                = ""
local daily_obj                = {}
local street_dealer_loc        = {}
local hidden_cache_loc         = {}
local junk_skydive_loc         = {}
local treasure_chest_loc       = {}
local buried_stash_loc         = {}
local time_trial_loc           = {}
local hidden_cache_collected   = {}
local treasure_chest_collected = {}
local buried_stash_collected   = {}
local meth_unit                = {}
local weed_unit                = {}
local cocaine_unit             = {}
local acid_unit                = {}

local function format_int(number)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    return minus .. int:reverse():gsub("^,", "") .. fraction
end

local function help_marker(text)
    ImGui.TextDisabled("(?)")
    if ImGui.IsItemHovered() then
        ImGui.BeginTooltip()
        ImGui.PushTextWrapPos(ImGui.GetFontSize() * 35)
        ImGui.TextUnformatted(text)
        ImGui.PopTextWrapPos()
        ImGui.EndTooltip()
    end
end

local function get_daily_reset_time(target_time)
    local current_utc = os.date("!*t")
    local hours_left  = (24 - current_utc.hour + target_time) % 24
    local mins_left   = 60 - current_utc.min
    local secs_left   = 60 - current_utc.sec
    return hours_left, mins_left, secs_left
end

local function teleport(coords)
    script.run_in_fiber(function()
        PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), coords.x, coords.y, coords.z)
    end)
end

local function has_bit_set(address, pos)
    return (address & (1 << pos)) ~= 0
end

local function spawn_vehicle(vehicle_joaat)
    script.run_in_fiber(function(script)
        local load_counter = 0
    	while not STREAMING.HAS_MODEL_LOADED(vehicle_joaat) do
    		STREAMING.REQUEST_MODEL(vehicle_joaat);
    		script:yield();
    		if load_counter > 100 then
    			return
    		else
    			load_counter = load_counter + 1
    		end
    	end
    	local laddie   = PLAYER.PLAYER_PED_ID()
    	local location = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), false)
    	local veh      = VEHICLE.CREATE_VEHICLE(vehicle_joaat, location.x, location.y, location.z, ENTITY.GET_ENTITY_HEADING(laddie), true, false, false)
    	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(vehicle_joaat)
    	DECORATOR.DECOR_SET_INT(veh, "MPBitset", 0)
    	local network_id = NETWORK.VEH_TO_NET(veh)
    	if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(veh) then
    		NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(network_id, true)
    	end
    	VEHICLE.SET_VEHICLE_IS_STOLEN(veh, false)
    	PED.SET_PED_INTO_VEHICLE(laddie, veh, -1)
    	ENTITY.SET_ENTITY_AS_NO_LONGER_NEEDED(veh)
    end)
end

local function get_safe_code()
    local combination_retn = ""
    for i = 0, 2, 1 do
    	if i == 2 then
    		combination_retn = combination_retn .. string.format("%02d",locals.get_int("fm_content_stash_house", 117 + 22 + (1 + (i * 2)) + 1))
    	else
    		combination_retn = combination_retn .. string.format("%02d",locals.get_int("fm_content_stash_house", 117 + 22 + (1 + (i * 2)) + 1)) .. "-"
    	end
    end
    return combination_retn
end

local function get_vehicle_name(index, return_joaat)
    local offset        = globals.get_int(1942466 + index) + 1
    local vehicle_joaat = globals.get_uint(1942455 + offset)
    if return_joaat == true then
    	return vehicle_joaat
    else
    	return vehicles.get_vehicle_display_name(vehicle_joaat)
    end
end

local function is_second_part(hash)
    if hash == joaat("asbo") then return false
    elseif hash == joaat("brioso") then return false
    elseif hash == joaat("buccaneer2") then return false
    elseif hash == joaat("dominator3") then return false
    elseif hash == joaat("elegy") then return false
    elseif hash == joaat("brawler") then return false
    elseif hash == joaat("flashgt") then return false
    elseif hash == joaat("gauntlet4") then return false
    elseif hash == joaat("issi3") then return false
    elseif hash == joaat("jugular") then return false
    elseif hash == joaat("kamacho") then return false
    elseif hash == joaat("komoda") then return false
    elseif hash == joaat("nightshade") then return false
    elseif hash == joaat("peyote3") then return false
    elseif hash == joaat("phoenix") then return false
    elseif hash == joaat("raiden") then return false
    elseif hash == joaat("retinue") then return false
    elseif hash == joaat("rocoto") then return false
    elseif hash == joaat("ruiner") then return false
    elseif hash == joaat("sabregt2") then return false
    elseif hash == joaat("savestra") then return false
    elseif hash == joaat("chino2") then return false
    elseif hash == joaat("cheburek") then return false
    elseif hash == joaat("cavalcade") then return false
    elseif hash == joaat("buffalo2") then return false
    elseif hash == joaat("alpha") then return false
    elseif hash == joaat("kanjo") then return false
    elseif hash == joaat("kuruma") then return false
    elseif hash == joaat("sentinel3") then return false
    elseif hash == joaat("sultan2") then return false
    elseif hash == joaat("yosemite2") then return false
    elseif hash == joaat("z190") then return false
    elseif hash == joaat("jackal") then return false
    elseif hash == joaat("vstr") then return false
    elseif hash == joaat("vagrant") then return false
    elseif hash == joaat("vamos") then return false
    elseif hash == joaat("tampa2") then return false
    elseif hash == joaat("tornado5") then return false
    elseif hash == joaat("tropos") then return false
    elseif hash == joaat("tulip") then return false
    end
    return true
end

local function get_challenge_time(skydive_location)
    if skydive_location == 0 then return "00:40.00"
    elseif skydive_location == 1 then return "00:40.00"
    elseif skydive_location == 2 then return "00:45.00"
    elseif skydive_location == 3 then return "01:25.00"
    elseif skydive_location == 4 then return "01:45.00"
    elseif skydive_location == 5 then return "01:35.00"
    elseif skydive_location == 6 then return "01:10.00"
    elseif skydive_location == 7 then return "00:40.00"
    elseif skydive_location == 8 then return "02:50.00"
    elseif skydive_location == 9 then return "02:50.00"
    elseif skydive_location == 10 then return "02:00.00"
    elseif skydive_location == 11 then return "01:55.00"
    elseif skydive_location == 12 then return "01:25.00"
    elseif skydive_location == 13 then return "01:20.00"
    elseif skydive_location == 14 then return "02:15.00"
    elseif skydive_location == 15 then return "01:30.00"
    elseif skydive_location == 16 then return "01:30.00"
    elseif skydive_location == 17 then return "01:47.00"
    elseif skydive_location == 18 then return "01:40.00"
    elseif skydive_location == 19 then return "01:50.00"
    elseif skydive_location == 20 then return "01:50.00"
    elseif skydive_location == 21 then return "01:35.00"
    elseif skydive_location == 22 then return "01:55.00"
    elseif skydive_location == 23 then return "01:50.00"
    elseif skydive_location == 24 then return "01:25.00"
    end
    return "unavailable"
end

local function get_par_time(trial_variant, trial_location)
    if trial_variant == 0 then
    	if trial_location == 0 then return "01:43.20"
    	elseif trial_location == 1 then return "02:04.40"
    	elseif trial_location == 2 then return "02:04.90"
    	elseif trial_location == 3 then return "00:46.30"
    	elseif trial_location == 4 then return "04:09.50"
    	elseif trial_location == 5 then return "01:44.00"
    	elseif trial_location == 6 then return "00:38.50"
    	elseif trial_location == 7 then return "01:10.10"
    	elseif trial_location == 8 then return "02:15.00"
    	elseif trial_location == 9 then return "02:07.20"
    	elseif trial_location == 10 then return "01:41.30"
    	elseif trial_location == 11 then return "01:17.80"
    	elseif trial_location == 12 then return "00:58.80"
    	elseif trial_location == 13 then return "02:29.40"
    	elseif trial_location == 14 then return "01:00.00"
    	elseif trial_location == 15 then return "01:19.00"
    	elseif trial_location == 16 then return "01:43.40"
    	elseif trial_location == 17 then return "01:24.20"
    	elseif trial_location == 18 then return "02:58.80"
    	elseif trial_location == 19 then return "01:26.60"
    	elseif trial_location == 20 then return "01:16.60"
    	elseif trial_location == 21 then return "00:54.20"
    	elseif trial_location == 22 then return "01:40.00"
    	elseif trial_location == 23 then return "02:05.00"
    	elseif trial_location == 24 then return "02:00.00"
    	elseif trial_location == 25 then return "02:35.00"
    	elseif trial_location == 26 then return "01:20.00"
    	elseif trial_location == 27 then return "02:24.00"
    	elseif trial_location == 28 then return "02:16.00"
    	elseif trial_location == 29 then return "01:50.00"
    	elseif trial_location == 30 then return "01:26.00"
    	elseif trial_location == 31 then return "02:10.00"
    	end
    elseif trial_variant == 1 then
    	if trial_location == 0 then return "01:50.00"
    	elseif trial_location == 1 then return "01:30.00"
    	elseif trial_location == 2 then return "01:20.00"
    	elseif trial_location == 3 then return "01:27.00"
    	elseif trial_location == 4 then return "01:10.00"
    	elseif trial_location == 5 then return "01:32.00"
    	elseif trial_location == 6 then return "02:05.00"
    	elseif trial_location == 7 then return "01:12.00"
    	elseif trial_location == 8 then return "01:53.00"
    	elseif trial_location == 9 then return "01:20.00"
    	elseif trial_location == 10 then return "01:23.00"
    	elseif trial_location == 11 then return "01:18.00"
    	elseif trial_location == 12 then return "01:27.00"
    	elseif trial_location == 13 then return "01:22.00"
    	end
    elseif trial_variant == 2 then
    	if trial_location == 0 then return "02:20.00"
    	elseif trial_location == 1 then return "02:00.00"
    	elseif trial_location == 2 then return "01:55.00"
    	elseif trial_location == 3 then return "01:35.00"
    	elseif trial_location == 4 then return "02:10.00"
    	elseif trial_location == 5 then return "01:40.00"
    	elseif trial_location == 6 then return "02:00.00"
    	elseif trial_location == 7 then return "01:50.00"
    	elseif trial_location == 8 then return "01:35.00"
    	elseif trial_location == 9 then return "01:20.00"
    	elseif trial_location == 10 then return "01:50.00"
    	elseif trial_location == 11 then return "01:35.00"
    	elseif trial_location == 12 then return "02:10.00"
    	elseif trial_location == 13 then return "01:50.00"
    	end
    end
    return "unavailable"
end

local function dead_drop_coords(area, location)
    if area == 0 then
    	if location == 0 then return vec3:new(1113.557, -645.957, 56.091)
    	elseif location == 1 then return vec3:new(1142.874, -662.951, 57.135)
    	elseif location == 2 then return vec3:new(1146.691, -703.717, 56.167)
    	elseif location == 3 then return vec3:new(1073.542, -678.236, 56.583)
    	elseif location == 4 then return vec3:new(1046.454, -722.915, 56.419)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    elseif area == 1 then
    	if location == 0 then return vec3:new(2064.713, 3489.88, 44.223)
    	elseif location == 1 then return vec3:new(2081.859, 3553.254, 42.157)
    	elseif location == 2 then return vec3:new(2014.72, 3551.499, 42.726)
    	elseif location == 3 then return vec3:new(1997.019, 3507.838, 39.666)
    	elseif location == 4 then return vec3:new(2045.597, 3564.346, 39.343)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    elseif area == 2 then
    	if location == 0 then return vec3:new(-1317.344, -1481.97, 3.923)
    	elseif location == 1 then return vec3:new(-1350.041, -1478.273, 4.567)
    	elseif location == 2 then return vec3:new(-1393.87, -1445.139, 3.437)
    	elseif location == 3 then return vec3:new(-1367.034, -1413.992, 2.611)
    	elseif location == 4 then return vec3:new(-1269.861, -1426.272, 3.556)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    elseif area == 3 then
    	if location == 0 then return vec3:new(-295.468, 2787.385, 59.864)
    	elseif location == 1 then return vec3:new(-284.69, 2848.234, 53.266)
    	elseif location == 2 then return vec3:new(-329.193, 2803.404, 57.787)
    	elseif location == 3 then return vec3:new(-306.847, 2825.6, 58.219)
    	elseif location == 4 then return vec3:new(-336.046, 2829.988, 55.448)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    elseif area == 4 then
    	if location == 0 then return vec3:new(-1725.245, 233.946, 57.685)
    	elseif location == 1 then return vec3:new(-1639.892, 225.521, 60.336)
    	elseif location == 2 then return vec3:new(-1648.48, 212.049, 59.777)
    	elseif location == 3 then return vec3:new(-1693.318, 156.665, 63.855)
    	elseif location == 4 then return vec3:new(-1699.193, 179.574, 63.185)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    elseif area == 5 then
    	if location == 0 then return vec3:new(-949.714, -710.658, 19.604)
    	elseif location == 1 then return vec3:new(-938.774, -781.817, 19.657)
    	elseif location == 2 then return vec3:new(-884.91, -786.863, 15.043)
    	elseif location == 3 then return vec3:new(-895.257, -729.943, 19.143)
    	elseif location == 4 then return vec3:new(-932.986, -746.452, 19.008)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    elseif area == 6 then
    	if location == 0 then return vec3:new(-425.948, 1213.342, 324.936)
    	elseif location == 1 then return vec3:new(-387.267, 1137.65, 321.704)
    	elseif location == 2 then return vec3:new(-477.999, 1135.36, 320.123)
    	elseif location == 3 then return vec3:new(-431.822, 1119.449, 325.964)
    	elseif location == 4 then return vec3:new(-387.902, 1161.655, 324.529)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    elseif area == 7 then
    	if location == 0 then return vec3:new(-3381.278, 965.534, 7.426)
    	elseif location == 1 then return vec3:new(-3427.724, 979.944, 7.526)
    	elseif location == 2 then return vec3:new(-3413.606, 961.845, 11.038)
    	elseif location == 3 then return vec3:new(-3419.585, 977.595, 11.167)
    	elseif location == 4 then return vec3:new(-3425.687, 961.215, 7.536)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    elseif area == 8 then
    	if location == 0 then return vec3:new(-688.732, 5828.4, 16.696)
    	elseif location == 1 then return vec3:new(-673.425, 5799.744, 16.467)
    	elseif location == 2 then return vec3:new(-710.348, 5769.631, 16.75)
    	elseif location == 3 then return vec3:new(-699.926, 5801.619, 16.504)
    	elseif location == 4 then return vec3:new(-660.359, 5781.733, 18.774)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    elseif area == 9 then
    	if location == 0 then return vec3:new(38.717, 6264.173, 32.88)
    	elseif location == 1 then return vec3:new(84.67, 6292.286, 30.731)
    	elseif location == 2 then return vec3:new(97.17, 6288.558, 38.447)
    	elseif location == 3 then return vec3:new(14.453, 6243.932, 35.445)
    	elseif location == 4 then return vec3:new(67.52, 6261.744, 32.029)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    elseif area == 10 then
    	if location == 0 then return vec3:new(2954.598, 4671.458, 50.106)
    	elseif location == 1 then return vec3:new(2911.146, 4637.608, 49.3)
    	elseif location == 2 then return vec3:new(2945.212, 4624.044, 49.078)
    	elseif location == 3 then return vec3:new(2941.139, 4617.117, 52.114)
    	elseif location == 4 then return vec3:new(2895.884, 4686.396, 48.094)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    elseif area == 11 then
    	if location == 0 then return vec3:new(1332.319, 4271.446, 30.646)
    	elseif location == 1 then return vec3:new(1353.332, 4387.911, 43.541)
    	elseif location == 2 then return vec3:new(1337.892, 4321.563, 38.093)
    	elseif location == 3 then return vec3:new(1386.603, 4366.511, 42.236)
    	elseif location == 4 then return vec3:new(1303.193, 4313.509, 36.939)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    elseif area == 12 then
    	if location == 0 then return vec3:new(2720.03, 1572.762, 20.204)
    	elseif location == 1 then return vec3:new(2663.161, 1581.395, 24.418)
    	elseif location == 2 then return vec3:new(2661.482, 1641.057, 24.001)
    	elseif location == 3 then return vec3:new(2671.003, 1561.394, 23.882)
    	elseif location == 4 then return vec3:new(2660.104, 1606.54, 28.61)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    elseif area == 13 then
    	if location == 0 then return vec3:new(211.775, -934.269, 23.466)
    	elseif location == 1 then return vec3:new(198.265, -884.039, 30.696)
    	elseif location == 2 then return vec3:new(189.542, -919.726, 29.96)
    	elseif location == 3 then return vec3:new(169.504, -934.841, 29.228)
    	elseif location == 4 then return vec3:new(212.376, -934.807, 29.007)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    elseif area == 14 then
    	if location == 0 then return vec3:new(1330.113, -2520.754, 46.365)
    	elseif location == 1 then return vec3:new(1328.954, -2538.302, 46.976)
    	elseif location == 2 then return vec3:new(1237.506, -2572.335, 39.791)
    	elseif location == 3 then return vec3:new(1244.602, -2563.721, 42.646)
    	elseif location == 4 then return vec3:new(1278.421, -2565.117, 43.544)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    else return vec3:new(0.0, 0.0, 0.0)
    end
end

local function stash_house_coords(location)
    if location == 0 then return vec3:new(-156.345, 6292.5244, 30.6833)
    elseif location == 1 then return vec3:new(-1101.3784, 4940.878, 217.3541)
    elseif location == 2 then return vec3:new(2258.4717, 5165.8105, 58.1167)
    elseif location == 3 then return vec3:new(2881.7866, 4511.734, 46.9993)
    elseif location == 4 then return vec3:new(1335.4141, 4306.677, 37.0984)
    elseif location == 5 then return vec3:new(1857.9542, 3854.2195, 32.0891)
    elseif location == 6 then return vec3:new(905.7146, 3586.9836, 32.3914)
    elseif location == 7 then return vec3:new(2404.0786, 3127.706, 47.1533)
    elseif location == 8 then return vec3:new(550.6724, 2655.782, 41.223)
    elseif location == 9 then return vec3:new(-1100.8274, 2722.5867, 17.8004)
    elseif location == 10 then return vec3:new(-125.9821, 1896.2302, 196.3329)
    elseif location == 11 then return vec3:new(1546.2168, 2166.431, 77.7258)
    elseif location == 12 then return vec3:new(-3169.8516, 1034.2666, 19.8417)
    elseif location == 13 then return vec3:new(121.2199, 318.9121, 111.1516)
    elseif location == 14 then return vec3:new(-583.559, 195.3448, 70.4433)
    elseif location == 15 then return vec3:new(-1308.2467, -168.6344, 43.132)
    elseif location == 16 then return vec3:new(99.3476, -240.9664, 50.3995)
    elseif location == 17 then return vec3:new(1152.2288, -431.8629, 66.0115)
    elseif location == 18 then return vec3:new(-546.0123, -873.7389, 26.1988)
    elseif location == 19 then return vec3:new(-1293.3013, -1259.5853, 3.2025)
    elseif location == 20 then return vec3:new(161.7004, -1306.8784, 28.3547)
    elseif location == 21 then return vec3:new(979.653, -1981.9202, 29.6675)
    elseif location == 22 then return vec3:new(1124.7676, -1010.5512, 43.6728)
    elseif location == 23 then return vec3:new(167.95, -2222.4854, 6.2361)
    elseif location == 24 then return vec3:new(-559.2866, -1803.9038, 21.6104)
    else return vec3:new(0.0, 0.0, 0.0)
    end
end

local function street_dealer_coords(location)
    if location == 0 then return vec3:new(550.8953, -1774.5175, 28.3121)
    elseif location == 1 then return vec3:new(-154.924, 6434.428, 30.916)
    elseif location == 2 then return vec3:new(400.9768, 2635.3691, 43.5045)
    elseif location == 3 then return vec3:new(1533.846, 3796.837, 33.456)
    elseif location == 4 then return vec3:new(-1666.642, -1080.0201, 12.1537)
    elseif location == 5 then return vec3:new(-1560.6105, -413.3221, 37.1001)
    elseif location == 6 then return vec3:new(819.2939, -2988.8562, 5.0209)
    elseif location == 7 then return vec3:new(1001.701, -2162.448, 29.567)
    elseif location == 8 then return vec3:new(1388.9678, -1506.0815, 57.0407)
    elseif location == 9 then return vec3:new(-3054.574, 556.711, 0.661)
    elseif location == 10 then return vec3:new(-72.8903, 80.717, 70.6161)
    elseif location == 11 then return vec3:new(198.6676, -167.0663, 55.3187)
    elseif location == 12 then return vec3:new(814.636, -280.109, 65.463)
    elseif location == 13 then return vec3:new(-237.004, -256.513, 38.122)
    elseif location == 14 then return vec3:new(-493.654, -720.734, 22.921)
    elseif location == 15 then return vec3:new(156.1586, 6656.525, 30.5882)
    elseif location == 16 then return vec3:new(1986.3129, 3786.75, 31.2791)
    elseif location == 17 then return vec3:new(-685.5629, 5762.8706, 16.511)
    elseif location == 18 then return vec3:new(1707.703, 4924.311, 41.078)
    elseif location == 19 then return vec3:new(1195.3047, 2630.4685, 36.81)
    elseif location == 20 then return vec3:new(167.0163, 2228.922, 89.7867)
    elseif location == 21 then return vec3:new(2724.0076, 1483.066, 23.5007)
    elseif location == 22 then return vec3:new(1594.9329, 6452.817, 24.3172)
    elseif location == 23 then return vec3:new(-2177.397, 4275.945, 48.12)
    elseif location == 24 then return vec3:new(-2521.249, 2311.794, 32.216)
    elseif location == 25 then return vec3:new(-3162.873, 1115.6418, 19.8526)
    elseif location == 26 then return vec3:new(-1145.026, -2048.466, 12.218)
    elseif location == 27 then return vec3:new(-1304.321, -1318.848, 3.88)
    elseif location == 28 then return vec3:new(-946.727, 322.081, 70.357)
    elseif location == 29 then return vec3:new(-895.112, -776.624, 14.91)
    elseif location == 30 then return vec3:new(-250.614, -1527.617, 30.561)
    elseif location == 31 then return vec3:new(-601.639, -1026.49, 21.55)
    elseif location == 32 then return vec3:new(2712.9868, 4324.1157, 44.8521)
    elseif location == 33 then return vec3:new(726.772, 4169.101, 39.709)
    elseif location == 34 then return vec3:new(178.3272, 3086.2603, 42.0742)
    elseif location == 35 then return vec3:new(2351.592, 2524.249, 46.694)
    elseif location == 36 then return vec3:new(388.9941, 799.6882, 186.6764)
    elseif location == 37 then return vec3:new(2587.9822, 433.6803, 107.6139)
    elseif location == 38 then return vec3:new(830.2875, -1052.7747, 27.6666)
    elseif location == 39 then return vec3:new(-759.662, -208.396, 36.271)
    elseif location == 40 then return vec3:new(-43.7171, -2015.22, 17.017)
    elseif location == 41 then return vec3:new(124.02, -1039.884, 28.213)
    elseif location == 42 then return vec3:new(479.0473, -597.5507, 27.4996)
    elseif location == 43 then return vec3:new(959.67, 3619.036, 31.668)
    elseif location == 44 then return vec3:new(2375.8994, 3162.9954, 47.2087)
    elseif location == 45 then return vec3:new(-1505.687, 1526.558, 114.257)
    elseif location == 46 then return vec3:new(645.737, 242.173, 101.153)
    elseif location == 47 then return vec3:new(1173.1378, -388.2896, 70.5896)
    elseif location == 48 then return vec3:new(-1801.85, 172.49, 67.771)
    elseif location == 49 then return vec3:new(3729.2568, 4524.872, 21.4755)
    else return vec3:new(0.0, 0.0, 0.0)
    end
end

local function shipwrecked_coords(location)
    if location == 0 then return vec3:new(-389.978, -2215.861, 0.565)
    elseif location == 1 then return vec3:new(-872.646, -3121.243, 2.533)
    elseif location == 2 then return vec3:new(-1969.555, -3073.933, 1.899)
    elseif location == 3 then return vec3:new(-1227.362, -1862.997, 1.071)
    elseif location == 4 then return vec3:new(-1684.489, -1077.488, 0.464)
    elseif location == 5 then return vec3:new(-2219.716, -438.266, 0.828)
    elseif location == 6 then return vec3:new(-3099.804, 494.968, 0.134)
    elseif location == 7 then return vec3:new(-3226.636, 1337.312, 0.634)
    elseif location == 8 then return vec3:new(-2879.233, 2247.547, 0.878)
    elseif location == 9 then return vec3:new(-1767.392, 2642.144, 0.089)
    elseif location == 10 then return vec3:new(-180.913, 3081.589, 19.814)
    elseif location == 11 then return vec3:new(-2198.02, 4606.557, 1.402)
    elseif location == 12 then return vec3:new(-1356.295, 5379.136, 0.351)
    elseif location == 13 then return vec3:new(-844.701, 6045.489, 1.201)
    elseif location == 14 then return vec3:new(126.747, 7095.39, 0.484)
    elseif location == 15 then return vec3:new(473.135, 6741.893, -0.009)
    elseif location == 16 then return vec3:new(1469.845, 6629.33, -0.152)
    elseif location == 17 then return vec3:new(2356.588, 6663.491, -0.172)
    elseif location == 18 then return vec3:new(3380.806, 5670.246, 0.898)
    elseif location == 19 then return vec3:new(3198.166, 5091.909, 0.464)
    elseif location == 20 then return vec3:new(3947.421, 4403.337, 0.275)
    elseif location == 21 then return vec3:new(3901.5327, 3323.1387, 0.5902)
    elseif location == 22 then return vec3:new(3646.8667, 3120.687, 0.4864)
    elseif location == 23 then return vec3:new(2891.847, 1790.7085, 1.4015)
    elseif location == 24 then return vec3:new(2779.8674, 1106.5143, -0.0319)
    elseif location == 25 then return vec3:new(2783.5151, 82.6473, -0.0161)
    elseif location == 26 then return vec3:new(2820.225, -759.2029, 1.4572)
    elseif location == 27 then return vec3:new(2772.996, -1606.0311, -0.1129)
    elseif location == 28 then return vec3:new(1818.4303, -2718.4414, 0.1797)
    elseif location == 29 then return vec3:new(987.383, -2681.047, -0.1296)
    else return vec3:new(0.0, 0.0, 0.0)
    end
end

local function hidden_cache_coords(location)
    if location == 0 then return vec3:new(-150.585, -2852.332, -17.97)
    elseif location == 1 then return vec3:new(-540.975, -2465.579, -18.201)
    elseif location == 2 then return vec3:new(15.332, -2323.989, -14.224)
    elseif location == 3 then return vec3:new(461.483, -2386.212, -10.055)
    elseif location == 4 then return vec3:new(839.554, -2782.746, -20.516)
    elseif location == 5 then return vec3:new(1309.934, -2985.761, -21.344)
    elseif location == 6 then return vec3:new(1394.588, -3371.972, -17.855)
    elseif location == 7 then return vec3:new(1067.032, -3610.489, -52.777)
    elseif location == 8 then return vec3:new(371.111, -3226.341, -19.88)
    elseif location == 9 then return vec3:new(-1365.19, -3701.575, -32.056)
    elseif location == 10 then return vec3:new(-1983.722, -2769.391, -22.868)
    elseif location == 11 then return vec3:new(-1295.859, -1948.583, -7.47)
    elseif location == 12 then return vec3:new(-1791.493, -1284.341, -16.36)
    elseif location == 13 then return vec3:new(-1879.817, -1111.846, -19.249)
    elseif location == 14 then return vec3:new(-2086.537, -862.681, -37.465)
    elseif location == 15 then return vec3:new(-2614.496, -636.549, -35.296)
    elseif location == 16 then return vec3:new(-2815.156, -585.703, -59.753)
    elseif location == 17 then return vec3:new(-3412.1304, 165.8565, -32.6174)
    elseif location == 18 then return vec3:new(-3554.145, 817.679, -28.592)
    elseif location == 19 then return vec3:new(-3440.336, 1416.229, -33.629)
    elseif location == 20 then return vec3:new(-3295.557, 2020.828, -20.276)
    elseif location == 21 then return vec3:new(-3020.068, 2527.044, -22.628)
    elseif location == 22 then return vec3:new(-3183.344, 3051.828, -39.251)
    elseif location == 23 then return vec3:new(-3270.3245, 3670.6917, -26.5299)
    elseif location == 24 then return vec3:new(-2860.754, 3912.275, -33.684)
    elseif location == 25 then return vec3:new(-2752.189, 4572.626, -21.415)
    elseif location == 26 then return vec3:new(-2407.659, 4898.846, -45.411)
    elseif location == 27 then return vec3:new(-1408.649, 5734.096, -36.339)
    elseif location == 28 then return vec3:new(-1008.661, 6531.678, -22.122)
    elseif location == 29 then return vec3:new(-811.495, 6667.619, -14.098)
    elseif location == 30 then return vec3:new(-420.119, 7224.093, -44.899)
    elseif location == 31 then return vec3:new(425.78, 7385.154, -44.087)
    elseif location == 32 then return vec3:new(556.131, 7158.932, -38.031)
    elseif location == 33 then return vec3:new(1441.456, 6828.521, -44.977)
    elseif location == 34 then return vec3:new(1820.262, 7017.078, -78.959)
    elseif location == 35 then return vec3:new(2396.039, 6939.861, -104.858)
    elseif location == 36 then return vec3:new(2475.159, 6704.704, -9.333)
    elseif location == 37 then return vec3:new(2696.607, 6655.181, -21.513)
    elseif location == 38 then return vec3:new(3049.285, 6549.182, -36.306)
    elseif location == 39 then return vec3:new(3411.339, 6308.514, -52.545)
    elseif location == 40 then return vec3:new(3770.457, 5838.503, -27.88)
    elseif location == 41 then return vec3:new(3625.00, 5543.203, -26.645)
    elseif location == 42 then return vec3:new(3986.087, 3867.625, -31.705)
    elseif location == 43 then return vec3:new(3846.006, 3683.454, -17.227)
    elseif location == 44 then return vec3:new(4130.328, 3530.792, -27.516)
    elseif location == 45 then return vec3:new(3897.776, 3050.804, -19.277)
    elseif location == 46 then return vec3:new(3751.005, 2672.416, -48.526)
    elseif location == 47 then return vec3:new(3559.241, 2070.137, -38.01)
    elseif location == 48 then return vec3:new(3410.804, 1225.255, -55.684)
    elseif location == 49 then return vec3:new(3373.351, 323.788, -20.246)
    elseif location == 50 then return vec3:new(3152.983, -261.257, -8.355)
    elseif location == 51 then return vec3:new(3192.368, -367.909, -30.311)
    elseif location == 52 then return vec3:new(3178.722, -988.684, -25.133)
    elseif location == 53 then return vec3:new(2701.915, -1365.816, -13.163)
    elseif location == 54 then return vec3:new(3045.378, -1682.987, -31.797)
    elseif location == 55 then return vec3:new(2952.829, -2313.142, -94.421)
    elseif location == 56 then return vec3:new(2361.167, -2728.077, -67.131)
    elseif location == 57 then return vec3:new(1824.039, -2973.19, -41.865)
    elseif location == 58 then return vec3:new(-575.734, -3132.886, -21.879)
    elseif location == 59 then return vec3:new(-1872.968, -2087.878, -61.897)
    elseif location == 60 then return vec3:new(-3205.486, -144.9, -31.784)
    elseif location == 61 then return vec3:new(-1760.539, 5721.301, -74.808)
    elseif location == 62 then return vec3:new(-1293.948, 5886.757, -27.186)
    elseif location == 63 then return vec3:new(-6.032, 7464.313, -12.313)
    elseif location == 64 then return vec3:new(3627.174, 5286.089, -35.437)
    elseif location == 65 then return vec3:new(3978.554, 4987.259, -69.702)
    elseif location == 66 then return vec3:new(3995.491, 4858.986, -37.555)
    elseif location == 67 then return vec3:new(4218.075, 4116.594, -29.013)
    elseif location == 68 then return vec3:new(3795.855, 2327.765, -37.352)
    elseif location == 69 then return vec3:new(3247.753, 1395.029, -50.268)
    elseif location == 70 then return vec3:new(3451.907, 278.014, -99.633)
    elseif location == 71 then return vec3:new(1061.475, 7157.525, -28.239)
    elseif location == 72 then return vec3:new(-1551.109, 5558.511, -22.472)
    elseif location == 73 then return vec3:new(-29.194, -3484.225, -34.377)
    elseif location == 74 then return vec3:new(2981.125, 843.773, -4.586)
    elseif location == 75 then return vec3:new(2446.59, -2413.441, -35.135)
    elseif location == 76 then return vec3:new(423.342, -2864.345, -16.944)
    elseif location == 77 then return vec3:new(668.404, -3173.142, -6.337)
    elseif location == 78 then return vec3:new(-2318.251, 4976.115, -101.11)
    elseif location == 79 then return vec3:new(806.924, 6846.94, -3.666)
    elseif location == 80 then return vec3:new(4404.907, 4617.076, -20.163)
    elseif location == 81 then return vec3:new(3276.699, 1648.139, -44.099)
    elseif location == 82 then return vec3:new(2979.325, 1.033, -16.746)
    elseif location == 83 then return vec3:new(-838.069, -1436.609, -10.248)
    elseif location == 84 then return vec3:new(-3334.358, 3276.015, -27.291)
    elseif location == 85 then return vec3:new(-808.456, 6165.307, -3.398)
    elseif location == 86 then return vec3:new(-397.854, 6783.974, -19.076)
    elseif location == 87 then return vec3:new(95.133, 3898.854, 24.086)
    elseif location == 88 then return vec3:new(660.099, 3760.461, 19.43)
    elseif location == 89 then return vec3:new(2241.487, 4022.88, 25.675)
    elseif location == 90 then return vec3:new(1553.867, 4321.805, 19.761)
    elseif location == 91 then return vec3:new(857.875, 3958.953, 6.001)
    elseif location == 92 then return vec3:new(3431.468, 717.226, -93.674)
    elseif location == 93 then return vec3:new(-1634.57, -1741.677, -34.462)
    elseif location == 94 then return vec3:new(-3378.466, 503.853, -27.274)
    elseif location == 95 then return vec3:new(-1732.212, 5336.15, -7.72)
    elseif location == 96 then return vec3:new(-2612.415, 4266.765, -30.535)
    elseif location == 97 then return vec3:new(3406.32, -584.198, -18.545)
    elseif location == 98 then return vec3:new(-3106.876, 2432.615, -23.172)
    elseif location == 99 then return vec3:new(-2172.952, -3199.194, -33.315)
    else return vec3:new(0.0, 0.0, 0.0)
    end
end

local function junk_skydive_coords(location)
    if location == 0 then return vec3:new(-121.199, -962.557, 26.524)
    elseif location == 1 then return vec3:new(153.572, -721.103, 46.328)
    elseif location == 2 then return vec3:new(-812.47, 299.77, 85.407)
    elseif location == 3 then return vec3:new(-1223.345, 3856.44, 488.126)
    elseif location == 4 then return vec3:new(426.341, 5612.683, 765.588)
    elseif location == 5 then return vec3:new(503.8174, 5506.424, 773.6786)
    elseif location == 6 then return vec3:new(813.5065, 5720.6187, 693.7969)
    elseif location == 7 then return vec3:new(-860.4413, 4729.499, 275.6516)
    elseif location == 8 then return vec3:new(1717.6476, 3295.5166, 40.4591)
    elseif location == 9 then return vec3:new(2033.4845, 4733.43, 40.8773)
    elseif location == 10 then return vec3:new(-1167.212, -2494.621, 12.956)
    elseif location == 11 then return vec3:new(2790.4, 1465.635, 23.518)
    elseif location == 12 then return vec3:new(-782.166, -1452.285, 4.013)
    elseif location == 13 then return vec3:new(-559.43, -909.031, 22.863)
    elseif location == 14 then return vec3:new(-136.551, 6356.967, 30.492)
    elseif location == 15 then return vec3:new(742.95, 2535.935, 72.156)
    elseif location == 16 then return vec3:new(-2952.79, 441.363, 14.251)
    elseif location == 17 then return vec3:new(-1522.113, 1491.642, 110.595)
    elseif location == 18 then return vec3:new(261.555, -209.291, 60.566)
    elseif location == 19 then return vec3:new(739.4191, -1223.1754, 23.7705)
    elseif location == 20 then return vec3:new(-1724.4279, -1129.78, 12.0438)
    elseif location == 21 then return vec3:new(735.9623, 1303.1774, 359.293)
    elseif location == 22 then return vec3:new(2555.3403, 301.0995, 107.4623)
    elseif location == 23 then return vec3:new(-1143.5713, 2683.302, 17.0937)
    elseif location == 24 then return vec3:new(-917.5775, -1155.1293, 3.7723)
    else return vec3:new(0.0, 0.0, 0.0)
    end
end

local function treasure_chest_coords(location)
    if location == 0 then return vec3:new(4877.7646, -4781.151, 1.1379)
    elseif location == 1 then return vec3:new(4535.187, -4703.817, 1.1286)
    elseif location == 2 then return vec3:new(3900.6318, -4704.9194, 3.4813)
    elseif location == 3 then return vec3:new(4823.4844, -4323.176, 4.6816)
    elseif location == 4 then return vec3:new(5175.097, -4678.9375, 1.4205)
    elseif location == 5 then return vec3:new(5590.9507, -5216.8467, 13.351)
    elseif location == 6 then return vec3:new(5457.7954, -5860.7734, 19.0936)
    elseif location == 7 then return vec3:new(4855.598, -5561.794, 26.5093)
    elseif location == 8 then return vec3:new(4854.77, -5162.7295, 1.4387)
    elseif location == 9 then return vec3:new(4178.2944, -4357.763, 1.5826)
    elseif location == 10 then return vec3:new(4942.0825, -5168.135, -3.575)
    elseif location == 11 then return vec3:new(4560.804, -4356.775, -7.888)
    elseif location == 12 then return vec3:new(5598.9644, -5604.2393, -6.0489)
    elseif location == 13 then return vec3:new(5264.7236, -4920.671, -2.8715)
    elseif location == 14 then return vec3:new(4944.2183, -4293.736, -6.6942)
    elseif location == 15 then return vec3:new(4560.804, -4356.775, -7.888)
    elseif location == 16 then return vec3:new(3983.0261, -4540.1865, -6.1264)
    elseif location == 17 then return vec3:new(4414.676, -4651.4575, -5.083)
    elseif location == 18 then return vec3:new(4540.07, -4774.899, -3.9321)
    elseif location == 19 then return vec3:new(4777.6006, -5394.6265, -5.0127)
    else return vec3:new(0.0, 0.0, 0.0)
    end
end

local function buried_stash_coords(location)
    if location == 0 then return vec3:new(5579.7026, -5231.42, 14.2512)
    elseif location == 1 then return vec3:new(5481.595, -5855.187, 19.128)
    elseif location == 2 then return vec3:new(5549.2407, -5747.577, 10.427)
    elseif location == 3 then return vec3:new(5295.542, -5587.4307, 61.3964)
    elseif location == 4 then return vec3:new(5136.9844, -5524.6675, 52.7719)
    elseif location == 5 then return vec3:new(4794.91, -5546.516, 21.4945)
    elseif location == 6 then return vec3:new(4895.3125, -5335.3433, 9.0204)
    elseif location == 7 then return vec3:new(4994.968, -5136.416, 1.476)
    elseif location == 8 then return vec3:new(5323.654, -5276.0596, 33.0353)
    elseif location == 9 then return vec3:new(5362.1177, -5170.0854, 28.035)
    elseif location == 10 then return vec3:new(5164.5522, -4706.8384, 1.1632)
    elseif location == 11 then return vec3:new(4888.6104, -4789.4756, 1.4911)
    elseif location == 12 then return vec3:new(4735.3096, -4687.2236, 1.2879)
    elseif location == 13 then return vec3:new(4887.2036, -4630.111, 13.149)
    elseif location == 14 then return vec3:new(4796.803, -4317.4175, 4.3515)
    elseif location == 15 then return vec3:new(4522.936, -4649.638, 10.037)
    elseif location == 16 then return vec3:new(4408.228, -4470.875, 3.3683)
    elseif location == 17 then return vec3:new(4348.7827, -4311.3193, 1.3335)
    elseif location == 18 then return vec3:new(4235.67, -4552.0557, 4.0738)
    elseif location == 19 then return vec3:new(3901.899, -4720.187, 3.4537)
    else return vec3:new(0.0, 0.0, 0.0)
    end
end

local function exotic_export_coords(location, part)
    if part then
    	if location == 0 then return vec3:new(-1297.199, 252.495, 61.813)
    	elseif location == 1 then return vec3:new(-1114.101, 479.205, 81.161)
    	elseif location == 2 then return vec3:new(-345.267, 662.299, 168.587)
    	elseif location == 3 then return vec3:new(-72.605, 902.579, 234.631)
    	elseif location == 4 then return vec3:new(-161.232, 274.911, 92.534)
    	elseif location == 5 then return vec3:new(-504.323, 424.21, 96.287)
    	elseif location == 6 then return vec3:new(-1451.916, 533.495, 118.177)
    	elseif location == 7 then return vec3:new(-1979.252, 586.078, 116.479)
    	elseif location == 8 then return vec3:new(-1405.117, 81.983, 52.099)
    	elseif location == 9 then return vec3:new(-1299.92, -228.464, 59.654)
    	elseif location == 10 then return vec3:new(-1409.08, -590.823, 29.317)
    	elseif location == 11 then return vec3:new(-1085.162, -476.529, 35.636)
    	elseif location == 12 then return vec3:new(-817.325, -1201.59, 5.935)
    	elseif location == 13 then return vec3:new(-1873.598, -343.933, 48.26)
    	elseif location == 14 then return vec3:new(-1334.625, -1008.972, 6.867)
    	elseif location == 15 then return vec3:new(-1043.008, -1010.464, 1.15)
    	elseif location == 16 then return vec3:new(-489.189, -596.899, 30.174)
    	elseif location == 17 then return vec3:new(-187.144, -175.854, 42.624)
    	elseif location == 18 then return vec3:new(871.548, -75.386, 77.764)
    	elseif location == 19 then return vec3:new(443.542, 253.197, 102.21)
    	elseif location == 20 then return vec3:new(185.595, -1016.005, 28.3)
    	elseif location == 21 then return vec3:new(110.261, -714.605, 32.133)
    	elseif location == 22 then return vec3:new(-220.102, -590.273, 33.264)
    	elseif location == 23 then return vec3:new(-74.575, -619.874, 35.173)
    	elseif location == 24 then return vec3:new(283.769, -342.644, 43.92)
    	elseif location == 25 then return vec3:new(-237.521, -2059.951, 26.62)
    	elseif location == 26 then return vec3:new(-1044.016, -2608.022, 19.775)
    	elseif location == 27 then return vec3:new(-801.566, -1313.922, 4.0)
    	elseif location == 28 then return vec3:new(-972.578, -1464.273, 4.013)
    	elseif location == 29 then return vec3:new(1309.942, -530.154, 70.312)
    	elseif location == 30 then return vec3:new(1566.097, -1683.172, 87.205)
    	elseif location == 31 then return vec3:new(339.481, 159.143, 102.146)
    	elseif location == 32 then return vec3:new(-2316.493, 280.86, 168.467)
    	elseif location == 33 then return vec3:new(-3036.574, 105.31, 10.593)
    	elseif location == 34 then return vec3:new(-3071.87, 658.171, 9.918)
    	elseif location == 35 then return vec3:new(-1534.826, 889.731, 180.803)
    	elseif location == 36 then return vec3:new(140.945, 6606.513, 30.845)
    	elseif location == 37 then return vec3:new(1362.672, 1178.352, 111.609)
    	elseif location == 38 then return vec3:new(1869.749, 2622.154, 44.672)
    	elseif location == 39 then return vec3:new(2673.478, 1678.569, 23.488)
    	elseif location == 40 then return vec3:new(2593.022, 364.349, 107.457)
    	elseif location == 41 then return vec3:new(-1886.248, 2016.572, 139.951)
    	elseif location == 42 then return vec3:new(2537.084, -390.048, 91.993)
    	elseif location == 43 then return vec3:new(3511.653, 3783.877, 28.925)
    	elseif location == 44 then return vec3:new(2002.724, 3769.429, 31.181)
    	elseif location == 45 then return vec3:new(-771.927, 5566.46, 32.486)
    	elseif location == 46 then return vec3:new(1697.817, 6414.365, 31.73)
    	elseif location == 47 then return vec3:new(386.663, 2640.138, 43.493)
    	elseif location == 48 then return vec3:new(231.935, 1162.313, 224.464)
    	elseif location == 49 then return vec3:new(1700.445, 4937.267, 41.078)
    	else return vec3:new(0.0, 0.0, 0.0)
    	end
    else
    	if location == 0 then return vec3:new(-582.454, -859.433, 25.034)
    	elseif location == 1 then return vec3:new(-604.458, -1218.292, 13.507)
    	elseif location == 2 then return vec3:new(-229.587, -1483.435, 30.352)
    	elseif location == 3 then return vec3:new(28.385, -1707.341, 28.298)
    	elseif location == 4 then return vec3:new(-22.296, -1851.577, 24.108)
    	elseif location == 5 then return vec3:new(321.798, -1948.141, 23.627)
    	elseif location == 6 then return vec3:new(455.602, -1695.263, 28.289)
    	elseif location == 7 then return vec3:new(934.148, -1812.944, 29.812)
    	elseif location == 8 then return vec3:new(1228.548, -1605.649, 50.736)
    	elseif location == 9 then return vec3:new(-329.7, -700.958, 31.912)
    	elseif location == 10 then return vec3:new(238.339, -35.01, 68.728)
    	elseif location == 11 then return vec3:new(393.61, -649.557, 27.5)
    	elseif location == 12 then return vec3:new(246.847, -1162.082, 28.16)
    	elseif location == 13 then return vec3:new(124.231, -1472.496, 28.142)
    	elseif location == 14 then return vec3:new(1136.156, -773.997, 56.632)
    	elseif location == 15 then return vec3:new(1156.682, -1474.145, 33.693)
    	elseif location == 16 then return vec3:new(1028.898, -2405.952, 28.494)
    	elseif location == 17 then return vec3:new(-936.334, -2692.07, 15.611)
    	elseif location == 18 then return vec3:new(-532.351, -2134.219, 4.992)
    	elseif location == 19 then return vec3:new(-1530.625, -993.47, 12.017)
    	elseif location == 20 then return vec3:new(-1528.444, -427.05, 34.447)
    	elseif location == 21 then return vec3:new(-1640.424, -202.879, 54.146)
    	elseif location == 22 then return vec3:new(-552.673, 309.154, 82.191)
    	elseif location == 23 then return vec3:new(642.042, 587.747, 127.911)
    	elseif location == 24 then return vec3:new(-1804.769, 804.137, 137.514)
    	elseif location == 25 then return vec3:new(839.097, 2202.196, 50.46)
    	elseif location == 26 then return vec3:new(756.539, 2525.957, 72.161)
    	elseif location == 27 then return vec3:new(1205.454, 2658.357, 36.824)
    	elseif location == 28 then return vec3:new(1991.707, 3078.063, 46.016)
    	elseif location == 29 then return vec3:new(1977.207, 3837.1, 30.997)
    	elseif location == 30 then return vec3:new(1350.173, 3601.249, 33.899)
    	elseif location == 31 then return vec3:new(1819.042, 4592.234, 35.316)
    	elseif location == 32 then return vec3:new(2905.354, 4419.682, 47.541)
    	elseif location == 33 then return vec3:new(-472.038, 6034.981, 30.341)
    	elseif location == 34 then return vec3:new(-165.839, 6454.25, 30.495)
    	elseif location == 35 then return vec3:new(-2221.144, 4232.757, 46.132)
    	elseif location == 36 then return vec3:new(-3138.864, 1086.83, 19.669)
    	elseif location == 37 then return vec3:new(1546.591, 3781.791, 33.06)
    	elseif location == 38 then return vec3:new(2717.772, 1391.725, 23.535)
    	elseif location == 39 then return vec3:new(-1144.001, 2666.28, 17.094)
    	elseif location == 40 then return vec3:new(-2555.512, 2322.827, 32.06)
    	elseif location == 41 then return vec3:new(-2340.763, 296.197, 168.467)
    	elseif location == 42 then return vec3:new(1122.086, 267.125, 79.856)
    	elseif location == 43 then return vec3:new(629.014, 196.173, 96.128)
    	elseif location == 44 then return vec3:new(1150.161, -991.569, 44.528)
    	elseif location == 45 then return vec3:new(244.916, -860.606, 28.5)
    	elseif location == 46 then return vec3:new(-340.099, -876.452, 30.071)
    	elseif location == 47 then return vec3:new(387.275, -215.651, 55.835)
    	elseif location == 48 then return vec3:new(-1234.105, -1646.832, 3.129)
    	elseif location == 49 then return vec3:new(-1062.018, -226.736, 37.155)
    	else vec3:new(0.0, 0.0, 0.0)
    	end
    end
end

local function standart_trial_coords(location)
    if location == 0 then return vec3:new(-1811.675, -1199.5421, 12.0174)
    elseif location == 1 then return vec3:new(-377.166, 1250.8182, 326.4899)
    elseif location == 2 then return vec3:new(-1253.2399, -380.457, 58.2873)
    elseif location == 3 then return vec3:new(2702.0369, 5145.717, 42.8568)
    elseif location == 4 then return vec3:new(1261.3533, -3278.38, 4.8335)
    elseif location == 5 then return vec3:new(-1554.3121, 2755.0088, 16.8004)
    elseif location == 6 then return vec3:new(637.1439, -1845.8552, 8.2676)
    elseif location == 7 then return vec3:new(-552.626, 5042.7026, 127.9448)
    elseif location == 8 then return vec3:new(-579.1157, 5324.664, 69.2662)
    elseif location == 9 then return vec3:new(1067.343, -2448.2366, 28.0683)
    elseif location == 10 then return vec3:new(1577.189, 6439.966, 23.6996)
    elseif location == 11 then return vec3:new(-199.7486, -1973.3108, 26.6204)
    elseif location == 12 then return vec3:new(-1504.541, 1482.4895, 116.053)
    elseif location == 13 then return vec3:new(-1502.0471, 4940.611, 63.8034)
    elseif location == 14 then return vec3:new(947.562, 142.6773, 79.8307)
    elseif location == 15 then return vec3:new(1246.2249, 2685.1099, 36.5944)
    elseif location == 16 then return vec3:new(-1021.1459, -2580.291, 33.6353)
    elseif location == 17 then return vec3:new(231.9767, 3301.4888, 39.5627)
    elseif location == 18 then return vec3:new(860.353, 536.8055, 124.7803)
    elseif location == 19 then return vec3:new(2820.6514, 1642.2759, 23.668)
    elseif location == 20 then return vec3:new(-2257.7986, 4315.927, 44.5551)
    elseif location == 21 then return vec3:new(526.397, 5624.461, 779.3564)
    elseif location == 22 then return vec3:new(175.2847, -3042.0754, 4.7734)
    elseif location == 23 then return vec3:new(813.3556, 1274.9536, 359.511)
    elseif location == 24 then return vec3:new(77.5248, 3629.9146, 38.6907)
    elseif location == 25 then return vec3:new(1004.6567, 898.837, 209.0257)
    elseif location == 26 then return vec3:new(104.8058, -1938.9818, 19.8037)
    elseif location == 27 then return vec3:new(-985.2776, -2698.696, 12.8307)
    elseif location == 28 then return vec3:new(230.6618, -1399.0258, 29.4856)
    elseif location == 29 then return vec3:new(-546.6672, -2857.9282, 5.0004)
    elseif location == 30 then return vec3:new(-172.8944, 1034.8262, 231.2332)
    elseif location == 31 then return vec3:new(1691.4703, -1458.6351, 111.7033)
    else return vec3:new(0.0, 0.0, 0.0)
    end
end

local function rc_trial_coords(location)
    if location == 0 then return vec3:new(-486.1165, -916.59, 22.964)
    elseif location == 1 then return vec3:new(854.8221, -2189.789, 29.679604)
    elseif location == 2 then return vec3:new(-1730.7411, -188.57533, 57.337273)
    elseif location == 3 then return vec3:new(1409.3899, 1084.5609, 113.33391)
    elseif location == 4 then return vec3:new(-901.63, -779.377, 14.859)
    elseif location == 5 then return vec3:new(2562.03, 2707.7473, 41.071)
    elseif location == 6 then return vec3:new(-1194.2417, -1456.5526, 3.379667)
    elseif location == 7 then return vec3:new(-216.2158, -1109.7155, 21.9008)
    elseif location == 8 then return vec3:new(-889.356, -1071.848, 1.163)
    elseif location == 9 then return vec3:new(885.3417, -255.1916, 68.4006)
    elseif location == 10 then return vec3:new(-948.3436, -491.1428, 35.8333)
    elseif location == 11 then return vec3:new(750.3155, 597.0025, 124.9241)
    elseif location == 12 then return vec3:new(-402.4602, -1701.4429, 17.8213)
    elseif location == 13 then return vec3:new(-601.3092, 5295.396, 69.2145)
    else return vec3:new(0.0, 0.0, 0.0)
    end
end

local function bike_trial_coords(location)
    if location == 0 then return vec3:new(501.6576, 5598.3604, 795.1221)
    elseif location == 1 then return vec3:new(493.7987, 5528.249, 777.3241)
    elseif location == 2 then return vec3:new(2820.5623, 5972.031, 349.5339)
    elseif location == 3 then return vec3:new(-1031.3934, 4721.9556, 235.3456)
    elseif location == 4 then return vec3:new(-1932.808, 1782.2681, 172.2726)
    elseif location == 5 then return vec3:new(-182.0154, 319.3242, 96.7999)
    elseif location == 6 then return vec3:new(1100.4553, -264.2758, 68.268)
    elseif location == 7 then return vec3:new(736.0028, 2574.1477, 74.2793)
    elseif location == 8 then return vec3:new(1746.0431, -1474.762, 111.8385)
    elseif location == 9 then return vec3:new(30.5142, 197.473, 104.6073)
    elseif location == 10 then return vec3:new(145.0902, -605.9424, 46.0762)
    elseif location == 11 then return vec3:new(-447.3499, 1600.9911, 357.3483)
    elseif location == 12 then return vec3:new(-2205.15, 199.7418, 173.6018)
    elseif location == 13 then return vec3:new(1321.0515, -505.2507, 70.4208)
    else return vec3:new(0.0, 0.0, 0.0)
    end
end

script.register_looped("Daily Collectibles", function()
    daily_obj[1]                = globals.get_int(2359296 + (1 + (0 * 5569)) + 681 + 4243 + (1 + (0 * 3)))
    daily_obj[2]                = globals.get_int(2359296 + (1 + (0 * 5569)) + 681 + 4243 + (1 + (1 * 3)))
    daily_obj[3]                = globals.get_int(2359296 + (1 + (0 * 5569)) + 681 + 4243 + (1 + (2 * 3)))
    street_dealer_loc[1]        = globals.get_int(2738587 + 6776 + 1 + (0 * 11))
    street_dealer_loc[2]        = globals.get_int(2738587 + 6776 + 1 + (1 * 11))
    street_dealer_loc[3]        = globals.get_int(2738587 + 6776 + 1 + (2 * 11))
    meth_unit[1]                = globals.get_int(2738587 + 6776 + 1 + (0 * 11) + 3) -- MPX_STREET_DEALER_0_METH_PRICE
    meth_unit[2]                = globals.get_int(2738587 + 6776 + 1 + (1 * 11) + 3) -- MPX_STREET_DEALER_1_METH_PRICE
    meth_unit[3]                = globals.get_int(2738587 + 6776 + 1 + (2 * 11) + 3) -- MPX_STREET_DEALER_2_METH_PRICE
    weed_unit[1]                = globals.get_int(2738587 + 6776 + 1 + (0 * 11) + 4) -- MPX_STREET_DEALER_0_WEED_PRICE
    weed_unit[2]                = globals.get_int(2738587 + 6776 + 1 + (1 * 11) + 4) -- MPX_STREET_DEALER_1_WEED_PRICE
    weed_unit[3]                = globals.get_int(2738587 + 6776 + 1 + (2 * 11) + 4) -- MPX_STREET_DEALER_2_WEED_PRICE
    cocaine_unit[1]             = globals.get_int(2738587 + 6776 + 1 + (0 * 11) + 2) -- MPX_STREET_DEALER_0_COKE_PRICE
    cocaine_unit[2]             = globals.get_int(2738587 + 6776 + 1 + (1 * 11) + 2) -- MPX_STREET_DEALER_1_COKE_PRICE
    cocaine_unit[3]             = globals.get_int(2738587 + 6776 + 1 + (2 * 11) + 2) -- MPX_STREET_DEALER_2_COKE_PRICE
    acid_unit[1]                = globals.get_int(2738587 + 6776 + 1 + (0 * 11) + 5) -- MPX_STREET_DEALER_0_ACID_PRICE
    acid_unit[2]                = globals.get_int(2738587 + 6776 + 1 + (1 * 11) + 5) -- MPX_STREET_DEALER_1_ACID_PRICE
    acid_unit[3]                = globals.get_int(2738587 + 6776 + 1 + (2 * 11) + 5) -- MPX_STREET_DEALER_2_ACID_PRICE
    vehicle_location            = globals.get_int(1882037 + 302 + 1)
    vehicle_index               = globals.get_int(1882037 + 302)
    vehicle_order               = (globals.get_int(1942466 + vehicle_index + 1) + 1)
    active_vehicle              = globals.get_uint(2738587 + 6860 + 3)
    exotic_order_cooldown       = globals.get_int(1948923 + 5839)
    time_trial_loc[2]           = locals.get_int("freemode", 14282)
    time_trial_loc[3]           = locals.get_int("freemode", 15076 + 3)
    shipwrecked_loc             = stats.get_int("MPX_DAILYCOLLECT_SHIPWRECKED0")
    hidden_cache_loc[1]         = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH0")
    hidden_cache_loc[2]         = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH1")
    hidden_cache_loc[3]         = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH2")
    hidden_cache_loc[4]         = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH3")
    hidden_cache_loc[5]         = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH4")
    hidden_cache_loc[6]         = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH5")
    hidden_cache_loc[7]         = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH6")
    hidden_cache_loc[8]         = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH7")
    hidden_cache_loc[9]         = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH8")
    hidden_cache_loc[10]        = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH9")
    junk_skydive_loc[1]         = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES0")
    junk_skydive_loc[2]         = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES1")
    junk_skydive_loc[3]         = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES2")
    junk_skydive_loc[4]         = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES3")
    junk_skydive_loc[5]         = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES4")
    junk_skydive_loc[6]         = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES5")
    junk_skydive_loc[7]         = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES6")
    junk_skydive_loc[8]         = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES7")
    junk_skydive_loc[9]         = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES8")
    junk_skydive_loc[10]        = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES9")
    treasure_chest_loc[1]       = stats.get_int("MPX_DAILYCOLLECTABLES_TREASURE0")
    treasure_chest_loc[2]       = stats.get_int("MPX_DAILYCOLLECTABLES_TREASURE1")
    buried_stash_loc[1]         = stats.get_int("MPX_DAILYCOLLECT_BURIEDSTASH0")
    buried_stash_loc[2]         = stats.get_int("MPX_DAILYCOLLECT_BURIEDSTASH1")
    vehicle_bitset              = stats.get_int("MPX_CBV_DELIVERED_BS")
    dead_drop_area              = stats.get_packed_stat_int(41214)
    dead_drop_loc               = stats.get_packed_stat_int(41213)
    stash_house_loc             = stats.get_packed_stat_int(36623)
    dead_drop_collected         = stats.get_packed_stat_bool(36628)
    stash_house_raided          = stats.get_packed_stat_bool(36657)
    shipwrecked_collected       = stats.get_packed_stat_bool(31734)
    hidden_cache_collected[1]   = stats.get_packed_stat_bool(30297)
    hidden_cache_collected[2]   = stats.get_packed_stat_bool(30298)
    hidden_cache_collected[3]   = stats.get_packed_stat_bool(30299)
    hidden_cache_collected[4]   = stats.get_packed_stat_bool(30300)
    hidden_cache_collected[5]   = stats.get_packed_stat_bool(30301)
    hidden_cache_collected[6]   = stats.get_packed_stat_bool(30302)
    hidden_cache_collected[7]   = stats.get_packed_stat_bool(30303)
    hidden_cache_collected[8]   = stats.get_packed_stat_bool(30304)
    hidden_cache_collected[9]   = stats.get_packed_stat_bool(30305)
    hidden_cache_collected[10]  = stats.get_packed_stat_bool(30306)
    treasure_chest_collected[1] = stats.get_packed_stat_bool(30307)
    treasure_chest_collected[2] = stats.get_packed_stat_bool(30308)
    buried_stash_collected[1]   = stats.get_packed_stat_bool(25522)
    buried_stash_collected[2]   = stats.get_packed_stat_bool(25523)
    weekly_obj_id               = tunables.get_int("MP_WEEKLY_OBJECTIVE_ID_OVERRIDE")
    weekly_obj_override         = tunables.get_int("MP_WEEKLY_OBJECTIVE_COUNT_OVERRIDE")
    time_trial_loc[1]           = tunables.get_int("TIMETRIALVARIATION")
    max_cocaine                 = tunables.get_int(1238316723)
    max_meth                    = tunables.get_int(658190943)
    max_weed                    = tunables.get_int(803541362)
    max_acid                    = tunables.get_int(-1171794142)
    safe_code                   = get_safe_code()
    exotic_reward_ready         = MISC.ABSI(NETWORK.GET_TIME_DIFFERENCE(NETWORK.GET_NETWORK_TIME(), exotic_order_cooldown)) >= 30000
    total_products              = (max_cocaine * cocaine_unit[selected_dealer + 1] + max_meth * meth_unit[selected_dealer + 1] + max_weed * weed_unit[selected_dealer + 1] + max_acid * acid_unit[selected_dealer + 1])
    all_products                = (max_cocaine * cocaine_unit[1] + max_meth * meth_unit[1] + max_weed * weed_unit[1] + max_acid * acid_unit[1] + max_cocaine * cocaine_unit[2] + max_meth * meth_unit[2] + max_weed * weed_unit[2] + max_acid * acid_unit[2] + max_cocaine * cocaine_unit[3] + max_meth * meth_unit[3] + max_weed * weed_unit[3] + max_acid * acid_unit[3])
end)

daily_collectibles_tab:add_imgui(function()
    local hours, minutes, seconds    = get_daily_reset_time(5)
    local hours2, minutes2, seconds2 = get_daily_reset_time(6)
    
    ImGui.Text(string.format("Daily Reset Time (6 AM UTC): %02d:%02d:%02d", hours, minutes, seconds))
    ImGui.Text("- Daily Challenges")
    ImGui.Text("- Hidden Caches")
    ImGui.Text("- Treasure Chests")
    ImGui.Text("- Shipwreck")
    ImGui.Text("- Buried Stashes")
    ImGui.Text("- Junk Energy Skydives")
    
    ImGui.Separator()
    
    ImGui.Text(string.format("Daily Reset Time (7 AM UTC): %02d:%02d:%02d", hours2, minutes2, seconds2))
    ImGui.Text("- Weekly Challenge")
    ImGui.Text("- Exotic Exports")
    ImGui.Text("- Stash House")
    ImGui.Text("- Street Dealers")
    ImGui.Text("- RC Bandito Time Trial")
    ImGui.Text("- Junk Energy Bike Time Trial")
    ImGui.Text("- G's Cache")
end)

challenges_tab:add_imgui(function()
    if ImGui.TreeNode("Daily Challenges") then
    	ImGui.Text(daily_challenges[daily_obj[1] + 1])
    	ImGui.Text(daily_challenges[daily_obj[2] + 1])
    	ImGui.Text(daily_challenges[daily_obj[3] + 1])
    	ImGui.TreePop()
    end
    
    if ImGui.TreeNode("Weekly Challenge") then
    	ImGui.Text(weekly_challenges[weekly_obj_id + 1])
    	ImGui.Text("Override: " .. weekly_obj_override)
    	ImGui.SameLine()
    	help_marker("This means the amount in the challenge above is set to this value instead of the default.")
    	ImGui.TreePop()
    end
    
    if ImGui.Button("Complete all Challenges") then
        for i = 0, 2 do
            local objective = globals.get_int(2359296 + (1 + (0 * 5569)) + 681 + 4243 + (1 + (i * 3)))
            globals.set_int(1574743 + 1 + (1 + (i * 1)), objective)
        end
        globals.set_int(1574743, 1)
        globals.set_int(2737646 + (1 + (0 * 6)) + 1, globals.get_int(2737646 + (1 + (0 * 6)) + 2))
    end
end)

dead_drop_tab:add_imgui(function()
    ImGui.Text("Status: " .. (dead_drop_collected and "collected" or "ready"))
    
    if ImGui.Button("Teleport") then
    	if not dead_drop_collected then
    		teleport(dead_drop_coords(dead_drop_area, dead_drop_loc))
    	else
    		gui.show_message("Daily Collectibles", "G's Cache has already been collected.")
    	end
    end
end)

stash_house_tab:add_imgui(function()
    if not stash_house_raided then
    	ImGui.Text("Safe Code: " .. safe_code)
    end
    ImGui.Text("Status: " .. (stash_house_raided and "raided" or "ready"))
    
    if ImGui.Button("Teleport") then
    	if not stash_house_raided then
    		script.run_in_fiber(function (script)
    			if HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(845)) then
    				teleport(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(845)))
    			end
    		end)
    	else
    		gui.show_message("Daily Collectibles", "Stash House has already been raided.")
    	end
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("Enter Safe Combination") then
    	script.run_in_fiber(function (script)
    		for i = 0, 2, 1 do
    			local safe_combination = locals.get_int("fm_content_stash_house", 117 + 22 + (1 + (i * 2)) + 1)
    			locals.set_float("fm_content_stash_house", 117 + 22 + (1 + (i * 2)), safe_combination)
    		end
    	end)
    end
end)

street_dealer_tab:add_imgui(function()
    selected_dealer = ImGui.Combo("Select Dealer", selected_dealer, { "1", "2", "3" }, 3)
    
    if ImGui.Button("Teleport") then
    	teleport(street_dealer_coords(street_dealer_loc[selected_dealer + 1]))
    end
    
    ImGui.Text("Weed: $" .. format_int(max_weed * weed_unit[selected_dealer + 1]) .. " (" .. format_int(max_weed) .. " unit * " .. format_int(weed_unit[selected_dealer + 1]) .. ")")
    ImGui.Text("Meth: $" .. format_int(max_meth * meth_unit[selected_dealer + 1]) .. " (" .. format_int(max_meth) .. " unit * " .. format_int(meth_unit[selected_dealer + 1]) .. ")")
    ImGui.Text("Cocaine: $" .. format_int(max_cocaine * cocaine_unit[selected_dealer + 1]) .. " (" .. format_int(max_cocaine) .. " unit * " .. format_int(cocaine_unit[selected_dealer + 1]) .. ")")
    ImGui.Text("Acid: $" .. format_int(max_acid * acid_unit[selected_dealer + 1]) .. " (" .. format_int(max_acid) .. " unit * " .. format_int(acid_unit[selected_dealer + 1]) .. ")")
    ImGui.Text("Total: $" .. format_int(total_products))
    
    ImGui.Separator()
    
    ImGui.Text("All: $" .. format_int(all_products))
end)

shipwrecked_tab:add_imgui(function()
    ImGui.Text("Status: " .. (shipwrecked_collected and "collected" or "ready"))
    
    if ImGui.Button("Teleport") then
    	if not shipwrecked_collected then
    		teleport(shipwrecked_coords(shipwrecked_loc))
    	else
    		gui.show_message("Daily Collectibles", "Shipwreck has already been collected.")
    	end
    end
end)

hidden_cache_tab:add_imgui(function()
    ImGui.Text("Status: " .. (hidden_cache_collected[selected_cache + 1] and "collected" or "ready"))
    
    selected_cache = ImGui.Combo("Select Cache", selected_cache, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, 10)
    
    if ImGui.Button("Teleport") then
    	if not hidden_cache_collected[selected_cache + 1] then
    		teleport(hidden_cache_coords(hidden_cache_loc[selected_cache + 1]))
    	else
    		gui.show_message("Daily Collectibles", "Hidden Cache has already been collected.")
    	end
    end
end)

junk_skydive_tab:add_imgui(function()
    ImGui.Text("Challenge Time: " .. get_challenge_time(junk_skydive_loc[selected_skydive + 1]))
    
    selected_skydive = ImGui.Combo("Select Skydive", selected_skydive, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, 10)
    
    if ImGui.Button("Teleport") then
    	teleport(junk_skydive_coords(junk_skydive_loc[selected_skydive + 1]))
    end
end)

treasure_chest_tab:add_imgui(function()
    ImGui.Text("Status: " .. (treasure_chest_collected[selected_treasure + 1] and "collected" or "ready"))
    
    selected_treasure = ImGui.Combo("Select Treasure", selected_treasure, { "1", "2" }, 2)
    
    if ImGui.Button("Teleport") then
    	if not treasure_chest_collected[selected_treasure + 1] then
    		teleport(treasure_chest_coords(treasure_chest_loc[selected_treasure + 1]))
    	else
    		gui.show_message("Daily Collectibles", "Treasure Chest has already been collected.")
    	end
    end
end)

buried_stash_tab:add_imgui(function()
    ImGui.Text("Status: " .. (buried_stash_collected[selected_stash + 1] and "collected" or "ready"))
    
    selected_stash = ImGui.Combo("Select Stash", selected_stash, { "1", "2" }, 2)
    
    if ImGui.Button("Teleport") then
    	if not buried_stash_collected[selected_stash + 1] then
    		teleport(buried_stash_coords(buried_stash_loc[selected_stash + 1]))
    	else
    		gui.show_message("Daily Collectibles", "Buried Stash has already been collected.")
    	end
    end
end)

exotic_exports_tab:add_imgui(function()
    ImGui.Text("Reward Ready: " .. (exotic_reward_ready and "Yes" or "No"))
    
    if ImGui.Button("Teleport to Vehicle") then
    	if vehicle_bitset ~= 1023 then
    		if vehicle_location ~= -1 then
    			teleport(exotic_export_coords(vehicle_location, second_part(globals.get_uint(1942455 + vehicle_order))))
    		else
    			gui.show_message("Daily Collectibles", "Please wait until the next vehicle is spawned (90 seconds).")
    		end
    	else
    		gui.show_message("Daily Collectibles", "You have already delivered all the vehicles.")
    	end
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("Deliver Vehicle") then
    	if vehicle_bitset ~= 1023 then
    		if not exotic_reward_ready then
    			gui.show_message("Daily Collectibles", "You have just delivered a vehicle. Wait a moment.")
    		else
    			script.run_in_fiber(function()
    				if HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(780)) then
    					teleport(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(780)))
    				else
    					gui.show_message("Daily Collectibles", "Please get in an Exotic Exports Vehicle.")
    				end
    			end)
    		end
    	else
    		gui.show_message("Daily Collectibles", "You have already delivered all the vehicles.")
    	end
    end
    
    if ImGui.Button("Spawn Next Vehicle") then
    	if vehicle_bitset ~= 1023 then
    		for i = 1, 10 do
    			if not has_bit_set(vehicle_bitset, globals.get_int(1942466 + i)) then
    				spawn_vehicle(get_vehicle_name(i, true))
    				return
    			end
    		end
    	else
    		gui.show_message("Daily Collectibles", "You have already delivered all the vehicles.")
    	end
    end
    
    ImGui.Text("Today's List:")
    
    for i = 1, 10 do
    	if active_vehicle == get_vehicle_name(i, true) then
    		ImGui.Text(i .. " -")
    		ImGui.SameLine()
    		ImGui.TextColored(0.5, 0.5, 1, 1, get_vehicle_name(i, false) .. " (Active)")
    	else
    		if has_bit_set(vehicle_bitset, globals.get_int(1942466 + i)) then
    			ImGui.Text(i .. " -")
    			ImGui.SameLine()
    			ImGui.TextColored(0, 1, 0, 1, get_vehicle_name(i, false) .. " (Delivered)")
    		else
    			ImGui.Text(i .. " - " .. get_vehicle_name(i, false))
    		end
    	end
    end
end)

time_trials_tab:add_imgui(function()
	ImGui.Text("Par Time: " .. get_par_time(selected_trial, time_trial_loc[selected_trial + 1]))
	
	selected_trial = ImGui.Combo("Select Variant", selected_trial, { "Standart Time Trial", "RC Bandito Time Trial", "Junk Energy Bike Time Trial" }, 3)
	
	if ImGui.Button("Teleport##trials") then
		if selected_trial == 0 then teleport(standart_trial_coords(time_trial_loc[1]))
		elseif selected_trial == 1 then teleport(rc_trial_coords(time_trial_loc[2]))
		elseif selected_trial == 2 then teleport(bike_trial_coords(time_trial_loc[3]))
		end
	end
end)