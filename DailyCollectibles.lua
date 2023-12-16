require("Coords")
require("Util")

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
local active_vehicle
local vehicle_bitset
local exotic_reward_ready

local dead_drop_zone
local stash_house_zone
local dealer_zone = {}
local shipwrecked_zone
local hidden_cache_zone = {}
local junk_skydive_zone = {}
local treasure_chest_zone = {}
local buried_stash_zone = {}
local exotic_zone
local trial_zone = {}

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
	dealer_loc[1] = globals.get_int(2738587 + 6776 + 1 + (0 * 11))
	dealer_loc[2] = globals.get_int(2738587 + 6776 + 1 + (1 * 11))
	dealer_loc[3] = globals.get_int(2738587 + 6776 + 1 + (2 * 11))
	meth_unit[1] = globals.get_int(2738587 + 6776 + 1 + (0 * 11) + 3) -- MPX_STREET_DEALER_0_METH_PRICE
	meth_unit[2] = globals.get_int(2738587 + 6776 + 1 + (1 * 11) + 3) -- MPX_STREET_DEALER_1_METH_PRICE
	meth_unit[3] = globals.get_int(2738587 + 6776 + 1 + (2 * 11) + 3) -- MPX_STREET_DEALER_2_METH_PRICE
	weed_unit[1] = globals.get_int(2738587 + 6776 + 1 + (0 * 11) + 4) -- MPX_STREET_DEALER_0_WEED_PRICE
	weed_unit[2] = globals.get_int(2738587 + 6776 + 1 + (1 * 11) + 4) -- MPX_STREET_DEALER_1_WEED_PRICE
	weed_unit[3] = globals.get_int(2738587 + 6776 + 1 + (2 * 11) + 4) -- MPX_STREET_DEALER_2_WEED_PRICE
	cocaine_unit[1] = globals.get_int(2738587 + 6776 + 1 + (0 * 11) + 2) -- MPX_STREET_DEALER_0_COKE_PRICE
	cocaine_unit[2] = globals.get_int(2738587 + 6776 + 1 + (1 * 11) + 2) -- MPX_STREET_DEALER_1_COKE_PRICE
	cocaine_unit[3] = globals.get_int(2738587 + 6776 + 1 + (2 * 11) + 2) -- MPX_STREET_DEALER_2_COKE_PRICE
	acid_unit[1] = globals.get_int(2738587 + 6776 + 1 + (0 * 11) + 5) -- MPX_STREET_DEALER_0_ACID_PRICE
	acid_unit[2] = globals.get_int(2738587 + 6776 + 1 + (1 * 11) + 5) -- MPX_STREET_DEALER_1_ACID_PRICE
	acid_unit[3] = globals.get_int(2738587 + 6776 + 1 + (2 * 11) + 5) -- MPX_STREET_DEALER_2_ACID_PRICE
	max_cocaine = tunables.get_int(1238316723)
	max_meth = tunables.get_int(658190943)
	max_weed = tunables.get_int(803541362)
	max_acid = tunables.get_int(-1171794142)
	total_products = (max_cocaine * cocaine_unit[selected_dealer + 1] + max_meth * meth_unit[selected_dealer + 1] + max_weed * weed_unit[selected_dealer + 1] + max_acid * acid_unit[selected_dealer + 1])
	all_products = (max_cocaine * cocaine_unit[1] + max_meth * meth_unit[1] + max_weed * weed_unit[1] + max_acid * acid_unit[1] + max_cocaine * cocaine_unit[2] + max_meth * meth_unit[2] + max_weed * weed_unit[2] + max_acid * acid_unit[2] + max_cocaine * cocaine_unit[3] + max_meth * meth_unit[3] + max_weed * weed_unit[3] + max_acid * acid_unit[3])
	vehicle_location = globals.get_int(1882037 + 302 + 1)
	vehicle_index = globals.get_int(1882037 + 302)
	vehicle_order = (globals.get_int(1942466 + vehicle_index + 1) + 1)
	active_vehicle = globals.get_uint(2738587 + 6860 + 3)
	vehicle_bitset = stats.get_int("MPX_CBV_DELIVERED_BS")
	exotic_order_cooldown = globals.get_int(1948923 + 5839)
	exotic_reward_ready = MISC.ABSI(NETWORK.GET_TIME_DIFFERENCE(NETWORK.GET_NETWORK_TIME(), exotic_order_cooldown)) >= 30000
	trial_loc[1] = tunables.get_int("TIMETRIALVARIATION")
	trial_loc[2] = locals.get_int("freemode", 14282)
	trial_loc[3] = locals.get_int("freemode", 15076 + 3)
	dead_drop_zone = get_zone_name(dead_drop_coords(dead_drop_area, dead_drop_loc))
	stash_house_zone = get_zone_name(stash_house_coords(stash_house_loc))
	dealer_zone[1] = get_zone_name(street_dealer_coords(dealer_loc[1]))
	dealer_zone[2] = get_zone_name(street_dealer_coords(dealer_loc[2]))
	dealer_zone[3] = get_zone_name(street_dealer_coords(dealer_loc[3]))
	shipwrecked_zone = get_zone_name(shipwrecked_coords(shipwrecked_loc))
	hidden_cache_zone[1] = get_zone_name(hidden_cache_coords(hidden_cache_loc[1]))
	hidden_cache_zone[2] = get_zone_name(hidden_cache_coords(hidden_cache_loc[2]))
	hidden_cache_zone[3] = get_zone_name(hidden_cache_coords(hidden_cache_loc[3]))
	hidden_cache_zone[4] = get_zone_name(hidden_cache_coords(hidden_cache_loc[4]))
	hidden_cache_zone[5] = get_zone_name(hidden_cache_coords(hidden_cache_loc[5]))
	hidden_cache_zone[6] = get_zone_name(hidden_cache_coords(hidden_cache_loc[6]))
	hidden_cache_zone[7] = get_zone_name(hidden_cache_coords(hidden_cache_loc[7]))
	hidden_cache_zone[8] = get_zone_name(hidden_cache_coords(hidden_cache_loc[8]))
	hidden_cache_zone[9] = get_zone_name(hidden_cache_coords(hidden_cache_loc[9]))
	hidden_cache_zone[10] = get_zone_name(hidden_cache_coords(hidden_cache_loc[10]))
	junk_skydive_zone[1] = get_zone_name(junk_skydive_coords(junk_skydive_loc[1]))
	junk_skydive_zone[2] = get_zone_name(junk_skydive_coords(junk_skydive_loc[2]))
	junk_skydive_zone[3] = get_zone_name(junk_skydive_coords(junk_skydive_loc[3]))
	junk_skydive_zone[4] = get_zone_name(junk_skydive_coords(junk_skydive_loc[4]))
	junk_skydive_zone[5] = get_zone_name(junk_skydive_coords(junk_skydive_loc[5]))
	junk_skydive_zone[6] = get_zone_name(junk_skydive_coords(junk_skydive_loc[6]))
	junk_skydive_zone[7] = get_zone_name(junk_skydive_coords(junk_skydive_loc[7]))
	junk_skydive_zone[8] = get_zone_name(junk_skydive_coords(junk_skydive_loc[8]))
	junk_skydive_zone[9] = get_zone_name(junk_skydive_coords(junk_skydive_loc[9]))
	junk_skydive_zone[10] = get_zone_name(junk_skydive_coords(junk_skydive_loc[10]))
	treasure_chest_zone[1] = get_zone_name(treasure_chest_coords(treasure_chest_loc[1]))
	treasure_chest_zone[2] = get_zone_name(treasure_chest_coords(treasure_chest_loc[2]))
	buried_stash_zone[1] = get_zone_name(buried_stash_coords(buried_stash_loc[1]))
	buried_stash_zone[2] = get_zone_name(buried_stash_coords(buried_stash_loc[1]))
	exotic_zone = get_zone_name(exotic_export_coords(vehicle_location, is_second_part(globals.get_uint(1942455 + vehicle_order)))) -- may return the wrong zone while the script generates the random number
	trial_zone[1] = get_zone_name(standart_trial_coords(trial_loc[1]))
	trial_zone[2] = get_zone_name(rc_trial_coords(trial_loc[2]))
	trial_zone[3] = get_zone_name(bike_trial_coords(trial_loc[3]))
