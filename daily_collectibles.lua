local daily_collectibles_tab = gui.get_tab("Daily Collectibles")

local challenges_tab     = daily_collectibles_tab:add_tab("Challenges")
local hidden_cache_tab   = daily_collectibles_tab:add_tab("Hidden Caches")
local treasure_chest_tab = daily_collectibles_tab:add_tab("Treasure Chests")
local shipwrecked_tab    = daily_collectibles_tab:add_tab("Shipwreck")
local buried_stash_tab   = daily_collectibles_tab:add_tab("Buried Stashes")
local junk_skydive_tab   = daily_collectibles_tab:add_tab("Junk Energy Skydives")
local time_trials_tab    = daily_collectibles_tab:add_tab("Time Trials")
local exotic_exports_tab = daily_collectibles_tab:add_tab("Exotic Exports")
local dead_drop_tab      = daily_collectibles_tab:add_tab("G's Cache")
local stash_house_tab    = daily_collectibles_tab:add_tab("Stash House")
local street_dealer_tab  = daily_collectibles_tab:add_tab("Street Dealers")
local ls_tags_tab        = daily_collectibles_tab:add_tab("LS Tags")
local madrazo_hits_tab   = daily_collectibles_tab:add_tab("Madrazo Hits")

local GDCC = 0xBED3F
local GSDC = 0x5AAAFE

local global_one              = 1943205
local global_two              = 1943194
local global_three            = 2738934
local global_three_offset_one = 6813
local global_three_offset_two = 6898
local global_four             = 1882247
local global_five             = 1949771
local global_five_offset      = 5878

local freemode_local_one    = 14386
local freemode_local_two    = 14436
local freemode_local_three  = 15239
local stash_house_local_one = 3521
local stash_house_local_two = 119
local btt_local_one         = 119

local current_objectives_global        = 2359296
local current_objectives_global_offset = 5570
local weekly_objectives_global         = 2737992
local objectives_state_global          = 1574744

local selected_dealer    = 0
local selected_cache     = 0
local selected_skydive   = 0
local selected_treasure  = 0
local selected_stash     = 0
local selected_trial     = 0
local selected_tag       = 0

local weekly_obj_id            = 0
local weekly_obj_override      = 0
local max_cocaine              = 0
local max_meth                 = 0
local max_weed                 = 0
local max_acid                 = 0
local total_products           = 0
local all_products             = 0
local active_vehicle           = 0
local vehicle_bitset           = 0
local vehicle_coords           = vec3:new(0, 0, 0)
local dead_drop_collected      = false
local stash_house_raided       = false
local shipwrecked_collected    = false
local spray_can_collected      = false
local hit_completed            = false
local exotic_reward_ready      = false
local pause_timer              = false
local bail_office_owned        = false
local weekly_obj_str           = ""
local safe_code                = ""
local daily_obj                = {}
local daily_obj_str            = {}
local dealer_loc               = {}
local junk_skydive_loc         = {}
local trial_loc                = {}
local hidden_cache_collected   = {}
local treasure_chest_collected = {}
local buried_stash_collected   = {}
local trial_beaten             = {}
local ls_tag_sprayed           = {}
local meth_unit                = {}
local weed_unit                = {}
local cocaine_unit             = {}
local acid_unit                = {}

local COLLECTABLE_MOVIE_PROPS      = 0
local COLLECTABLE_HIDDEN_CACHES    = 1
local COLLECTABLE_TREASURE_CHESTS  = 2
local COLLECTABLE_RADIO_STATIONS   = 3
local COLLECTABLE_USB_PIRATE_RADIO = 4
local COLLECTABLE_SHIPWRECKED      = 5
local COLLECTABLE_BURIED_STASH     = 6
--local COLLECTABLE_METAL_DETECTOR = 7 unused (turned into random event)
local COLLECTABLE_TRICK_OR_TREAT   = 8
local COLLECTABLE_LD_ORGANICS      = 9
local COLLECTABLE_SKYDIVES         = 10
--local COLLECTABLE_SIGHTSEEING    = 11 unused (turned into random event)
--local COLLECTABLE_POLICE_BADGES  = 12 unused (CnC)
local COLLECTABLE_GUN_PARTS        = 13 -- (crime scene random event, remnant from CnC)
-- 14-15 unknown/doesn't exist
local COLLECTABLE_SNOWMEN          = 16
local COLLECTABLE_DEAD_DROP        = 17
-- 18 unknown/doesn't exist
local COLLECTABLE_TAGGING          = 19

