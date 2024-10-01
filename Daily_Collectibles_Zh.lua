-- 脚本翻译和修改制作 —— By MatteEley
-- 仅做备份上传至Github 请勿盈利

local daily_collectibles_tab = gui.get_tab("每日收藏品")

local challenges_tab     = daily_collectibles_tab:add_tab("挑战")
local hidden_cache_tab   = daily_collectibles_tab:add_tab("隐藏包裹")
local treasure_chest_tab = daily_collectibles_tab:add_tab("藏宝箱")
local shipwrecked_tab    = daily_collectibles_tab:add_tab("沉船藏宝箱")
local buried_stash_tab   = daily_collectibles_tab:add_tab("地下藏匿品")
local junk_skydive_tab   = daily_collectibles_tab:add_tab("垃机能量高空跳伞")
local time_trials_tab    = daily_collectibles_tab:add_tab("时间挑战赛")
local exotic_exports_tab = daily_collectibles_tab:add_tab("外贸出口载具")
local dead_drop_tab      = daily_collectibles_tab:add_tab("杰拉德的包裹")
local stash_house_tab    = daily_collectibles_tab:add_tab("藏匿屋")
local street_dealer_tab  = daily_collectibles_tab:add_tab("街头毒贩")
local ls_tags_tab        = daily_collectibles_tab:add_tab("洛圣都涂鸦")
local madrazo_hits_tab   = daily_collectibles_tab:add_tab("玛德拉索雇凶悬赏")

local GDCC = 0xBED3F
local GSDC = 0x5AAAFE

local global_one              = 1943205
local global_two              = 1943194
local global_three            = 2738935
local global_three_offset_one = 6813
local global_three_offset_two = 6898
local global_four             = 1882247
local global_five             = 1949771
local global_five_offset      = 5878

local current_objectives_global        = 2359296
local current_objectives_global_offset = 5570
local weekly_objectives_global         = 2737993
local objectives_state_global          = 1574744

local freemode_local_one     = 14386
local freemode_local_two     = 14436
local freemode_local_three   = 15239
local stash_house_local_one  = 3521
local skydive_local_one      = 253
local skydive_local_two      = 3194
local daily_bounty_local_one = 2533
local daily_bounty_local_two = 216

local fm_content_shared_local = 119

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
local dead_drop_collected      = false
local stash_house_raided       = false
local shipwrecked_collected    = false
local spray_can_collected      = false
local hit_completed            = false
local exotic_reward_ready      = false
local always_gold_medal        = false
local pause_timer              = false
local bail_office_owned        = false
local weapon_of_choice         = false
local weekly_obj_str           = ""
local safe_code                = "无"
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
local meth_unit                = { 0, 0, 0 }
local weed_unit                = { 0, 0, 0 }
local cocaine_unit             = { 0, 0, 0 }
local acid_unit                = { 0, 0, 0 }