end)

dead_drop_tab:add_imgui(function()
	ImGui.Text("Location: " .. dead_drop_zone)
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
	ImGui.Text("Location: " .. stash_house_zone)
	if is_stash_house_raided == false then
		ImGui.Text("Safe Code: " .. safe_code)
	end
	ImGui.Text("Status: " .. (is_stash_house_raided and "raided" or "ready"))
	
	if ImGui.Button("Teleport##stash_house") then
		if is_stash_house_raided == false then
			script.run_in_fiber(function (script)
				if HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(845)) then
					teleport(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(845)))
				end				
			end)
		else
			gui.show_message("Daily Collectibles", "Stash House has already been raided.")
		end
	end
	
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
	ImGui.Text("Location: " .. dealer_zone[selected_dealer + 1])

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
	ImGui.Text("Location: " .. shipwrecked_zone)
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
	ImGui.Text("Location: " .. hidden_cache_zone[selected_cache + 1])
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
	ImGui.Text("Location: " .. junk_skydive_zone[selected_skydive + 1])
	ImGui.Text("Challenge Time: " .. get_challenge_time(junk_skydive_loc[selected_skydive + 1]))
	
	selected_skydive = ImGui.Combo("Select Skydive", selected_skydive, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, 10)
	
	if ImGui.Button("Teleport##junk_skydive") then
		teleport(junk_skydive_coords(junk_skydive_loc[selected_skydive + 1]))
	end
