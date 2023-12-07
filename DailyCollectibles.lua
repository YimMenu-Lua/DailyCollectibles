require("Coords")

daily_collectibles_tab = gui.get_tab("Daily Collectibles")

dead_drop_tab = daily_collectibles_tab:add_tab("G's Cache")
stash_house_tab = daily_collectibles_tab:add_tab("Stash House")
street_dealer_tab = daily_collectibles_tab:add_tab("Street Dealers")
shipwrecked_tab = daily_collectibles_tab:add_tab("Shipwreck")
hidden_cache_tab = daily_collectibles_tab:add_tab("Hidden Caches")
junk_skydive_tab = daily_collectibles_tab:add_tab("Junk Energy Skydives")
treasure_chest_tab = daily_collectibles_tab:add_tab("Treasure Chests")
buried_stash_tab = daily_collectibles_tab:add_tab("Buried Stashes")
exotic_exports_tab = daily_collectibles_tab:add_tab("Exotic Exports")
time_trials_tab = daily_collectibles_tab:add_tab("Time Trials")

local selected_dealer = 0
local selected_cache = 0
local selected_skydive = 0
local selected_treasure = 0
local selected_stash = 0
local selected_trial = 0

local dead_drop_area
local dead_drop_loc
local stash_house_loc
local shipwrecked_loc
local hidden_cache_loc = {}
local junk_skydive_loc = {}
local treasure_chest_loc = {}
local buried_stash_loc = {}
local trial_loc = {}

local is_dead_drop_collected
local safe_code
local is_stash_house_raided
local is_shipwrecked_collected
local is_hidden_cache_collected = {}
local is_treasure_chest_collected = {}
local is_buried_stash_collected = {}

local dealer_loc = {}
local meth_unit = {}
local weed_unit = {}
local cocaine_unit = {}
local acid_unit = {}
local max_cocaine
local max_meth
local max_weed
local max_acid
local total_products
local all_products

local vehicle_location
local vehicle_index
local vehicle_order
local current_vehicle_joaat_player_is_inside
local vehicle_bitset
local delivered_vehicles
local exotic_reward_ready

--https://stackoverflow.com/questions/10989788/format-integer-in-lua
function format_int(number)
  local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
  int = int:reverse():gsub("(%d%d%d)", "%1,")
  return minus .. int:reverse():gsub("^,", "") .. fraction
end

function teleport(coords)
	script.run_in_fiber(function (script)
		PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), coords.x, coords.y, coords.z)
	end)
end

function has_bit_set(address, pos)
	return (address & (1 << pos)) ~= 0
end

function spawn_vehicle(vehicle_joaat)
	script.run_in_fiber(function (script)
		local load_counter = 0
		while STREAMING.HAS_MODEL_LOADED(vehicle_joaat) == false do
			STREAMING.REQUEST_MODEL(vehicle_joaat);
			script.yield();
			if load_counter > 100 then
				return
			else
				load_counter = load_counter + 1
			end
		end
		local laddie = PLAYER.PLAYER_PED_ID()
		local location = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), false)
		local veh = VEHICLE.CREATE_VEHICLE(vehicle_joaat, location.x, location.y, location.z, ENTITY.GET_ENTITY_HEADING(laddie), true, false, false)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(vehicle_joaat)
		DECORATOR.DECOR_SET_INT(veh, "MPBitset", 0)
		local networkId = NETWORK.VEH_TO_NET(veh)
		if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(veh) then
			NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(networkId, true)
		end
		VEHICLE.SET_VEHICLE_IS_STOLEN(veh, false)
		PED.SET_PED_INTO_VEHICLE(laddie, veh, -1)
		ENTITY.SET_ENTITY_AS_NO_LONGER_NEEDED(veh)
	end)
end


function get_safe_code()
	code = locals.get_int("fm_content_stash_house", 3385 + 526 + 13)
	if code == 0 then return "05-02-91"
	elseif code == 1 then return "28-03-98"
	elseif code == 2 then return "24-10-81"
	elseif code == 3 then return "02-12-87"
	elseif code == 4 then return "01-23-45"
	elseif code == 5 then return "28-11-97"
	elseif code == 6 then return "77-79-73"
	elseif code == 7 then return "73-27-38"
	elseif code == 8 then return "44-23-37"
	elseif code == 9 then return "72-68-83"
	end

	return "unavailable"