local COLLECTABLE_MOVIE_PROPS      = 0
local COLLECTABLE_HIDDEN_CACHES    = 1
local COLLECTABLE_TREASURE_CHESTS  = 2
local COLLECTABLE_RADIO_STATIONS   = 3
local COLLECTABLE_USB_PIRATE_RADIO = 4
local COLLECTABLE_SHIPWRECKED      = 5
local COLLECTABLE_BURIED_STASH     = 6
--Local COLLECTABLE_METAL_DETECTOR = 7 未使用（变为随机事件）
local COLLECTABLE_TRICK_OR_TREAT   = 8
local COLLECTABLE_LD_ORGANICS      = 9
local COLLECTABLE_SKYDIVES         = 10
--local COLLECTABLE_SIGHTSEEING    = 11 未使用（变为随机事件）
--local COLLECTABLE_POLICE_BADGES  = 12 未使用（CnC）
local COLLECTABLE_GUN_PARTS        = 13 -- (犯罪现场随机事件，CnC 的残留物）
-- 14-15 未知/不存在
local COLLECTABLE_SNOWMEN          = 16
local COLLECTABLE_DEAD_DROP        = 17
-- 18 未知/不存在
local COLLECTABLE_TAGGING          = 19

-- 如果 (COLLECTABLES_TREASURE_CHESTS && IS_PLAYER_ON_CAYO_SCOPE_PREP(PLAYER::PLAYER_ID())
-- 这个补丁用 PUSH_CONST_1 代替了 IAND，因此 IS_PLAYER_ON_CAYO_SCOPE_PREP 的结果在这个检查中总是被认为是 true。
-- 如果 COLLECTABLES_TREASURE_CHESTS 可调变量为 false，条件仍将失败（这并不重要，因为这是我们想要的行为）。
treasure_chest_patch = scr_patch:new("freemode", "BTCSC", "5D A4 9C 22 1F", 4, {0x72})

-- 该补丁将 bVar0 的值设置为 “true”，用于检查埋藏的藏匿物是否会生成。
-- Rockstar 在其调试版本中使用该变量跳过 佩里科岛 检查，因此我们的做法与他们如出一辙。
buried_stash_patch = scr_patch:new("freemode", "BBSSC", "71 39 02 38 02 06 56 ? ? 2C", 0, {0x72})

-- 此补丁防止当玩家被通缉时，战局禁用码头的标记。
exotic_exports_patch1 = scr_patch:new("freemode", "EXBWC1", "2C 05 06 11 71 09 39 2A", 0, {0x00, 0x00, 0x00, 0x00, 0x00, 0x71})

-- 此补丁绕过了 gb_delivery 中的通缉等级限制。
-- 它不应与其他任何贩卖销售货物任务冲突（希望如此）。
exotic_exports_patch2 = scr_patch:new("gb_delivery", "EXBWC2", "2D 02 04 00 00 2C ? ? ? 2C", 5, {0x71, 0x2E, 0x02, 0x01})

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
        gui.show_error("每日收藏品", "传送失败，坐标无效。")
        return
    end
    PED.SET_PED_COORDS_KEEP_VEHICLE(self.get_ped(), coords.x, coords.y, coords.z)
end

local function has_bit_set(address, pos)
    return (address & (1 << pos)) ~= 0
end

local function get_collectable_coords(collectable_type, collectable_index)
    if not script.is_active("freemode") then
        return nil
    end
    local coords = scr_function.call_script_function("freemode", GDCC, "vector3", {
        { "int", collectable_type },
        { "int", collectable_index }
    })
    return coords
end

local function set_collectable_collected(collectable_type, collectable_index)
    if not script.is_active("freemode") then
        return
    end
    scr_function.call_script_function("freemode", "SCC", "2D 05 33 00 00", "void", {
        { "int", collectable_type },
        { "int", collectable_index },
        { "bool", true },  -- 设置已隐藏
        { "bool", true },  -- 打印帮助信息
        { "bool", false }  -- 禁用 不给糖就捣蛋 特效
    })
end

local function set_daily_collectable_state(state)
    stats.set_packed_stat_bool(36628, state) -- 杰拉德的包裹
    stats.set_packed_stat_bool(36657, state) -- 藏匿屋
    stats.set_packed_stat_bool(31734, state) -- 沉船
    stats.set_packed_stat_bool(30297, state) -- 隐藏包裹 1
    stats.set_packed_stat_bool(30298, state) -- 隐藏包裹 2
    stats.set_packed_stat_bool(30299, state) -- 隐藏包裹 3
    stats.set_packed_stat_bool(30300, state) -- 隐藏包裹 4
    stats.set_packed_stat_bool(30301, state) -- 隐藏包裹 5
    stats.set_packed_stat_bool(30302, state) -- 隐藏包裹 6
    stats.set_packed_stat_bool(30303, state) -- 隐藏包裹 7
    stats.set_packed_stat_bool(30304, state) -- 隐藏包裹 8
    stats.set_packed_stat_bool(30305, state) -- 隐藏包裹 9
    stats.set_packed_stat_bool(30306, state) -- 隐藏包裹 10
    stats.set_packed_stat_bool(30307, state) -- 藏宝箱 1
    stats.set_packed_stat_bool(30308, state) -- 藏宝箱 2
    stats.set_packed_stat_bool(25522, state) -- 地下藏匿品 1
    stats.set_packed_stat_bool(25523, state) -- 地下藏匿品 2
    stats.set_packed_stat_bool(42252, state) -- 洛圣都涂鸦 1
    stats.set_packed_stat_bool(42253, state) -- 洛圣都涂鸦 2
    stats.set_packed_stat_bool(42254, state) -- 洛圣都涂鸦 3
    stats.set_packed_stat_bool(42255, state) -- 洛圣都涂鸦 4
    stats.set_packed_stat_bool(42256, state) -- 洛圣都涂鸦 5
    stats.set_packed_stat_bool(42269, state) -- 玛德拉索雇凶悬赏
    -- 以下内容次世代独占，但在 PC 上可获得完整的统计数据和交互菜单功能
    stats.set_packed_stat_bool(42059, state) -- 拍拍动物 摄影 1
    stats.set_packed_stat_bool(42060, state) -- 拍拍动物 摄影 2
    stats.set_packed_stat_bool(42061, state) -- 拍拍动物 摄影 3
    for skydive_index = 0, 9 do
        -- 查看脚本事件 1916113629 的 getter，这是R星的另一个愚蠢设计。
        stats.set_packed_stat_int((34837 + skydive_index * 4), state and junk_skydive_loc[skydive_index + 1] or -1) -- 垃机能量跳伞检查点
        stats.set_packed_stat_int((34839 + skydive_index * 4), state and junk_skydive_loc[skydive_index + 1] or -1) -- 拉机能量跳伞 精准着陆
        stats.set_packed_stat_int((34838 + skydive_index * 4), state and junk_skydive_loc[skydive_index + 1] or -1) -- 拉机能量跳伞 目标时间
        stats.set_packed_stat_int((34840 + skydive_index * 4), state and junk_skydive_loc[skydive_index + 1] or -1) -- 拉机能量跳伞 金牌
    end
    for lantern_index = 34252, 34261 do
        stats.set_packed_stat_bool(lantern_index, state) -- 不给糖就捣蛋
    end
    for lantern_index = 34512, 34701 do
        stats.set_packed_stat_bool(lantern_index, state) -- 不给糖就捣蛋
    end
    stats.set_int("MPPLY_TIMETRIAL_COMPLETED_WEEK", state and trial_loc[1] or -1) -- 时间挑战赛
    stats.set_int("MPPLY_RCTTCOMPLETEDWEEK", state and trial_loc[2] or -1) -- RC 匪徒时间挑战赛
    stats.set_int("MPPLY_BTTCOMPLETED", state and trial_loc[3] or -1) -- 拉机能量时间挑战赛
    stats.set_int("MPX_CBV_DELIVERED_BS", state and 1023 or 0) -- 外贸载具出口
    stats.set_int("MPX_CBV_STATE", state and 1 or 0) -- 外贸载具出口
end

local function spawn_vehicle(vehicle_joaat, scr)
    local load_counter = 0
    while not STREAMING.HAS_MODEL_LOADED(vehicle_joaat) do
        STREAMING.REQUEST_MODEL(vehicle_joaat)
        scr:yield()
        if load_counter > 100 then
            return
        else
            load_counter = load_counter + 1
        end
    end
    local veh = VEHICLE.CREATE_VEHICLE(vehicle_joaat, self.get_pos().x, self.get_pos().y, self.get_pos().z, ENTITY.GET_ENTITY_HEADING(self.get_ped()), true, false, false)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(vehicle_joaat)
    DECORATOR.DECOR_SET_INT(veh, "MPBitset", 0)
    if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(veh) then
        NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.VEH_TO_NET(veh), true)
    end
    VEHICLE.SET_VEHICLE_IS_STOLEN(veh, false)
    PED.SET_PED_INTO_VEHICLE(self.get_ped(), veh, -1)
    ENTITY.SET_ENTITY_AS_NO_LONGER_NEEDED(veh)
end

local function get_safe_code()
    if not script.is_active("fm_content_stash_house") then
        return "无"
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
    local offset        = globals.get_int(global_one + index) + 1
    local vehicle_joaat = globals.get_uint(global_two + offset)
    if return_joaat then
        return vehicle_joaat
    else
        local display_name = vehicles.get_vehicle_display_name(vehicle_joaat)
        return display_name ~= "" and display_name or "无"
    end
end

local function get_next_vehicle_hash()
    local hash = 0
    for i = 1, 10 do
        if not has_bit_set(vehicle_bitset, globals.get_int(global_one + i)) then
            hash = get_vehicle_name(i, true)
            break
        end
    end
    return hash
end

event.register_handler(menu_event.ScriptsReloaded, function()
    treasure_chest_patch:disable_patch()
    buried_stash_patch:disable_patch()
    exotic_exports_patch1:disable_patch()
    exotic_exports_patch2:disable_patch()
end)

script.register_looped("每日收藏品", function()
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
    -- 我需要检查脚本，否则一旦你尝试切换战局，游戏就会崩溃...都怪哑光
    if always_gold_medal then
        if script.is_active("fm_content_skydive") then
            local checkpoints = locals.get_int("fm_content_skydive", skydive_local_one + 143) - 1
            local skydive_bs  = locals.get_int("fm_content_skydive", skydive_local_two + (1 + (self.get_id() * 51)) + 43 + 1)
            skydive_bs        = skydive_bs | (1 << 4) -- 设置精准着陆
            skydive_bs        = skydive_bs | (1 << 7) -- 设置时间
            locals.set_int("fm_content_skydive", fm_content_shared_local + 2, checkpoints)
            locals.set_int("fm_content_skydive", fm_content_shared_local + 21, NETWORK.GET_NETWORK_TIME()) -- 将计时器直接设置为 0（不是必须的，但为什么不设置捏？）
            locals.set_int("fm_content_skydive", skydive_local_two + (1 + (self.get_id() * 51)) + 43 + 1, skydive_bs)
        end
    end
    if not trial_beaten[3] and pause_timer then
        if script.is_active("fm_content_bicycle_time_trial") then
            locals.set_int("fm_content_bicycle_time_trial", fm_content_shared_local + 3, NETWORK.GET_NETWORK_TIME())
        end
    end
    if weapon_of_choice then
        if script.is_active("fm_content_daily_bounty") then
            local bonus_completed = locals.get_int("fm_content_daily_bounty", daily_bounty_local_one + 369 + 1) | (1 << 4)
            locals.set_int("fm_content_daily_bounty", daily_bounty_local_one + 369 + 1, bonus_completed)
        end
    end
end)

daily_collectibles_tab:add_imgui(function()
    local hours, minutes, seconds = get_daily_reset_time()
    
    ImGui.Text(string.format("每日重置时间（北京时间 14:00）: %02d:%02d:%02d", hours, minutes, seconds))
    
    if ImGui.Button("重置所有每日收藏品") then
        script.run_in_fiber(function()
            set_daily_collectable_state(false)
            gui.show_message("每日收藏品", "所有每日收藏品已重置")
        end)
    end
    
    if ImGui.Button("完成所有每日收藏品") then
        script.run_in_fiber(function()
            set_daily_collectable_state(true)
            gui.show_message("每日收藏品", "所有每日收藏品已完成")
        end)
    end
    
    ImGui.Text("更换一个战局来应用修改")
end)

challenges_tab:add_imgui(function()
    if ImGui.TreeNode("每日挑战") then
        if daily_obj[1] or daily_obj[2] or daily_obj[3] then
            ImGui.Text(daily_obj_str[1])
            ImGui.Text(daily_obj_str[2])
            ImGui.Text(daily_obj_str[3])
        end
        ImGui.TreePop()
    end
    
    if ImGui.TreeNode("每周挑战") then
        if weekly_obj_id then
            ImGui.Text(weekly_obj_str)
        end
        ImGui.TreePop()
    end
    
    if ImGui.Button("完成所有挑战") then
        for i = 0, 2 do -- 直接完成所有每日挑战
            local objective = globals.get_int(current_objectives_global + (1 + (0 * current_objectives_global_offset)) + 681 + 4244 + (1 + (i * 3)))
            globals.set_int(objectives_state_global + 1 + (1 + (i * 1)), objective)
        end
        globals.set_int(objectives_state_global, 1)
        globals.set_int(weekly_objectives_global + (1 + (0 * 6)) + 1, globals.get_int(weekly_objectives_global + (1 + (0 * 6)) + 2)) -- 直接完成每周挑战
    end
end)

hidden_cache_tab:add_imgui(function()
    ImGui.Text("状态: " .. (hidden_cache_collected[selected_cache + 1] and "已收集" or "未收集"))
    
    selected_cache = ImGui.Combo("选择包裹", selected_cache, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, 10)
    
    if ImGui.Button("传送") then
        script.run_in_fiber(function()
            if not hidden_cache_collected[selected_cache + 1] then
                local coords = get_collectable_coords(COLLECTABLE_HIDDEN_CACHES, selected_cache)
                teleport(coords)
            else
                gui.show_error("每日收藏品", "这个位置的隐藏包裹已经收集了")
            end
        end)
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("收集") then
        script.run_in_fiber(function()
            if not hidden_cache_collected[selected_cache + 1] then
                set_collectable_collected(COLLECTABLE_HIDDEN_CACHES, selected_cache)
            else
                gui.show_error("每日收藏品", "这个位置的隐藏包裹已经收集了")
            end
        end)
    end
end)

treasure_chest_tab:add_imgui(function()
    ImGui.Text("状态: " .. (treasure_chest_collected[selected_treasure + 1] and "已收集" or "未收集"))
    
    selected_treasure = ImGui.Combo("选择藏宝箱", selected_treasure, { "1", "2" }, 2)
    
    if ImGui.Button("传送") then
        script.run_in_fiber(function()
            if not treasure_chest_collected[selected_treasure + 1] then
                local coords = get_collectable_coords(COLLECTABLE_TREASURE_CHESTS, selected_treasure)
                teleport(coords)
            else
                gui.show_error("每日收藏品", "这个位置的藏宝箱已经收集了")
            end
        end)
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("收集") then
        script.run_in_fiber(function()
            if not treasure_chest_collected[selected_treasure + 1] then
                set_collectable_collected(COLLECTABLE_TREASURE_CHESTS, selected_treasure)
            else
                gui.show_error("每日收藏品", "这个位置的藏宝箱已经收集了")
            end
        end)
    end
    
    ImGui.Text("在手动收集藏宝箱之前，请先点击自身 - 传送 - 加载特殊地图 - Cayo Perico 选择加载IPL")
end)

shipwrecked_tab:add_imgui(function()
    ImGui.Text("状态: " .. (shipwrecked_collected and "已收集" or "未收集"))
    
    if ImGui.Button("传送") then
        script.run_in_fiber(function()
            if not shipwrecked_collected then
                local coords = get_collectable_coords(COLLECTABLE_SHIPWRECKED, 0)
                teleport(coords)
            else
                gui.show_error("每日收藏品", "今日沉船藏宝箱已经收集了")
            end
        end)
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("收集") then
        script.run_in_fiber(function()
            if not shipwrecked_collected then
                set_collectable_collected(COLLECTABLE_SHIPWRECKED, 0)
            else
                gui.show_error("每日收藏品", "今日沉船藏宝箱已经收集了")
            end
        end)
    end
end)

buried_stash_tab:add_imgui(function()
    ImGui.Text("状态: " .. (buried_stash_collected[selected_stash + 1] and "已收集" or "未收集"))
    
    selected_stash = ImGui.Combo("选择地下藏匿品", selected_stash, { "1", "2" }, 2)
    
    if ImGui.Button("传送") then
        script.run_in_fiber(function()
            if not buried_stash_collected[selected_stash + 1] then
                local coords = get_collectable_coords(COLLECTABLE_BURIED_STASH, selected_stash)
                teleport(coords)
            else
                gui.show_error("每日收藏品", "这个位置的地下藏匿品已经收集了")
            end
        end)
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("收集") then
        script.run_in_fiber(function()
            if not buried_stash_collected[selected_stash + 1] then
                set_collectable_collected(COLLECTABLE_BURIED_STASH, selected_stash)
            else
                gui.show_error("每日收藏品", "这个位置的地下藏匿品已经收集了")
            end
        end)
    end
    
    ImGui.Text("在手动收集地下藏匿品之前，请先点击自身 - 传送 - 加载特殊地图 - Cayo Perico 选择加载IPL")
end)

junk_skydive_tab:add_imgui(function()
    selected_skydive = ImGui.Combo("选择拉机能量跳伞", selected_skydive, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, 10)
    
    if ImGui.Button("传送") then
        script.run_in_fiber(function()
            local coords = get_collectable_coords(COLLECTABLE_SKYDIVES, selected_skydive)
            teleport(coords)
        end)
    end
    
    ImGui.SameLine()
    
    always_gold_medal = ImGui.Checkbox("锁定时间", always_gold_medal)
end)

time_trials_tab:add_imgui(function()
    selected_trial = ImGui.Combo("选择时间挑战赛", selected_trial, { "时间挑战赛", "RC 匪徒时间挑战赛", "拉机能量时间挑战赛" }, 3)
    
    if ImGui.Button("传送") then
        script.run_in_fiber(function()
            if selected_trial == 0 then
                if HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(430)) then
                    local coords = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(430))
                    teleport(coords)
                else
                    gui.show_error("每日收藏品", "请在互动菜单启用时间挑战赛 互动菜单 - 偏好 - 地图标记点选项 - 活动")
                end
            elseif selected_trial == 1 then
                if not trial_beaten[2] then
                    if HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(673)) then
                        local coords = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(673))
                        teleport(coords)
                    else
                        gui.show_error("每日收藏品", "请在互动菜单启用RC 匪徒时间挑战赛 互动菜单 - 偏好 - 地图标记点选项 - 活动")
                    end
                else
                    gui.show_error("每日收藏品", "RC 匪徒时间挑战赛已经完成了")
                end
            elseif selected_trial == 2 then
                if not trial_beaten[3] then
                    if HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(860)) then
                        local coords = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(860))
                        teleport(coords)
                    else
                        gui.show_error("每日收藏品", "每日收藏品", "请在互动菜单启用拉机能量时间挑战赛 互动菜单 - 偏好 - 地图标记点选项 - 活动")
                    end
                else
                    gui.show_error("每日收藏品", "拉机能量时间挑战赛已经完成了")
                end
            end
        end)
    end
    
    ImGui.SameLine()
    
    if selected_trial == 0 then
        if ImGui.Button("完成时间挑战赛(00:00:00)") then
            script.run_in_fiber(function()
                if not trial_beaten[1] then
                    if script.is_active("freemode") then
                        locals.set_int("freemode", freemode_local_one + 13, NETWORK.GET_NETWORK_TIME())
                        local tt_struct = locals.get_pointer("freemode", freemode_local_one)
                        scr_function.call_script_function("freemode", "PTTE", "2D 01 19 00 00 38", "void", {
                            { "ptr", tt_struct }
                        })
                    end
                else
                    gui.show_error("每日收藏品", "时间挑战赛已经完成了")
                end
            end)
        end
    elseif selected_trial == 1 then
        if ImGui.Button("完成RC 匪徒时间挑战赛(00:00:00)") then
            script.run_in_fiber(function()
                if not trial_beaten[2] then
                    if script.is_active("freemode") then
                        locals.set_int("freemode", freemode_local_two + 6, NETWORK.GET_NETWORK_TIME())
                        local rctt_struct = locals.get_pointer("freemode", freemode_local_two)
                        scr_function.call_script_function("freemode", "PRCTTE", "2D 01 17 00 00 38 00 40", "void", {
                            { "ptr", rctt_struct }
                        })
                    end
                else
                    gui.show_error("每日收藏品", "RC 匪徒时间挑战赛已经完成了")
                end
            end)
        end
    elseif selected_trial == 2 then
        pause_timer = ImGui.Checkbox("锁定时间", pause_timer)
    end