-- if (COLLECTABLES_TREASURE_CHESTS && IS_PLAYER_ON_CAYO_SCOPE_PREP(PLAYER::PLAYER_ID()))
-- This patch replaces IAND with PUSH_CONST_1, so the result of IS_PLAYER_ON_CAYO_SCOPE_PREP is always considered true for this check.
-- The condition will still fail if COLLECTABLES_TREASURE_CHESTS tunable is false (it doesn't matter because this is the behaviour we want).
script.add_patch("freemode", "Bypass Treasure Chest CP Check", "5D A4 9C 22 1F", 4, { 0x72 })

-- This patch sets the value of bVar0 to true in the function used to check if buried stashes should spawn.
-- Rockstar uses this variable to skip Cayo Perico checks in their debug builds, so we do exactly what they do.
script.add_patch("freemode", "Bypass Buried Stash CP Check", "71 39 02 38 02 06 56 ? ? 2C", 0, { 0x72 })

local function format_int(number)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    return minus .. int:reverse():gsub("^,", "") .. fraction
end

local function get_daily_reset_time()
    local current_utc = os.date("!*t")
    local hours_left  = (24 - current_utc.hour + 5) % 24
    local mins_left   = 60 - current_utc.min
    local secs_left   = 60 - current_utc.sec
    return hours_left, mins_left, secs_left
end

local function teleport(coords)
    if (coords == nil or ((coords.x + coords.y + coords.z) == 0)) then -- Sanity check to make sure we don't send the user to the void if a function fails
        return
    end
    PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), coords.x, coords.y, coords.z)
end

local function has_bit_set(address, pos)
    return (address & (1 << pos)) ~= 0
end

local function get_collectable_coords(collectable_type, collectable_index)
    local coords = scr_function.call_script_function("freemode", GDCC, "vector3", {
        { "int", collectable_type },
        { "int", collectable_index }
    })
    return coords
end

local function set_collectable_collected(collectable_type, collectable_index)
    script.run_in_fiber(function()
        scr_function.call_script_function("freemode", "SCC", "2D 05 33 00 00", "void", {
            { "int", collectable_type },
            { "int", collectable_index },
            { "bool", true },  -- Set Collected
            { "bool", true },  -- Print Help Message
            { "bool", false }  -- Disable Trick or Treat Effects
        })
    end)
end

local function set_daily_collectable_state(state)
    script.run_in_fiber(function()
        stats.set_packed_stat_bool(36628, state) -- G's Cache
        stats.set_packed_stat_bool(36657, state) -- Stash House
        stats.set_packed_stat_bool(31734, state) -- Shipwreck
        stats.set_packed_stat_bool(30297, state) -- Hidden Cache 1
        stats.set_packed_stat_bool(30298, state) -- Hidden Cache 2
        stats.set_packed_stat_bool(30299, state) -- Hidden Cache 3
        stats.set_packed_stat_bool(30300, state) -- Hidden Cache 4
        stats.set_packed_stat_bool(30301, state) -- Hidden Cache 5
        stats.set_packed_stat_bool(30302, state) -- Hidden Cache 6
        stats.set_packed_stat_bool(30303, state) -- Hidden Cache 7
        stats.set_packed_stat_bool(30304, state) -- Hidden Cache 8
        stats.set_packed_stat_bool(30305, state) -- Hidden Cache 9
        stats.set_packed_stat_bool(30306, state) -- Hidden Cache 10
        stats.set_packed_stat_bool(30307, state) -- Treasure Chest 1
        stats.set_packed_stat_bool(30308, state) -- Treasure Chest 2
        stats.set_packed_stat_bool(25522, state) -- Buried Stash 1
        stats.set_packed_stat_bool(25523, state) -- Buried Stash 2
        stats.set_packed_stat_bool(42252, state) -- LS Tag 1
        stats.set_packed_stat_bool(42253, state) -- LS Tag 2
        stats.set_packed_stat_bool(42254, state) -- LS Tag 3
        stats.set_packed_stat_bool(42255, state) -- LS Tag 4
        stats.set_packed_stat_bool(42256, state) -- LS Tag 5
        stats.set_packed_stat_bool(42269, state) -- Madrazo Hit
        -- Next-gen exclusive, but the packed stats and the interaction menu functionality is available on PC
        stats.set_packed_stat_bool(42059, state) -- Shoot Animals Photography 1
        stats.set_packed_stat_bool(42060, state) -- Shoot Animals Photography 2
        stats.set_packed_stat_bool(42061, state) -- Shoot Animals Photography 3
        for skydive_index = 0, 9 do
            -- See the getter of script event 1916113629, another stupid R* thing
            stats.set_packed_stat_int((34837 + skydive_index * 4), state and junk_skydive_loc[skydive_index + 1] or -1) -- Junk Energy Skydives Checkpoint
            stats.set_packed_stat_int((34839 + skydive_index * 4), state and junk_skydive_loc[skydive_index + 1] or -1) -- Junk Energy Skydives Accurate Landing
            stats.set_packed_stat_int((34838 + skydive_index * 4), state and junk_skydive_loc[skydive_index + 1] or -1) -- Junk Energy Skydives Partime
            stats.set_packed_stat_int((34840 + skydive_index * 4), state and junk_skydive_loc[skydive_index + 1] or -1) -- Junk Energy Skydives Gold
        end
        for lantern_index = 34252, 34261 do
            stats.set_packed_stat_bool(lantern_index, state) -- Trick or Treat
        end
        for lantern_index = 34512, 34701 do
            stats.set_packed_stat_bool(lantern_index, state) -- Trick or Treat
        end
		stats.set_int("MPPLY_TIMETRIAL_COMPLETED_WEEK", state and trial_loc[1] or -1) -- Standard Time Trial
		stats.set_int("MPPLY_RCTTCOMPLETEDWEEK", state and trial_loc[2] or -1) -- RC Bandito Time Trial
		stats.set_int("MPPLY_BTTCOMPLETED", state and trial_loc[3] or -1) -- Junk Energy Bike Time Trial
        stats.set_int("MPX_CBV_DELIVERED_BS", state and 1023 or 0) -- Exotic Exports
        stats.set_int("MPX_CBV_STATE", state and 1 or 0) -- Exotic Exports
    end)
