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

local dead_drop_area
local dead_drop_loc
local stash_house_loc
local shipwrecked_loc
local hidden_cache_loc = {}
local junk_skydive_loc = {}
local treasure_chest_loc = {}
local bruied_stash_loc = {}

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
local current_exotic_player_inside
local vehicle_bitset
local delivered_vehicles

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

function is_freemode_active()
	return SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(joaat("freemode")) ~= 0
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
    for i = 0, 10 do
        if ((delivered_bs & (1 << i)) ~= 0) then
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
	return globals.get_int(1950518 + vehicle_order)
end

script.register_looped("UpdateLocations", function (script)
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
	bruied_stash_loc[1] = stats.get_int("MPX_DAILYCOLLECT_BURIEDSTASH0")
	bruied_stash_loc[2] = stats.get_int("MPX_DAILYCOLLECT_BURIEDSTASH1")
end)

script.register_looped("UpdateStates", function (script)
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
end)

script.register_looped("StreetDealers", function (script)
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
end)

script.register_looped("ExoticExports", function (script)
	vehicle_location = globals.get_int(1890378 + 287 + 1)
	vehicle_index = globals.get_int(1890378 + 287)
	vehicle_order = (globals.get_int(1950529 + vehicle_index + 1) + 1)
	current_exotic_player_inside = globals.get_uint(2794162 + 6822 + 3)
	vehicle_bitset = stats.get_int("MPX_CBV_DELIVERED_BS")
	delivered_vehicles = count_delivered_vehicles(vehicle_bitset)
end)

dead_drop_tab:add_imgui(function()
	ImGui.Text("Area: " .. dead_drop_area)
	ImGui.Text("Location: " .. dead_drop_loc)
	ImGui.Text("Status: " .. (is_dead_drop_collected and "collected" or "ready"))
	
	if ImGui.Button("Teleport##dead_drop") then
		if is_dead_drop_collected == false then
			if is_freemode_active() then
				teleport(dead_drop_coords(dead_drop_area, dead_drop_loc))
			else
				gui.show_message("Daily Collectibles", "G's Cache is not available at the moment.")
			end
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
	ImGui.Text("Location: " .. bruied_stash_loc[selected_stash + 1])
	ImGui.Text("Status: " .. (is_buried_stash_collected[selected_stash + 1] and "collected" or "ready"))
	
	selected_stash = ImGui.Combo("Select Stash", selected_stash, { "1", "2" }, 2)
	
	if ImGui.Button("Teleport##buried_stash") then
		if is_buried_stash_collected[selected_stash + 1] == false then
			teleport(buried_stash_coords(bruied_stash_loc[selected_stash + 1]))
		else
			gui.show_message("Daily Collectibles", "Buried Stash has already been collected.")
		end
	end
end)

exotic_exports_tab:add_imgui(function()	
	ImGui.Text("Vehicle Index: " .. (vehicle_index + 1))
	ImGui.Text("Vehicles Delivered: " .. delivered_vehicles)

	if ImGui.Button("Teleport to Vehicle") then
		if vehicle_location ~= -1 then
			teleport(exotic_export_coords(vehicle_location, is_second_part(get_vehicle_order())))
		else
			gui.show_message("Daily Collectibles", "Please wait until the next Exotic Exports Vehicle is spawned (90 seconds).")
		end
	end

	ImGui.SameLine()

	if ImGui.Button("Deliver Vehicle") then
		if HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(780)) then
			teleport(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(780)))
		else
			gui.show_message("Daily Collectibles", "Please get in an Exotic Exports Vehicle.")
		end
	end

	ImGui.Text("Today's list:")
	
	for i = 1, 10 do
		if current_exotic_player_inside == get_vehicle_name(i, true) then
			ImGui.Text(i .. " -")
			ImGui.SameLine()
			ImGui.TextColored(0, 1, 0, 1, get_vehicle_name(i, false) .. " (active)")
		else
			ImGui.Text(i .. " - " .. get_vehicle_name(i, false))
		end
	end
end)

time_trials_tab:add_imgui(function()

end)