end

function get_vehicle_name(order_number, return_joaat)
    local offset = globals.get_int(1950529 + order_number) + 1
	local vehicle_joaat = globals.get_uint(1950518 + offset)
	if return_joaat == true then
		return vehicle_joaat
	else
		return vehicles.get_vehicle_display_name(vehicle_joaat)
	end
end

function count_delivered_vehicles(delivered_bs)
    delivered_count = 0
    for i = 0, 9 do
        if has_bit_set(delivered_bs, i) then
            delivered_count = delivered_count + 1
        end
    end
    return delivered_count
end

function is_second_part(hash)
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

function get_vehicle_order()
	return globals.get_uint(1950518 + vehicle_order)
end

function get_challenge_time(skydive_location)
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

function get_par_time(trial_variant, trial_location)
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

script.register_looped("Daily Collectables", function (script)
	dead_drop_area = stats.get_packed_stat_int(41214)
	dead_drop_loc = stats.get_packed_stat_int(41213)
	stash_house_loc = stats.get_packed_stat_int(36623)
	shipwrecked_loc = stats.get_int("MPX_DAILYCOLLECT_SHIPWRECKED0")
	hidden_cache_loc[1] = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH0")
	hidden_cache_loc[2] = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH1")
	hidden_cache_loc[3] = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH2")
	hidden_cache_loc[4] = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH3")
	hidden_cache_loc[5] = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH4")
	hidden_cache_loc[6] = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH5")
	hidden_cache_loc[7] = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH6")
	hidden_cache_loc[8] = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH7")
	hidden_cache_loc[9] = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH8")
	hidden_cache_loc[10] = stats.get_int("MPX_DAILYCOLLECTABLES_HIDECACH9")
	junk_skydive_loc[1] = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES0")
	junk_skydive_loc[2] = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES1")
	junk_skydive_loc[3] = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES2")
	junk_skydive_loc[4] = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES3")
	junk_skydive_loc[5] = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES4")
	junk_skydive_loc[6] = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES5")
	junk_skydive_loc[7] = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES6")
	junk_skydive_loc[8] = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES7")
	junk_skydive_loc[9] = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES8")
	junk_skydive_loc[10] = stats.get_int("MPX_DAILYCOLLECT_SKYDIVES9")
	treasure_chest_loc[1] = stats.get_int("MPX_DAILYCOLLECTABLES_TREASURE0")
	treasure_chest_loc[2] = stats.get_int("MPX_DAILYCOLLECTABLES_TREASURE1")
	buried_stash_loc[1] = stats.get_int("MPX_DAILYCOLLECT_BURIEDSTASH0")
	buried_stash_loc[2] = stats.get_int("MPX_DAILYCOLLECT_BURIEDSTASH1")
	is_dead_drop_collected = stats.get_packed_stat_bool(36628)
	is_stash_house_raided = stats.get_packed_stat_bool(36657)
	safe_code = get_safe_code()
	is_shipwrecked_collected = stats.get_packed_stat_bool(31734)
	is_hidden_cache_collected[1] = stats.get_packed_stat_bool(30297)
	is_hidden_cache_collected[2] = stats.get_packed_stat_bool(30298)
	is_hidden_cache_collected[3] = stats.get_packed_stat_bool(30299)
	is_hidden_cache_collected[4] = stats.get_packed_stat_bool(30300)
	is_hidden_cache_collected[5] = stats.get_packed_stat_bool(30301)
	is_hidden_cache_collected[6] = stats.get_packed_stat_bool(30302)
	is_hidden_cache_collected[7] = stats.get_packed_stat_bool(30303)
	is_hidden_cache_collected[8] = stats.get_packed_stat_bool(30304)
	is_hidden_cache_collected[9] = stats.get_packed_stat_bool(30305)
	is_hidden_cache_collected[10] = stats.get_packed_stat_bool(30306)
	is_treasure_chest_collected[1] = stats.get_packed_stat_bool(30307)
	is_treasure_chest_collected[2] = stats.get_packed_stat_bool(30308)
	is_buried_stash_collected[1] = stats.get_packed_stat_bool(25522)
	is_buried_stash_collected[2] = stats.get_packed_stat_bool(25523)
	dealer_loc[1] = globals.get_int(2794162 + 6751 + 1 + (0 * 10))
	dealer_loc[2] = globals.get_int(2794162 + 6751 + 1 + (1 * 10))
	dealer_loc[3] = globals.get_int(2794162 + 6751 + 1 + (2 * 10))
	meth_unit[1] = globals.get_int(2794162 + 6751 + 1 + (0 * 10) + 3) -- MPX_STREET_DEALER_0_METH_PRICE
	meth_unit[2] = globals.get_int(2794162 + 6751 + 1 + (1 * 10) + 3) -- MPX_STREET_DEALER_1_METH_PRICE
	meth_unit[3] = globals.get_int(2794162 + 6751 + 1 + (2 * 10) + 3) -- MPX_STREET_DEALER_2_METH_PRICE
	weed_unit[1] = globals.get_int(2794162 + 6751 + 1 + (0 * 10) + 4) -- MPX_STREET_DEALER_0_WEED_PRICE
	weed_unit[2] = globals.get_int(2794162 + 6751 + 1 + (1 * 10) + 4) -- MPX_STREET_DEALER_1_WEED_PRICE
	weed_unit[3] = globals.get_int(2794162 + 6751 + 1 + (2 * 10) + 4) -- MPX_STREET_DEALER_2_WEED_PRICE
	cocaine_unit[1] = globals.get_int(2794162 + 6751 + 1 + (0 * 10) + 2) -- MPX_STREET_DEALER_0_COKE_PRICE
	cocaine_unit[2] = globals.get_int(2794162 + 6751 + 1 + (1 * 10) + 2) -- MPX_STREET_DEALER_1_COKE_PRICE
	cocaine_unit[3] = globals.get_int(2794162 + 6751 + 1 + (2 * 10) + 2) -- MPX_STREET_DEALER_2_COKE_PRICE
	acid_unit[1] = globals.get_int(2794162 + 6751 + 1 + (0 * 10) + 5) -- MPX_STREET_DEALER_0_ACID_PRICE
	acid_unit[2] = globals.get_int(2794162 + 6751 + 1 + (1 * 10) + 5) -- MPX_STREET_DEALER_1_ACID_PRICE
	acid_unit[3] = globals.get_int(2794162 + 6751 + 1 + (2 * 10) + 5) -- MPX_STREET_DEALER_2_ACID_PRICE
	max_cocaine = tunables.get_int(1238316723)
	max_meth = tunables.get_int(658190943)
	max_weed = tunables.get_int(803541362)
	max_acid = tunables.get_int(-1171794142)
	total_products = (max_cocaine * cocaine_unit[selected_dealer + 1] + max_meth * meth_unit[selected_dealer + 1] + max_weed * weed_unit[selected_dealer + 1] + max_acid * acid_unit[selected_dealer + 1])
	all_products = (max_cocaine * cocaine_unit[1] + max_meth * meth_unit[1] + max_weed * weed_unit[1] + max_acid * acid_unit[1] + max_cocaine * cocaine_unit[2] + max_meth * meth_unit[2] + max_weed * weed_unit[2] + max_acid * acid_unit[2] + max_cocaine * cocaine_unit[3] + max_meth * meth_unit[3] + max_weed * weed_unit[3] + max_acid * acid_unit[3])
	vehicle_location = globals.get_int(1890378 + 287 + 1)
	vehicle_index = globals.get_int(1890378 + 287)
	vehicle_order = (globals.get_int(1950529 + vehicle_index + 1) + 1)
	if PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), 0) then
		current_vehicle_joaat_player_is_inside = ENTITY.GET_ENTITY_MODEL(PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID()))
	else
		current_vehicle_joaat_player_is_inside = 0
	end
	vehicle_bitset = stats.get_int("MPX_CBV_DELIVERED_BS")
	delivered_vehicles = count_delivered_vehicles(vehicle_bitset)
	exotic_order_cooldown = globals.get_int(1956878 + 5653)
	exotic_reward_ready = MISC.ABSI(NETWORK.GET_TIME_DIFFERENCE(NETWORK.GET_NETWORK_TIME(), exotic_order_cooldown)) >= 30000
	trial_loc[1] = tunables.get_int("TIMETRIALVARIATION")
	trial_loc[2] = locals.get_int("freemode", 14109)
	trial_loc[3] = locals.get_int("freemode", 14903 + 3)