end

local function spawn_vehicle(vehicle_joaat)
    script.run_in_fiber(function(script)
        local load_counter = 0
        while not STREAMING.HAS_MODEL_LOADED(vehicle_joaat) do
            STREAMING.REQUEST_MODEL(vehicle_joaat)
            script:yield()
            if load_counter > 100 then
                return
            else
                load_counter = load_counter + 1
            end
        end
        local location = ENTITY.GET_ENTITY_COORDS(self.get_ped(), false)
        local veh = VEHICLE.CREATE_VEHICLE(vehicle_joaat, location.x, location.y, location.z, ENTITY.GET_ENTITY_HEADING(self.get_ped()), true, false, false)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(vehicle_joaat)
        DECORATOR.DECOR_SET_INT(veh, "MPBitset", 0)
        local network_id = NETWORK.VEH_TO_NET(veh)
        if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(veh) then
            NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(network_id, true)
        end
        VEHICLE.SET_VEHICLE_IS_STOLEN(veh, false)
        PED.SET_PED_INTO_VEHICLE(self.get_ped(), veh, -1)
        ENTITY.SET_ENTITY_AS_NO_LONGER_NEEDED(veh)
    end)
end

local function get_safe_code()
    if not script.is_active("fm_content_stash_house") then
        return "unavailable"
    else
        local safe_codes = {
            [0] = "05-02-91",
            [1] = "28-03-98",
            [2] = "24-10-81",
            [3] = "02-12-87",
            [4] = "01-23-45",
            [5] = "28-11-97",
            [6] = "77-79-73",
            [7] = "73-27-38",
            [8] = "44-23-37",
            [9] = "72-68-83"
        }
        local safe_code_index = locals.get_int("fm_content_stash_house", stash_house_local_one + 527 + 13)
        return safe_codes[safe_code_index]
    end
end

local function get_vehicle_name(index, return_joaat)
    local offset = globals.get_int(global_one + index) + 1
    local vehicle_joaat = globals.get_uint(global_two + offset)
    if return_joaat == true then
        return vehicle_joaat
    else
        return vehicles.get_vehicle_display_name(vehicle_joaat)
    end
end