end)

exotic_exports_tab:add_imgui(function()
    ImGui.Text("交易冷却状态: " .. (exotic_reward_ready and "已冷却完成" or "未冷却完成"))
    
    if ImGui.Button("传送到外贸出口载具") then
        script.run_in_fiber(function()
            if vehicle_bitset ~= 1023 then
                local is_available = globals.get_int(global_four + 1 + (1 + (3 * 15))) >= 1
                if is_available then
                    local coords = globals.get_vec3(global_four + 1 + (1 + (3 * 15)) + 10)
                    teleport(coords)
                else
                    gui.show_error("每日收藏品", "请等待下一辆外贸出口载具生成（这需要90秒）")
                end
            else
                gui.show_error("每日收藏品", "您已经出口了今日所有外贸载具")
            end
        end)
    end
    
    if ImGui.Button("传送到港口区") then
        script.run_in_fiber(function()
            if vehicle_bitset ~= 1023 then
                if HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(780)) then
                    if exotic_reward_ready then
                        local coords = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(780))
                        teleport(coords)
                    else
                        gui.show_error("每日收藏品", "您刚刚已经出口了一辆外贸载具，请稍等...")
                    end
                else
                    gui.show_error("每日收藏品", "请驾驶外贸出口载具或启用改装铺生意 互动菜单 - 偏好 - 地图标记点选项 - 敌对游戏内容 - 改装铺生意")
                end
            else
                gui.show_error("每日收藏品", "您已经出口了今日所有外贸载具")
            end
        end)
    end
    
    if ImGui.Button("生成下一辆外贸出口载具") then
        script.run_in_fiber(function(script)
            if vehicle_bitset ~= 1023 then
                if exotic_reward_ready then
                    local next_veh = get_next_vehicle_hash()
                    spawn_vehicle(next_veh, script)
                else
                    gui.show_error("每日收藏品", "您刚刚已经出口了一辆外贸载具，请稍等...")
                end
            else
                gui.show_error("每日收藏品", "您已经出口了今日所有外贸载具")
            end
        end)
    end
    
    if ImGui.Button("直接完成下一辆外贸出口载具") then
        script.run_in_fiber(function()
            if vehicle_bitset ~= 1023 then
                if exotic_reward_ready then
                    if script.is_active("freemode") then
                        local next_veh = get_next_vehicle_hash()
                        scr_function.call_script_function("freemode", "PDE", "2D 0C 2A 00 00", "void", {
                            { "int", 0 },
                            { "int", self.get_id() },
                            { "int", 0 },
                            { "int", 0 },
                            { "int", 0 },
                            { "int", 0 },
                            { "int", 0 },
                            { "int", 0 },
                            { "int", 0 },
                            { "int", 0 },
                            { "int", next_veh },
                            { "int", 273 }
                        })
                        globals.set_int(global_five + global_five_offset, NETWORK.GET_NETWORK_TIME())
                    end
                else
                    gui.show_error("每日收藏品", "您刚刚已经出口了一辆外贸载具，请稍等...")
                end
            else
                gui.show_error("每日收藏品", "您已经出口了今日所有外贸载具")
            end
        end)
    end
    
    ImGui.Text("今日外贸出口载具顺序列表:")
    
    for i = 1, 10 do
        local veh_hash  = get_vehicle_name(i, true)
        local veh_name  = get_vehicle_name(i, false)
        local veh_index = globals.get_int(global_one + i)
        if active_vehicle == veh_hash then
            ImGui.Text(i .. " -")
            ImGui.SameLine()
            ImGui.TextColored(0.5, 0.5, 1, 1, veh_name .. " (未运送)")
        else
            if has_bit_set(vehicle_bitset, veh_index) then
                ImGui.Text(i .. " -")
                ImGui.SameLine()
                ImGui.TextColored(0, 1, 0, 1, veh_name .. " (已运送)")
            else
                ImGui.Text(i .. " - " .. veh_name)
            end
        end
    end