end)

dead_drop_tab:add_imgui(function()
	ImGui.Text("Area: " .. dead_drop_area)
	ImGui.Text("Location: " .. dead_drop_loc)
	ImGui.Text("Status: " .. (is_dead_drop_collected and "collected" or "ready"))
	
	if ImGui.Button("Teleport##dead_drop") then
		if is_dead_drop_collected == false then
			teleport(dead_drop_coords(dead_drop_area, dead_drop_loc))
		else
			gui.show_message("Daily Collectibles", "G's Cache has already been collected.")
		end
	end
end)

stash_house_tab:add_imgui(function()
	ImGui.Text("Location: " .. stash_house_loc)
	ImGui.Text("Safe Code: " .. safe_code)
	ImGui.Text("Status: " .. (is_stash_house_raided and "raided" or "ready"))
	
	if ImGui.Button("Teleport##stash_house") then
		if is_stash_house_raided == false then
			teleport(stash_house_coords(stash_house_loc))
		else
			gui.show_message("Daily Collectibles", "Stash House has already been raided.")
		end
	end
end)

street_dealer_tab:add_imgui(function()
	ImGui.Text("Location: " .. dealer_loc[selected_dealer + 1])

	selected_dealer = ImGui.Combo("Select Dealer", selected_dealer, { "1", "2", "3" }, 3)
	
	if ImGui.Button("Teleport##street_dealer") then
		teleport(street_dealer_coords(dealer_loc[selected_dealer + 1]))
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
	ImGui.Text("Location: " .. shipwrecked_loc)
	ImGui.Text("Status: " .. (is_shipwrecked_collected and "collected" or "ready"))
	
	if ImGui.Button("Teleport##shipwrecked") then
		if is_shipwrecked_collected == false then
			teleport(shipwrecked_coords(shipwrecked_loc))
		else
			gui.show_message("Daily Collectibles", "Shipwreck has already been collected.")
		end
	end
end)