script.register_looped("Daily Collectibles", function()
    daily_obj[1]                = globals.get_int(current_objectives_global + (1 + (0 * current_objectives_global_offset)) + 681 + 4244 + (1 + (0 * 3)))
    daily_obj[2]                = globals.get_int(current_objectives_global + (1 + (0 * current_objectives_global_offset)) + 681 + 4244 + (1 + (1 * 3)))
    daily_obj[3]                = globals.get_int(current_objectives_global + (1 + (0 * current_objectives_global_offset)) + 681 + 4244 + (1 + (2 * 3)))
    weekly_obj_id               = globals.get_int(weekly_objectives_global + (1 + (0 * 6)))
    weekly_obj_override         = globals.get_int(weekly_objectives_global + (1 + (0 * 6)) + 2)
    dealer_loc[1]               = globals.get_int(global_three + global_three_offset_one + 1 + (0 * 7))
    dealer_loc[2]               = globals.get_int(global_three + global_three_offset_one + 1 + (1 * 7))
    dealer_loc[3]               = globals.get_int(global_three + global_three_offset_one + 1 + (2 * 7))
    meth_unit[1]                = globals.get_int(global_three + global_three_offset_one + 1 + (0 * 7) + 3) -- MPX_STREET_DEALER_0_METH_PRICE
    meth_unit[2]                = globals.get_int(global_three + global_three_offset_one + 1 + (1 * 7) + 3) -- MPX_STREET_DEALER_1_METH_PRICE
    meth_unit[3]                = globals.get_int(global_three + global_three_offset_one + 1 + (2 * 7) + 3) -- MPX_STREET_DEALER_2_METH_PRICE
    weed_unit[1]                = globals.get_int(global_three + global_three_offset_one + 1 + (0 * 7) + 4) -- MPX_STREET_DEALER_0_WEED_PRICE
    weed_unit[2]                = globals.get_int(global_three + global_three_offset_one + 1 + (1 * 7) + 4) -- MPX_STREET_DEALER_1_WEED_PRICE
    weed_unit[3]                = globals.get_int(global_three + global_three_offset_one + 1 + (2 * 7) + 4) -- MPX_STREET_DEALER_2_WEED_PRICE
    cocaine_unit[1]             = globals.get_int(global_three + global_three_offset_one + 1 + (0 * 7) + 2) -- MPX_STREET_DEALER_0_COKE_PRICE
    cocaine_unit[2]             = globals.get_int(global_three + global_three_offset_one + 1 + (1 * 7) + 2) -- MPX_STREET_DEALER_1_COKE_PRICE
    cocaine_unit[3]             = globals.get_int(global_three + global_three_offset_one + 1 + (2 * 7) + 2) -- MPX_STREET_DEALER_2_COKE_PRICE
    acid_unit[1]                = globals.get_int(global_three + global_three_offset_one + 1 + (0 * 7) + 5) -- MPX_STREET_DEALER_0_ACID_PRICE
    acid_unit[2]                = globals.get_int(global_three + global_three_offset_one + 1 + (1 * 7) + 5) -- MPX_STREET_DEALER_1_ACID_PRICE
    acid_unit[3]                = globals.get_int(global_three + global_three_offset_one + 1 + (2 * 7) + 5) -- MPX_STREET_DEALER_2_ACID_PRICE
    active_vehicle              = globals.get_uint(global_three + global_three_offset_two + 3)
    exotic_order_cooldown       = globals.get_int(global_five + global_five_offset)
    vehicle_coords              = globals.get_vec3(global_four + 1 + (1 + (3 * 15)) + 10)
    trial_loc[1]                = locals.get_int("freemode", freemode_local_one + 11)
    trial_loc[2]                = locals.get_int("freemode", freemode_local_two)
    trial_loc[3]                = locals.get_int("freemode", freemode_local_three + 3)
    max_cocaine                 = tunables.get_int(1238316723)
    max_meth                    = tunables.get_int(658190943)
    max_weed                    = tunables.get_int(803541362)
    max_acid                    = tunables.get_int(-1171794142)	
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
    trial_beaten[1]             = stats.get_int("MPPLY_TIMETRIAL_COMPLETED_WEEK") ~= -1
    trial_beaten[2]             = stats.get_int("MPPLY_RCTTCOMPLETEDWEEK") ~= -1
    trial_beaten[3]             = stats.get_int("MPPLY_BTTCOMPLETED") ~= -1
    vehicle_bitset              = stats.get_int("MPX_CBV_DELIVERED_BS")
    bail_office_owned           = stats.get_int("MPX_BAIL_OFFICE_OWNED") ~= 0
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
    ls_tag_sprayed[1]           = stats.get_packed_stat_bool(42252)
    ls_tag_sprayed[2]           = stats.get_packed_stat_bool(42253)
    ls_tag_sprayed[3]           = stats.get_packed_stat_bool(42254)
    ls_tag_sprayed[4]           = stats.get_packed_stat_bool(42255)
    ls_tag_sprayed[5]           = stats.get_packed_stat_bool(42256)
    spray_can_collected         = stats.get_packed_stat_bool(51189)
    hit_completed               = stats.get_packed_stat_bool(42269)
    safe_code                   = get_safe_code()
    daily_obj_str[1]            = HUD.GET_FILENAME_FOR_AUDIO_CONVERSATION("AMDO_OBJ_" .. daily_obj[1])
    daily_obj_str[2]            = HUD.GET_FILENAME_FOR_AUDIO_CONVERSATION("AMDO_OBJ_" .. daily_obj[2])
    daily_obj_str[3]            = HUD.GET_FILENAME_FOR_AUDIO_CONVERSATION("AMDO_OBJ_" .. daily_obj[3])
    weekly_obj_str              = HUD.GET_FILENAME_FOR_AUDIO_CONVERSATION((weekly_obj_id < 99 and "AMWO_OBJ_" or "AMWO_OBJ_TX_") .. weekly_obj_id)
    weekly_obj_str              = string.gsub(weekly_obj_str, "~a~", "")
    weekly_obj_str              = string.gsub(weekly_obj_str, "~1~", weekly_obj_override)
    exotic_reward_ready         = MISC.ABSI(NETWORK.GET_TIME_DIFFERENCE(NETWORK.GET_NETWORK_TIME(), exotic_order_cooldown)) >= 30000
    total_products = (
        max_cocaine * cocaine_unit[selected_dealer + 1] +
        max_meth * meth_unit[selected_dealer + 1] +
        max_weed * weed_unit[selected_dealer + 1] +
        max_acid * acid_unit[selected_dealer + 1]
    )
    all_products = (
        max_cocaine * (cocaine_unit[1] + cocaine_unit[2] + cocaine_unit[3]) +
        max_meth * (meth_unit[1] + meth_unit[2] + meth_unit[3]) +
        max_weed * (weed_unit[1] + weed_unit[2] + weed_unit[3]) +
        max_acid * (acid_unit[1] + acid_unit[2] + acid_unit[3])
    )

    if pause_timer then
        if script.is_active("fm_content_bicycle_time_trial") then
            locals.set_int("fm_content_bicycle_time_trial", btt_local_one + 3, NETWORK.GET_NETWORK_TIME())
        end
    end
end)

