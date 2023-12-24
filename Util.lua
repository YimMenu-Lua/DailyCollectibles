--https://stackoverflow.com/questions/10989788/format-integer-in-lua
function format_int(number)
  local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
  int = int:reverse():gsub("(%d%d%d)", "%1,")
  return minus .. int:reverse():gsub("^,", "") .. fraction
end

function help_marker(text)
    ImGui.TextDisabled("(?)")
    if ImGui.IsItemHovered() then
        ImGui.BeginTooltip()
        ImGui.PushTextWrapPos(ImGui.GetFontSize() * 35)
        ImGui.TextUnformatted(text)
        ImGui.PopTextWrapPos()
        ImGui.EndTooltip()
	end
end

function get_daily_reset_time(target_time)
	local current_utc = os.date("!*t")

	local hours_left = (24 - current_utc.hour + target_time) % 24
	local mins_left = 60 - current_utc.min
	local secs_left = 60 - current_utc.sec
	
	return hours_left, mins_left, secs_left
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
			script:yield();
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

function get_zone_name(zone_coords)
	if zone_coords == nil then
		zone_coords = vec3:new(0.0, 0.0, 0.0)
	end
	
	local zone = ZONE.GET_NAME_OF_ZONE(zone_coords.x, zone_coords.y, zone_coords.z)
	for i = 1, #zone_names do
		if joaat(zone) == joaat(zone_names[i]) then
			return zone_display_names[i]
		end
	end
	return "invalid"
end

function get_safe_code()
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

function get_vehicle_name(index, return_joaat)
    local offset = globals.get_int(1942466 + index) + 1
	local vehicle_joaat = globals.get_uint(1942455 + offset)
	if return_joaat == true then
		return vehicle_joaat
	else
		return vehicles.get_vehicle_display_name(vehicle_joaat)
	end
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