hidden_cache_tab:add_imgui(function()	
	ImGui.Text("Location: " .. hidden_cache_loc[selected_cache + 1])
	ImGui.Text("Status: " .. (is_hidden_cache_collected[selected_cache + 1] and "collected" or "ready"))
	
	selected_cache = ImGui.Combo("Select Cache", selected_cache, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, 10)
	
	if ImGui.Button("Teleport##hidden_cache") then
		if is_hidden_cache_collected[selected_cache + 1] == false then
			teleport(hidden_cache_coords(hidden_cache_loc[selected_cache + 1]))
		else
			gui.show_message("Daily Collectibles", "Hidden Cache has already been collected.")
		end
	end
end)

junk_skydive_tab:add_imgui(function()
	ImGui.Text("Location: " .. junk_skydive_loc[selected_skydive + 1])
	ImGui.Text("Challenge Time: " .. get_challenge_time(junk_skydive_loc[selected_skydive + 1]))
	
	selected_skydive = ImGui.Combo("Select Skydive", selected_skydive, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, 10)
	
	if ImGui.Button("Teleport##junk_skydive") then
		teleport(junk_skydive_coords(junk_skydive_loc[selected_skydive + 1]))
	end
end)

treasure_chest_tab:add_imgui(function()
	ImGui.Text("Location: " .. treasure_chest_loc[selected_treasure + 1])
	ImGui.Text("Status: " .. (is_treasure_chest_collected[selected_treasure + 1] and "collected" or "ready"))
	
	selected_treasure = ImGui.Combo("Select Treasure", selected_treasure, { "1", "2" }, 2)
	
	if ImGui.Button("Teleport##treasure_chest") then
		if is_treasure_chest_collected[selected_treasure + 1] == false then
			teleport(treasure_chest_coords(treasure_chest_loc[selected_treasure + 1]))
		else
			gui.show_message("Daily Collectibles", "Treasure Chest has already been collected.")
		end
	end
end)

