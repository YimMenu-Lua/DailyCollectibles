zone_names = { "airp", "alamo", "alta", "armyb", "banhamc", "banning", "beach", "bhamca", "bradp", "bradt", "burton", "calafb", "canny", "ccreak", "chamh", "chil", "chu", "cmsw", "cypre", "davis", "delbe", "delpe", "delsol", "desrt", "downt", "dtvine", "east_v", "eburo", "elgorl", "elysian", "galfish", "golf", "grapes", "greatc", "harmo", "hawick", "hors", "humlab", "jail", "koreat", "lact", "lago", "ldam", "legsqu", "lmesa", "lospuer", "mirr", "morn", "movie", "mtchil", "mtgordo", "mtjose", "murri", "nchu", "noose", "oceana", "palcov", "paleto", "palfor", "palhigh", "palmpow", "pbluff", "pbox", "procob", "rancho", "rglen", "richm", "rockf", "rtrak", "sanand", "sanchia", "sandy", "skid", "slab", "stad", "straw", "tatamo", "termina", "texti", "tongvah", "tongvav", "vcana", "vesp", "vine", "windf", "wvine", "zancudo", "zp_ort", "zq_uar", "isheist" }
zone_display_names = { "Los Santos International Airport", "Alamo Sea", "Alta", "Fort Zancudo", "Banham Canyon Dr", "Banning", "Vespucci Beach", "Banham Canyon", "Braddock Pass", "Braddock Tunnel", "Burton", "Calafia Bridge", "Raton Canyon", "Cassidy Creek", "Chamberlain Hills", "Vinewood Hills", "Chumash", "Chiliad Mountain State Wilderness", "Cypress Flats", "Davis", "Del Perro Beach", "Del Perro", "La Puerta", "Grand Senora Desert", "Downtown", "Downtown Vinewood", "East Vinewood", "El Burro Heights", "El Gordo Lighthouse", "Elysian Island", "Galilee", "GWC and Golfing Society", "Grapeseed", "Great Chaparral", "Harmony", "Hawick", "Vinewood Racetrack", "Humane Labs and Research", "Bolingbroke Penitentiary", "Little Seoul", "Land Act Reservoir", "Lago Zancudo", "Land Act Dam", "Legion Square", "La Mesa", "La Puerta", "Mirror Park", "Morningwood", "Richards Majestic", "Mount Chiliad", "Mount Gordo", "Mount Josiah", "Murrieta Heights", "North Chumash", "N.O.O.S.E", "Pacific Ocean", "Paleto Cove", "Paleto Bay", "Paleto Forest", "Palomino Highlands", "Palmer-Taylor Power Station", "Pacific Bluffs", "Pillbox Hill", "Procopio Beach", "Rancho", "Richman Glen", "Richman", "Rockford Hills", "Redwood Lights Track", "San Andreas", "San Chianski Mountain Range", "Sandy Shores", "Mission Row", "Stab City", "Maze Bank Arena", "Strawberry", "Tataviam Mountains", "Terminal", "Textile City", "Tongva Hills", "Tongva Valley", "Vespucci Canals", "Vespucci", "Vinewood", "Ron Alternates Wind Farm", "West Vinewood", "Zancudo River", "Port of South Los Santos", "Davis Quartz", "Cayo Perico" }

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

function get_vehicle_name(index, return_joaat)
    local offset = globals.get_int(1950529 + index) + 1
	local vehicle_joaat = globals.get_uint(1950518 + offset)
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