end)

treasure_chest_tab:add_imgui(function()
	ImGui.Text("Location: " .. treasure_chest_zone[selected_treasure + 1])
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
	ImGui.Text("Location: " .. buried_stash_zone[selected_stash + 1])
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
	ImGui.Text("Location: " .. (vehicle_location ~= -1 and exotic_zone or "None"))
	ImGui.Text("Reward Ready: " .. (exotic_reward_ready and "Yes" or "No"))

	if ImGui.Button("Teleport to Vehicle") then
		if vehicle_bitset ~= 1023 then
			if vehicle_location ~= -1 then
				teleport(exotic_export_coords(vehicle_location, is_second_part(globals.get_uint(1942455 + vehicle_order))))
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
			if exotic_reward_ready == false then
				gui.show_message("Daily Collectibles", "You have just delivered a vehicle. Wait a moment.")
			else
				script.run_in_fiber(function (script)
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
				if has_bit_set(vehicle_bitset, globals.get_int(1942466 + i)) == false then
					spawn_vehicle(get_vehicle_name(i, true))
					return
				end
			end
		else
			gui.show_message("Daily Collectibles", "You have already delivered all the vehicles.")
		end
	end

	ImGui.Text("Today's list:")
	
	for i = 1, 10 do
		if active_vehicle == get_vehicle_name(i, true) then
			ImGui.Text(i .. " -")
			ImGui.SameLine()
			ImGui.TextColored(0.5, 0.5, 1, 1, get_vehicle_name(i, false) .. " (Active)")
		else
			if has_bit_set(vehicle_bitset, globals.get_int(1942466 + i)) then
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
	ImGui.Text("Location: " .. trial_zone[selected_trial + 1])
	ImGui.Text("Par Time: " .. get_par_time(selected_trial, trial_loc[selected_trial + 1]))
	
	selected_trial = ImGui.Combo("Select Variant", selected_trial, { "Standart Time Trial", "RC Bandito Time Trial", "Junk Energy Time Trial" }, 3)
	
	if ImGui.Button("Teleport##trials") then
		if selected_trial == 0 then teleport(standart_trial_coords(trial_loc[1]))
		elseif selected_trial == 1 then teleport(rc_trial_coords(trial_loc[2]))
		elseif selected_trial == 2 then teleport(bike_trial_coords(trial_loc[3]))
		end
	end
end)