buried_stash_tab:add_imgui(function()
	ImGui.Text("Location: " .. buried_stash_loc[selected_stash + 1])
	ImGui.Text("Status: " .. (is_buried_stash_collected[selected_stash + 1] and "collected" or "ready"))
	
	selected_stash = ImGui.Combo("Select Stash", selected_stash, { "1", "2" }, 2)
	
	if ImGui.Button("Teleport##buried_stash") then
		if is_buried_stash_collected[selected_stash + 1] == false then
			teleport(buried_stash_coords(buried_stash_loc[selected_stash + 1]))
		else
			gui.show_message("Daily Collectibles", "Buried Stash has already been collected.")
		end
	end
end)

exotic_exports_tab:add_imgui(function()	
	--ImGui.Text("Vehicle Index: " .. (vehicle_index + 1))
	ImGui.Text("Vehicles Delivered: " .. delivered_vehicles)
	ImGui.Text("Reward Ready: " .. (exotic_reward_ready and "Yes" or "No"))

	if ImGui.Button("Teleport to Vehicle") then
		if vehicle_location ~= -1 then
			teleport(exotic_export_coords(vehicle_location, is_second_part(get_vehicle_order())))
		else
			gui.show_message("Daily Collectibles", "Please wait until the next Exotic Exports Vehicle is spawned (90 seconds).")
		end
	end

	ImGui.SameLine()

	if ImGui.Button("Deliver Vehicle") then
		if exotic_reward_ready == false then
			gui.show_message("Daily Collectibles", "You have just delivered a vehicle. Wait a moment.")
		else
			script.run_in_fiber(function (script)
				local blip_id = HUD.GET_FIRST_BLIP_INFO_ID(780)
				if HUD.DOES_BLIP_EXIST(blip_id) then
					local coords = HUD.GET_BLIP_COORDS(blip_id)
					PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), coords.x, coords.y, coords.z)
				else
					gui.show_message("Daily Collectibles", "Please get in an Exotic Exports Vehicle.")
				end
			end)
		end
	end
	
	if ImGui.Button("Spawn Next Vehicle") then
		for i = 1, 10 do
			if has_bit_set(vehicle_bitset, globals.get_int(1950529 + i)) == false then
				spawn_vehicle(get_vehicle_name(i, true))
				return
			end
		end
	end

	ImGui.Text("Today's list:")
	
	for i = 1, 10 do
		if current_vehicle_joaat_player_is_inside == get_vehicle_name(i, true) then
			ImGui.Text(i .. " -")
			ImGui.SameLine()
			ImGui.TextColored(0.5, 0.5, 1, 1, get_vehicle_name(i, false) .. " (Active)")
		else
			if has_bit_set(vehicle_bitset, globals.get_int(1950529 + i)) then
				ImGui.Text(i .. " -")
				ImGui.SameLine()
				ImGui.TextColored(0, 1, 0, 1, get_vehicle_name(i, false) .. " (Completed)")
			else
				ImGui.Text(i .. " - " .. get_vehicle_name(i, false))
			end
		end
	end
end)

time_trials_tab:add_imgui(function()
	ImGui.Text("Location: " .. trial_loc[selected_trial + 1])
	ImGui.Text("Par Time: " .. get_par_time(selected_trial, trial_loc[selected_trial + 1]))
	
	selected_trial = ImGui.Combo("Select Variant", selected_trial, { "Standart Time Trial", "RC Bandito Time Trial", "Junk Energy Time Trial" }, 3)
	
	if ImGui.Button("Teleport##trials") then
		if selected_trial == 0 then teleport(standart_trial_coords(trial_loc[1]))
		elseif selected_trial == 1 then teleport(rc_trial_coords(trial_loc[2]))
		elseif selected_trial == 2 then teleport(bike_trial_coords(trial_loc[3]))
		end
	end
end)