daily_collectibles_tab:add_imgui(function()
    local hours, minutes, seconds = get_daily_reset_time()
    
    ImGui.Text(string.format("Daily Reset Time (6 AM UTC): %02d:%02d:%02d", hours, minutes, seconds))
    
    if ImGui.Button("Reset All Daily Collectibles") then
        set_daily_collectable_state(false)
        gui.show_message("Daily Collectibles", "All Daily Collectibles have been reset.")
    end
    
    if ImGui.Button("Complete All Daily Collectibles") then
        set_daily_collectable_state(true)
        gui.show_message("Daily Collectibles", "All Daily Collectibles have been completed.")
    end
    
    ImGui.Text("Switch session to apply the changes.")
end)

challenges_tab:add_imgui(function()
    if ImGui.TreeNode("Daily Challenges") then
        if daily_obj[1] or daily_obj[2] or daily_obj[3] then
            ImGui.Text(daily_obj_str[1])
            ImGui.Text(daily_obj_str[2])
            ImGui.Text(daily_obj_str[3])
        end
        ImGui.TreePop()
    end
    
    if ImGui.TreeNode("Weekly Challenge") then
        if weekly_obj_id then
            ImGui.Text(weekly_obj_str)
        end
        ImGui.TreePop()
    end
    
    if ImGui.Button("Complete all Challenges") then
        for i = 0, 2 do -- Unlock all daily rewards
            local objective = globals.get_int(current_objectives_global + (1 + (0 * current_objectives_global_offset)) + 681 + 4244 + (1 + (i * 3)))
            globals.set_int(objectives_state_global + 1 + (1 + (i * 1)), objective)
        end
        globals.set_int(objectives_state_global, 1)
        globals.set_int(weekly_objectives_global + (1 + (0 * 6)) + 1, globals.get_int(weekly_objectives_global + (1 + (0 * 6)) + 2)) -- Unlock Weekly Objective
    end
end)