end)

dead_drop_tab:add_imgui(function()
    ImGui.Text("状态: " .. (dead_drop_collected and "已收集" or "未收集"))
    
    if ImGui.Button("传送") then
        script.run_in_fiber(function()
            if not dead_drop_collected then
                local coords = get_collectable_coords(COLLECTABLE_DEAD_DROP, 0)
                teleport(coords)
            else
                gui.show_error("每日收藏品", "今日杰拉德的包裹已经收集了")
            end
        end)
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("收集") then
        script.run_in_fiber(function()
            if not dead_drop_collected then
                set_collectable_collected(COLLECTABLE_DEAD_DROP, 0)
            else
                gui.show_error("每日收藏品", "今日杰拉德的包裹已经收集了")
            end
        end)
    end
end)

stash_house_tab:add_imgui(function()
    ImGui.Text("状态: " .. (stash_house_raided and "已掠夺" or "未掠夺"))
    
    if not stash_house_raided then
        ImGui.Text("保险箱密码: " .. (safe_code ~= nil and safe_code or "无"))
    end
    
    if ImGui.Button("传送") then
        script.run_in_fiber(function()
            if not stash_house_raided then
                local coords = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(845))
                teleport(coords)
            else
                gui.show_error("每日收藏品", "今日藏匿屋已经掠夺了")
            end
        end)
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("直接输入保险箱密码(多点两次并处于破解保险箱状态)") then
        if script.is_active("fm_content_stash_house") then
            for i = 0, 2 do
                local safe_combination = locals.get_int("fm_content_stash_house", fm_content_shared_local + 22 + (1 + (i * 2)) + 1)
                locals.set_float("fm_content_stash_house", fm_content_shared_local + 22 + (1 + (i * 2)), safe_combination)
            end
        else
            gui.show_error("每日收藏品", "今日藏匿屋已经掠夺了或你不处于保险箱破解状态")
        end
    end
