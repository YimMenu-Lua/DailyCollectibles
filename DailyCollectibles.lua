require ("Coords")

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

function format_text(format, ...)
    local formatted_text = string.format(format, ...)
    ImGui.Text(formatted_text)
end

function teleport(coords)
	script.run_in_fiber(function (script)
		PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), coords.x, coords.y, coords.z)
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

dead_drop_tab:add_imgui(function()
	format_text("Area: %d", dead_drop_area)
	format_text("Location: %d", dead_drop_loc)
	format_text("Status: %s", is_dead_drop_collected and "collected" or "ready")
	
	if ImGui.Button("Teleport##dead_drop") then
		if is_dead_drop_collected == false then
			teleport(dead_drop_coords(dead_drop_area, dead_drop_loc))
		else
			gui.show_message("Daily Collectibles", "G's Cache has already been collected.")
		end
	end
end)

stash_house_tab:add_imgui(function()
	format_text("Location: %d", stash_house_loc)
	format_text("Safe Code: %s", safe_code)
	format_text("Status: %s", is_stash_house_raided and "raided" or "ready")
	
	if ImGui.Button("Teleport##stash_house") then
		if is_stash_house_raided == false then
			teleport(stash_house_coords(stash_house_loc))
		else
			gui.show_message("Daily Collectibles", "Stash House has already been raided.")
		end
	end
end)

street_dealer_tab:add_imgui(function()

end)

shipwrecked_tab:add_imgui(function()
	format_text("Location: %d", shipwrecked_loc)
	format_text("Status: %s", is_shipwrecked_collected and "collected" or "ready")
	
	if ImGui.Button("Teleport##shipwrecked") then
		if is_shipwrecked_collected == false then
			teleport(shipwrecked_coords(shipwrecked_loc))
		else
			gui.show_message("Daily Collectibles", "Shipwreck has already been collected.")
		end
	end
end)

hidden_cache_tab:add_imgui(function()	
	format_text("Location: %d", hidden_cache_loc[selected_cache + 1])
	format_text("Status: %s", is_hidden_cache_collected[selected_cache + 1] and "collected" or "ready")
	
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
	format_text("Location: %d", junk_skydive_loc[selected_skydive + 1])
	
	selected_skydive = ImGui.Combo("Select Skydive", selected_skydive, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, 10)
	
	if ImGui.Button("Teleport##junk_skydive") then
		teleport(junk_skydive_coords(junk_skydive_loc[selected_skydive + 1]))
	end
end)

treasure_chest_tab:add_imgui(function()
	format_text("Location: %d", treasure_chest_loc[selected_treasure + 1])
	format_text("Status: %s", is_treasure_chest_collected[selected_treasure + 1] and "collected" or "ready")
	
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
	format_text("Location: %d", bruied_stash_loc[selected_stash + 1])
	format_text("Status: %s", is_buried_stash_collected[selected_stash + 1] and "collected" or "ready")
	
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

end)

time_trials_tab:add_imgui(function()

end)