hidden_cache_tab:add_imgui(function()
    ImGui.Text("Status: " .. (hidden_cache_collected[selected_cache + 1] and "collected" or "ready"))
    
    selected_cache = ImGui.Combo("Select Cache", selected_cache, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, 10)
    
    if ImGui.Button("Teleport") then
        if not hidden_cache_collected[selected_cache + 1] then
            script.run_in_fiber(function()
                teleport(get_collectable_coords(COLLECTABLE_HIDDEN_CACHES, selected_cache) or vec3:new(0, 0, 0))
            end)
        else
            gui.show_error("Daily Collectibles", "Hidden Cache has already been collected.")
        end
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("Collect") then
        if not hidden_cache_collected[selected_cache + 1] then
            set_collectable_collected(COLLECTABLE_HIDDEN_CACHES, selected_cache)
        else
            gui.show_error("Daily Collectibles", "Hidden Cache has already been collected.")
        end
    end
end)

treasure_chest_tab:add_imgui(function()
    ImGui.Text("Status: " .. (treasure_chest_collected[selected_treasure + 1] and "collected" or "ready"))
    
    selected_treasure = ImGui.Combo("Select Treasure", selected_treasure, { "1", "2" }, 2)
    
    if ImGui.Button("Teleport") then
        if not treasure_chest_collected[selected_treasure + 1] then
            script.run_in_fiber(function()
                teleport(get_collectable_coords(COLLECTABLE_TREASURE_CHESTS, selected_treasure) or vec3:new(0, 0, 0))
            end)
        else
            gui.show_error("Daily Collectibles", "Treasure Chest has already been collected.")
        end
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("Collect") then
        if not treasure_chest_collected[selected_treasure + 1] then
            set_collectable_collected(COLLECTABLE_TREASURE_CHESTS, selected_treasure)
        else
            gui.show_error("Daily Collectibles", "Treasure Chest has already been collected.")
        end
    end
	
    ImGui.Text("Enable Cayo Perico from Self -> Teleport to not fall into the water.")
end)

shipwrecked_tab:add_imgui(function()
    ImGui.Text("Status: " .. (shipwrecked_collected and "collected" or "ready"))
    
    if ImGui.Button("Teleport") then
        if not shipwrecked_collected then
            script.run_in_fiber(function()
                teleport(get_collectable_coords(COLLECTABLE_SHIPWRECKED, 0) or vec3:new(0, 0, 0))
            end)
        else
            gui.show_error("Daily Collectibles", "Shipwreck has already been collected.")
        end
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("Collect") then
        if not shipwrecked_collected then
            set_collectable_collected(COLLECTABLE_SHIPWRECKED, 0)
        else
            gui.show_error("Daily Collectibles", "Shipwreck has already been collected.")
        end
    end
end)

buried_stash_tab:add_imgui(function()
    ImGui.Text("Status: " .. (buried_stash_collected[selected_stash + 1] and "collected" or "ready"))
    
    selected_stash = ImGui.Combo("Select Stash", selected_stash, { "1", "2" }, 2)
    
    if ImGui.Button("Teleport") then
        if not buried_stash_collected[selected_stash + 1] then
            script.run_in_fiber(function()
                teleport(get_collectable_coords(COLLECTABLE_BURIED_STASH, selected_stash) or vec3:new(0, 0, 0))
            end)
        else
            gui.show_error("Daily Collectibles", "Buried Stash has already been collected.")
        end
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("Collect") then
        if not buried_stash_collected[selected_stash + 1] then
            set_collectable_collected(COLLECTABLE_BURIED_STASH, selected_stash)
        else
            gui.show_error("Daily Collectibles", "Buried Stash has already been collected.")
        end
    end
	
    ImGui.Text("Enable Cayo Perico from Self -> Teleport to not fall into the water.")
end)

junk_skydive_tab:add_imgui(function()
    selected_skydive = ImGui.Combo("Select Skydive", selected_skydive, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, 10)
    
    if ImGui.Button("Teleport") then
        script.run_in_fiber(function()
            teleport(get_collectable_coords(COLLECTABLE_SKYDIVES, selected_skydive) or vec3:new(0, 0, 0))
        end)
    end
end)