end)

street_dealer_tab:add_imgui(function()
    selected_dealer = ImGui.Combo("选择街头毒贩", selected_dealer, { "1", "2", "3" }, 3)
    
    if ImGui.Button("传送") then
        script.run_in_fiber(function()
            local coords = nil
            if script.is_active("freemode") then
                coords = scr_function.call_script_function("freemode", GSDC, "vector3", {
                    { "int", dealer_loc[selected_dealer + 1] }
                })
            end
            teleport(coords)
        end)
    end
    
    ImGui.Text("大麻: $" .. format_int(max_weed * weed_unit[selected_dealer + 1]) .. " (" .. format_int(max_weed) .. " 一份 * " .. format_int(weed_unit[selected_dealer + 1]) .. ")")
    ImGui.Text("冰毒: $" .. format_int(max_meth * meth_unit[selected_dealer + 1]) .. " (" .. format_int(max_meth) .. " 一份 * " .. format_int(meth_unit[selected_dealer + 1]) .. ")")
    ImGui.Text("可卡因: $" .. format_int(max_cocaine * cocaine_unit[selected_dealer + 1]) .. " (" .. format_int(max_cocaine) .. " 一份 * " .. format_int(cocaine_unit[selected_dealer + 1]) .. ")")
    ImGui.Text("致幻剂: $" .. format_int(max_acid * acid_unit[selected_dealer + 1]) .. " (" .. format_int(max_acid) .. " 一份 * " .. format_int(acid_unit[selected_dealer + 1]) .. ")")
    ImGui.Text("总计: $" .. format_int(total_products))
    
    ImGui.Separator()
    
    ImGui.Text("全部: $" .. format_int(all_products))
end)

ls_tags_tab:add_imgui(function()
    ImGui.Text("状态: " .. (ls_tag_sprayed[selected_tag + 1] and "已涂鸦" or "未涂鸦"))
    
    ImGui.Text("喷漆罐: " .. (spray_can_collected and "已收集" or "未收集"))
    ImGui.SameLine()
    if ImGui.SmallButton("" .. (spray_can_collected and "移除喷漆罐" or "收集喷漆罐")) then
        script.run_in_fiber(function()
            stats.set_packed_stat_bool(51189, not spray_can_collected)
        end)
    end
    
    selected_tag = ImGui.Combo("选择涂鸦", selected_tag, { "1", "2", "3", "4", "5" }, 5)
    
    if ImGui.Button("传送") then
        script.run_in_fiber(function()
            if not ls_tag_sprayed[selected_tag + 1] then
                local coords = get_collectable_coords(COLLECTABLE_TAGGING, selected_tag)
                teleport(coords)
            else
                gui.show_error("每日收藏品", "这个位置的海报已经涂鸦了")
            end
        end)
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("涂鸦") then
        script.run_in_fiber(function()
            if not ls_tag_sprayed[selected_tag + 1] then
                set_collectable_collected(COLLECTABLE_TAGGING, selected_tag)
            else
                gui.show_error("每日收藏品", "这个位置的海报已经涂鸦了")
            end
        end)
    end
end)

madrazo_hits_tab:add_imgui(function()
    ImGui.Text("状态: " .. (hit_completed and "已完成" or "未完成"))
    
    if ImGui.Button("传送") then
        script.run_in_fiber(function()
            if bail_office_owned then
                if not hit_completed then
                    local coords = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(886))
                    teleport(coords)
                else
                    gui.show_error("每日收藏品", "今日玛德拉索雇凶悬赏已经完成了")
                end
            else
                gui.show_error("每日收藏品", "您必须拥有保金办公室资产")
            end
        end)
    end
    
    ImGui.SameLine()
    
    if ImGui.Button("传送到目标") then
        script.run_in_fiber(function()
            if not hit_completed then
                local coords = locals.get_vec3("fm_content_daily_bounty", daily_bounty_local_two + 419 + 1 + (1 + (0 * 4)))
                teleport(coords)
            else
                gui.show_error("每日收藏品", "今日玛德拉索雇凶悬赏已经完成了")
            end
        end)
    end
    
    weapon_of_choice = ImGui.Checkbox("允许使用任意武器完成也可获得额外奖励", weapon_of_choice)
end)