time_trials_tab:add_imgui(function()
    selected_trial = ImGui.Combo("Select Variant", selected_trial, { "Standard Time Trial", "RC Bandito Time Trial", "Junk Energy Bike Time Trial" }, 3)
    
    if ImGui.Button("Teleport") then
        script.run_in_fiber(function()
            if selected_trial == 0 then
                teleport(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(430)))
            elseif selected_trial == 1 then
                teleport(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(673)))
            elseif selected_trial == 2 then
                teleport(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(860)))
            end
        end)
    end
    
    ImGui.SameLine()
    
    if selected_trial == 0 then
        if ImGui.Button("Beat Trial") then
            script.run_in_fiber(function()
                if not trial_beaten[1] then
                    locals.set_int("freemode", freemode_local_one + 13, NETWORK.GET_NETWORK_TIME())
                    local tt_struct = locals.get_pointer("freemode", freemode_local_one)
                    scr_function.call_script_function("freemode", "PTTE", "2D 01 19 00 00 38", "void", {
                        { "ptr", tt_struct }
                    })
                end
            end)
        end
    elseif selected_trial == 1 then
        if ImGui.Button("Beat Trial") then
            script.run_in_fiber(function()
                if not trial_beaten[2] then
                    locals.set_int("freemode", freemode_local_two + 6, NETWORK.GET_NETWORK_TIME())
                    local rctt_struct = locals.get_pointer("freemode", freemode_local_two)
                    scr_function.call_script_function("freemode", "PRCTTE", "2D 01 17 00 00 38 00 40", "void", {
                        { "ptr", rctt_struct }
                    })
                end
            end)
        end
    elseif selected_trial == 2 then
        if not trial_beaten[3] then
            pause_timer = ImGui.Checkbox("Pause Timer", pause_timer)
        else
            pause_timer = false
        end
    end
end)

exotic_exports_tab:add_imgui(function()
    ImGui.Text("Reward Ready: " .. (exotic_reward_ready and "Yes" or "No"))
    
    if ImGui.Button("Teleport to Vehicle") then
        if vehicle_bitset ~= 1023 then
            if vehicle_coords then
                script.run_in_fiber(function()
                    teleport(vehicle_coords)
                end)
            else
                gui.show_error("Daily Collectibles", "Please wait until the next vehicle is spawned (90 seconds).")
            end
        else
            gui.show_error("Daily Collectibles", "You have already delivered all the vehicles.")
        end
    end
    
    if ImGui.Button("Deliver Vehicle") then
        if vehicle_bitset ~= 1023 then
            if not exotic_reward_ready then
                gui.show_error("Daily Collectibles", "You have just delivered a vehicle. Wait a moment.")
            else
                script.run_in_fiber(function()
                    if PLAYER.GET_PLAYER_WANTED_LEVEL(self.get_id()) ~= 0 then
                        gui.show_error("Daily Collectibles", "Lose your wanted level.")
                    elseif HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(780)) then
                        teleport(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(780)))
                    else
                        gui.show_error("Daily Collectibles", "Please get in an Exotic Exports Vehicle.")
                    end
                end)
            end
        else
            gui.show_error("Daily Collectibles", "You have already delivered all the vehicles.")
        end
    end
    
    if ImGui.Button("Spawn Next Vehicle") then
        if vehicle_bitset ~= 1023 then
            for i = 1, 10 do
                if not has_bit_set(vehicle_bitset, globals.get_int(global_one + i)) then
                    spawn_vehicle(get_vehicle_name(i, true))
                    break
                end
            end
        else
            gui.show_error("Daily Collectibles", "You have already delivered all the vehicles.")
        end
    end
    
    ImGui.Text("Today's List:")
    
    for i = 1, 10 do
        if active_vehicle == get_vehicle_name(i, true) then
            ImGui.Text(i .. " -")
            ImGui.SameLine()
            ImGui.TextColored(0.5, 0.5, 1, 1, get_vehicle_name(i, false) .. " (Active)")
        else
            if has_bit_set(vehicle_bitset, globals.get_int(global_one + i)) then
                ImGui.Text(i .. " -")
                ImGui.SameLine()
                ImGui.TextColored(0, 1, 0, 1, get_vehicle_name(i, false) .. " (Delivered)")
            else
                ImGui.Text(i .. " - " .. get_vehicle_name(i, false))
            end
        end
    end
end)

dead_drop_tab:add_imgui(function()
    ImGui.Text("Status: " .. (dead_drop_collected and "collected" or "ready"))
    
    if ImGui.Button("Teleport") then
        if not dead_drop_collected then
            script.run_in_fiber(function()
                teleport(get_collectable_coords(COLLECTABLE_DEAD_DROP, 0) or vec3:new(0, 0, 0))
            end)
        else
            gui.show_error("Daily Collectibles", "G's Cache has already been collected.")
        end
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("Collect") then
        if not dead_drop_collected then
            set_collectable_collected(COLLECTABLE_DEAD_DROP, 0)
        else
            gui.show_error("Daily Collectibles", "G's Cache has already been collected.")
        end
    end
end)

stash_house_tab:add_imgui(function()
    if not stash_house_raided then
        ImGui.Text("Safe Code: " .. (safe_code ~= nil and safe_code or "unavailable"))
    end
    ImGui.Text("Status: " .. (stash_house_raided and "raided" or "ready"))
    
    if ImGui.Button("Teleport") then
        if not stash_house_raided then
            script.run_in_fiber(function()
                if HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(845)) then
                    teleport(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(845)))
                end
            end)
        else
            gui.show_error("Daily Collectibles", "Stash House has already been raided.")
        end
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("Enter Safe Combination") then
        for i = 0, 2 do
            local safe_combination = locals.get_int("fm_content_stash_house", stash_house_local_two + 22 + (1 + (i * 2)) + 1)
            locals.set_float("fm_content_stash_house", stash_house_local_two + 22 + (1 + (i * 2)), safe_combination)
        end
    end
end)

street_dealer_tab:add_imgui(function()
    selected_dealer = ImGui.Combo("Select Dealer", selected_dealer, { "1", "2", "3" }, 3)
    
    if ImGui.Button("Teleport") then
        script.run_in_fiber(function()
            local coords = scr_function.call_script_function("freemode", GSDC, "vector3", {
                { "int", dealer_loc[selected_dealer + 1] }
            })
            teleport(coords or vec3:new(0, 0, 0))
        end)
    end
    
    ImGui.Text("Weed: $" .. format_int(max_weed * weed_unit[selected_dealer + 1]) .. " (" .. format_int(max_weed) .. " unit * " .. format_int(weed_unit[selected_dealer + 1]) .. ")")
    ImGui.Text("Meth: $" .. format_int(max_meth * meth_unit[selected_dealer + 1]) .. " (" .. format_int(max_meth) .. " unit * " .. format_int(meth_unit[selected_dealer + 1]) .. ")")
    ImGui.Text("Cocaine: $" .. format_int(max_cocaine * cocaine_unit[selected_dealer + 1]) .. " (" .. format_int(max_cocaine) .. " unit * " .. format_int(cocaine_unit[selected_dealer + 1]) .. ")")
    ImGui.Text("Acid: $" .. format_int(max_acid * acid_unit[selected_dealer + 1]) .. " (" .. format_int(max_acid) .. " unit * " .. format_int(acid_unit[selected_dealer + 1]) .. ")")
    ImGui.Text("Total: $" .. format_int(total_products))
    
    ImGui.Separator()
    
    ImGui.Text("All: $" .. format_int(all_products))
end)

ls_tags_tab:add_imgui(function()
    ImGui.Text("Status: " .. (ls_tag_sprayed[selected_tag + 1] and "sprayed" or "ready"))
    ImGui.Text("Spray Can Collected: " .. (spray_can_collected and "Yes" or "No"))
    
    ImGui.SameLine()
    if ImGui.SmallButton("" .. (spray_can_collected and "Uncollect" or "Collect")) then
        script.run_in_fiber(function()
            stats.set_packed_stat_bool(51189, not spray_can_collected)
        end)
    end
    
    selected_tag = ImGui.Combo("Select Tag", selected_tag, { "1", "2", "3", "4", "5" }, 5)
    
    if ImGui.Button("Teleport") then
        if not ls_tag_sprayed[selected_tag + 1] then
            script.run_in_fiber(function()
                teleport(get_collectable_coords(COLLECTABLE_TAGGING, selected_tag) or vec3:new(0, 0, 0))
            end)
        else
            gui.show_error("Daily Collectibles", "LS Tag has already been sprayed.")
        end
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("Spray") then
        if not ls_tag_sprayed[selected_tag + 1] then
            set_collectable_collected(COLLECTABLE_TAGGING, selected_tag)
        else
            gui.show_error("Daily Collectibles", "LS Tag has already been sprayed.")
        end
    end
end)

madrazo_hits_tab:add_imgui(function()
    ImGui.Text("Status: " .. (hit_completed and "completed" or "ready"))
    
    if ImGui.Button("Teleport") then
        if bail_office_owned then
            if not hit_completed then
                script.run_in_fiber(function()
                    if HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(886)) then
                        teleport(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(886)))
                    end
                end)
            else
                gui.show_error("Daily Collectibles", "Madrazo Hit has already been completed.")
            end
        else
            gui.show_error("Daily Collectibles", "You must own a Bail Office.")
        end
    end
end)