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
local ls_tags_tab        = daily_collectibles_tab:add_tab("LS Tags")
local madrazo_hits_tab   = daily_collectibles_tab:add_tab("Madrazo Hits")

local global_one              = 1943205
local global_two              = 1943194
local global_three            = 2738934
local global_three_offset_one = 6813
local global_three_offset_two = 6898
local global_four             = 1882247
local global_five             = 1949771
local global_five_offset      = 5878

local freemode_local_one    = 14436
local freemode_local_two    = 15239
local stash_house_local_one = 3521
local stash_house_local_two = 119

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
local esp_gs_cache       = false
local esp_stash_house    = false
local esp_street_dealers = false
local esp_shipwreck      = false
local esp_hidden_caches  = false
local esp_treasure_chest = false
local esp_buried_stash   = false
local esp_exotic_vehicle = false
local esp_ls_tag         = false
local esp_madrazo_hit    = false

local weekly_obj_id            = 0
local weekly_obj_override      = 0
local dead_drop_area           = 0
local dead_drop_loc            = 0
local stash_house_loc          = 0
local shipwrecked_loc          = 0
local hit_loc                  = 0
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
local spray_can_collected      = false
local hit_completed            = false
local exotic_reward_ready      = false
local safe_code                = ""
local daily_obj                = {}
local street_dealer_loc        = {}
local hidden_cache_loc         = {}
local junk_skydive_loc         = {}
local treasure_chest_loc       = {}
local buried_stash_loc         = {}
local time_trial_loc           = {}
local ls_tag_loc               = {}
local hidden_cache_collected   = {}
local treasure_chest_collected = {}
local buried_stash_collected   = {}
local ls_tag_sprayed           = {}
local meth_unit                = {}
local weed_unit                = {}
local cocaine_unit             = {}
local acid_unit                = {}

local dead_drop_coords = {
    [0] = {
        [0] = vec3:new(1113.557, -645.957, 56.091),
        [1] = vec3:new(1142.874, -662.951, 57.135),
        [2] = vec3:new(1146.691, -703.717, 56.167),
        [3] = vec3:new(1073.542, -678.236, 56.583),
        [4] = vec3:new(1046.454, -722.915, 56.419)
    },
    [1] = {
        [0] = vec3:new(2064.713, 3489.88, 44.223),
        [1] = vec3:new(2081.859, 3553.254, 42.157),
        [2] = vec3:new(2014.72, 3551.499, 42.726),
        [3] = vec3:new(1997.019, 3507.838, 39.666),
        [4] = vec3:new(2045.597, 3564.346, 39.343)
    },
    [2] = {
        [0] = vec3:new(-1317.344, -1481.97, 3.923),
        [1] = vec3:new(-1350.041, -1478.273, 4.567),
        [2] = vec3:new(-1393.87, -1445.139, 3.437),
        [3] = vec3:new(-1367.034, -1413.992, 2.611),
        [4] = vec3:new(-1269.861, -1426.272, 3.556)
    },
    [3] = {
        [0] = vec3:new(-295.468, 2787.385, 59.864),
        [1] = vec3:new(-284.69, 2848.234, 53.266),
        [2] = vec3:new(-329.193, 2803.404, 57.787),
        [3] = vec3:new(-306.847, 2825.6, 58.219),
        [4] = vec3:new(-336.046, 2829.988, 55.448)
    },
    [4] = {
        [0] = vec3:new(-1725.245, 233.946, 57.685),
        [1] = vec3:new(-1639.892, 225.521, 60.336),
        [2] = vec3:new(-1648.48, 212.049, 59.777),
        [3] = vec3:new(-1693.318, 156.665, 63.855),
        [4] = vec3:new(-1699.193, 179.574, 63.185)
    },
    [5] = {
        [0] = vec3:new(-949.714, -710.658, 19.604),
        [1] = vec3:new(-938.774, -781.817, 19.657),
        [2] = vec3:new(-884.91, -786.863, 15.043),
        [3] = vec3:new(-895.257, -729.943, 19.143),
        [4] = vec3:new(-932.986, -746.452, 19.008)
    },
    [6] = {
        [0] = vec3:new(-425.948, 1213.342, 324.936),
        [1] = vec3:new(-387.267, 1137.65, 321.704),
        [2] = vec3:new(-477.999, 1135.36, 320.123),
        [3] = vec3:new(-431.822, 1119.449, 325.964),
        [4] = vec3:new(-387.902, 1161.655, 324.529)
    },
    [7] = {
        [0] = vec3:new(-3381.278, 965.534, 7.426),
        [1] = vec3:new(-3427.724, 979.944, 7.526),
        [2] = vec3:new(-3413.606, 961.845, 11.038),
        [3] = vec3:new(-3419.585, 977.595, 11.167),
        [4] = vec3:new(-3425.687, 961.215, 7.536)
    },
    [8] = {
        [0] = vec3:new(-688.732, 5828.4, 16.696),
        [1] = vec3:new(-673.425, 5799.744, 16.467),
        [2] = vec3:new(-710.348, 5769.631, 16.75),
        [3] = vec3:new(-699.926, 5801.619, 16.504),
        [4] = vec3:new(-660.359, 5781.733, 18.774)
    },
    [9] = {
        [0] = vec3:new(38.717, 6264.173, 32.88),
        [1] = vec3:new(84.67, 6292.286, 30.731),
        [2] = vec3:new(97.17, 6288.558, 38.447),
        [3] = vec3:new(14.453, 6243.932, 35.445),
        [4] = vec3:new(67.52, 6261.744, 32.029)
    },
    [10] = {
        [0] = vec3:new(2954.598, 4671.458, 50.106),
        [1] = vec3:new(2911.146, 4637.608, 49.3),
        [2] = vec3:new(2945.212, 4624.044, 49.078),
        [3] = vec3:new(2941.139, 4617.117, 52.114),
        [4] = vec3:new(2895.884, 4686.396, 48.094)
    },
    [11] = {
        [0] = vec3:new(1332.319, 4271.446, 30.646),
        [1] = vec3:new(1353.332, 4387.911, 43.541),
        [2] = vec3:new(1337.892, 4321.563, 38.093),
        [3] = vec3:new(1386.603, 4366.511, 42.236),
        [4] = vec3:new(1303.193, 4313.509, 36.939)
    },
    [12] = {
        [0] = vec3:new(2720.03, 1572.762, 20.204),
        [1] = vec3:new(2663.161, 1581.395, 24.418),
        [2] = vec3:new(2661.482, 1641.057, 24.001),
        [3] = vec3:new(2671.003, 1561.394, 23.882),
        [4] = vec3:new(2660.104, 1606.54, 28.61)
    },
    [13] = {
        [0] = vec3:new(211.775, -934.269, 23.466),
        [1] = vec3:new(198.265, -884.039, 30.696),
        [2] = vec3:new(189.542, -919.726, 29.96),
        [3] = vec3:new(169.504, -934.841, 29.228),
        [4] = vec3:new(212.376, -934.807, 29.007)
    },
    [14] = {
        [0] = vec3:new(1330.113, -2520.754, 46.365),
        [1] = vec3:new(1328.954, -2538.302, 46.976),
        [2] = vec3:new(1237.506, -2572.335, 39.791),
        [3] = vec3:new(1244.602, -2563.721, 42.646),
        [4] = vec3:new(1278.421, -2565.117, 43.544)
    }
}

local street_dealer_coords = {
    [0] = vec3:new(550.8953, -1774.5175, 28.3121),
    [1] = vec3:new(-154.924, 6434.428, 30.916),
    [2] = vec3:new(400.9768, 2635.3691, 43.5045),
    [3] = vec3:new(1533.846, 3796.837, 33.456),
    [4] = vec3:new(-1666.642, -1080.0201, 12.1537),
    [5] = vec3:new(-1560.6105, -413.3221, 37.1001),
    [6] = vec3:new(819.2939, -2988.8562, 5.0209),
    [7] = vec3:new(1001.701, -2162.448, 29.567),
    [8] = vec3:new(1388.9678, -1506.0815, 57.0407),
    [9] = vec3:new(-3054.574, 556.711, 0.661),
    [10] = vec3:new(-72.8903, 80.717, 70.6161),
    [11] = vec3:new(198.6676, -167.0663, 55.3187),
    [12] = vec3:new(814.636, -280.109, 65.463),
    [13] = vec3:new(-237.004, -256.513, 38.122),
    [14] = vec3:new(-493.654, -720.734, 22.921),
    [15] = vec3:new(156.1586, 6656.525, 30.5882),
    [16] = vec3:new(1986.3129, 3786.75, 31.2791),
    [17] = vec3:new(-685.5629, 5762.8706, 16.511),
    [18] = vec3:new(1707.703, 4924.311, 41.078),
    [19] = vec3:new(1195.3047, 2630.4685, 36.81),
    [20] = vec3:new(167.0163, 2228.922, 89.7867),
    [21] = vec3:new(2724.0076, 1483.066, 23.5007),
    [22] = vec3:new(1594.9329, 6452.817, 24.3172),
    [23] = vec3:new(-2177.397, 4275.945, 48.12),
    [24] = vec3:new(-2521.249, 2311.794, 32.216),
    [25] = vec3:new(-3162.873, 1115.6418, 19.8526),
    [26] = vec3:new(-1145.026, -2048.466, 12.218),
    [27] = vec3:new(-1304.321, -1318.848, 3.88),
    [28] = vec3:new(-946.727, 322.081, 70.357),
    [29] = vec3:new(-895.112, -776.624, 14.91),
    [30] = vec3:new(-250.614, -1527.617, 30.561),
    [31] = vec3:new(-601.639, -1026.49, 21.55),
    [32] = vec3:new(2712.9868, 4324.1157, 44.8521),
    [33] = vec3:new(726.772, 4169.101, 39.709),
    [34] = vec3:new(178.3272, 3086.2603, 42.0742),
    [35] = vec3:new(2351.592, 2524.249, 46.694),
    [36] = vec3:new(388.9941, 799.6882, 186.6764),
    [37] = vec3:new(2587.9822, 433.6803, 107.6139),
    [38] = vec3:new(830.2875, -1052.7747, 27.6666),
    [39] = vec3:new(-759.662, -208.396, 36.271),
    [40] = vec3:new(-43.7171, -2015.22, 17.017),
    [41] = vec3:new(124.02, -1039.884, 28.213),
    [42] = vec3:new(479.0473, -597.5507, 27.4996),
    [43] = vec3:new(959.67, 3619.036, 31.668),
    [44] = vec3:new(2375.8994, 3162.9954, 47.2087),
    [45] = vec3:new(-1505.687, 1526.558, 114.257),
    [46] = vec3:new(645.737, 242.173, 101.153),
    [47] = vec3:new(1173.1378, -388.2896, 70.5896),
    [48] = vec3:new(-1801.85, 172.49, 67.771),
    [49] = vec3:new(3729.2568, 4524.872, 21.4755)
}

local shipwrecked_coords = {
    [0] = vec3:new(-389.978, -2215.861, 0.565),
    [1] = vec3:new(-872.646, -3121.243, 2.533),
    [2] = vec3:new(-1969.555, -3073.933, 1.899),
    [3] = vec3:new(-1227.362, -1862.997, 1.071),
    [4] = vec3:new(-1684.489, -1077.488, 0.464),
    [5] = vec3:new(-2219.716, -438.266, 0.828),
    [6] = vec3:new(-3099.804, 494.968, 0.134),
    [7] = vec3:new(-3226.636, 1337.312, 0.634),
    [8] = vec3:new(-2879.233, 2247.547, 0.878),
    [9] = vec3:new(-1767.392, 2642.144, 0.089),
    [10] = vec3:new(-180.913, 3081.589, 19.814),
    [11] = vec3:new(-2198.02, 4606.557, 1.402),
    [12] = vec3:new(-1356.295, 5379.136, 0.351),
    [13] = vec3:new(-844.701, 6045.489, 1.201),
    [14] = vec3:new(126.747, 7095.39, 0.484),
    [15] = vec3:new(473.135, 6741.893, -0.009),
    [16] = vec3:new(1469.845, 6629.33, -0.152),
    [17] = vec3:new(2356.588, 6663.491, -0.172),
    [18] = vec3:new(3380.806, 5670.246, 0.898),
    [19] = vec3:new(3198.166, 5091.909, 0.464),
    [20] = vec3:new(3947.421, 4403.337, 0.275),
    [21] = vec3:new(3901.5327, 3323.1387, 0.5902),
    [22] = vec3:new(3646.8667, 3120.687, 0.4864),
    [23] = vec3:new(2891.847, 1790.7085, 1.4015),
    [24] = vec3:new(2779.8674, 1106.5143, -0.0319),
    [25] = vec3:new(2783.5151, 82.6473, -0.0161),
    [26] = vec3:new(2820.225, -759.2029, 1.4572),
    [27] = vec3:new(2772.996, -1606.0311, -0.1129),
    [28] = vec3:new(1818.4303, -2718.4414, 0.1797),
    [29] = vec3:new(987.383, -2681.047, -0.1296)
}

local hidden_cache_coords = {
    [0] = vec3:new(-150.585, -2852.332, -17.97),
    [1] = vec3:new(-540.975, -2465.579, -18.201),
    [2] = vec3:new(15.332, -2323.989, -14.224),
    [3] = vec3:new(461.483, -2386.212, -10.055),
    [4] = vec3:new(839.554, -2782.746, -20.516),
    [5] = vec3:new(1309.934, -2985.761, -21.344),
    [6] = vec3:new(1394.588, -3371.972, -17.855),
    [7] = vec3:new(1067.032, -3610.489, -52.777),
    [8] = vec3:new(371.111, -3226.341, -19.88),
    [9] = vec3:new(-1365.19, -3701.575, -32.056),
    [10] = vec3:new(-1983.722, -2769.391, -22.868),
    [11] = vec3:new(-1295.859, -1948.583, -7.47),
    [12] = vec3:new(-1791.493, -1284.341, -16.36),
    [13] = vec3:new(-1879.817, -1111.846, -19.249),
    [14] = vec3:new(-2086.537, -862.681, -37.465),
    [15] = vec3:new(-2614.496, -636.549, -35.296),
    [16] = vec3:new(-2815.156, -585.703, -59.753),
    [17] = vec3:new(-3412.1304, 165.8565, -32.6174),
    [18] = vec3:new(-3554.145, 817.679, -28.592),
    [19] = vec3:new(-3440.336, 1416.229, -33.629),
    [20] = vec3:new(-3295.557, 2020.828, -20.276),
    [21] = vec3:new(-3020.068, 2527.044, -22.628),
    [22] = vec3:new(-3183.344, 3051.828, -39.251),
    [23] = vec3:new(-3270.3245, 3670.6917, -26.5299),
    [24] = vec3:new(-2860.754, 3912.275, -33.684),
    [25] = vec3:new(-2752.189, 4572.626, -21.415),
    [26] = vec3:new(-2407.659, 4898.846, -45.411),
    [27] = vec3:new(-1408.649, 5734.096, -36.339),
    [28] = vec3:new(-1008.661, 6531.678, -22.122),
    [29] = vec3:new(-811.495, 6667.619, -14.098),
    [30] = vec3:new(-420.119, 7224.093, -44.899),
    [31] = vec3:new(425.78, 7385.154, -44.087),
    [32] = vec3:new(556.131, 7158.932, -38.031),
    [33] = vec3:new(1441.456, 6828.521, -44.977),
    [34] = vec3:new(1820.262, 7017.078, -78.959),
    [35] = vec3:new(2396.039, 6939.861, -104.858),
    [36] = vec3:new(2475.159, 6704.704, -9.333),
    [37] = vec3:new(2696.607, 6655.181, -21.513),
    [38] = vec3:new(3049.285, 6549.182, -36.306),
    [39] = vec3:new(3411.339, 6308.514, -52.545),
    [40] = vec3:new(3770.457, 5838.503, -27.88),
    [41] = vec3:new(3625.00, 5543.203, -26.645),
    [42] = vec3:new(3986.087, 3867.625, -31.705),
    [43] = vec3:new(3846.006, 3683.454, -17.227),
    [44] = vec3:new(4130.328, 3530.792, -27.516),
    [45] = vec3:new(3897.776, 3050.804, -19.277),
    [46] = vec3:new(3751.005, 2672.416, -48.526),
    [47] = vec3:new(3559.241, 2070.137, -38.01),
    [48] = vec3:new(3410.804, 1225.255, -55.684),
    [49] = vec3:new(3373.351, 323.788, -20.246),
    [50] = vec3:new(3152.983, -261.257, -8.355),
    [51] = vec3:new(3192.368, -367.909, -30.311),
    [52] = vec3:new(3178.722, -988.684, -25.133),
    [53] = vec3:new(2701.915, -1365.816, -13.163),
    [54] = vec3:new(3045.378, -1682.987, -31.797),
    [55] = vec3:new(2952.829, -2313.142, -94.421),
    [56] = vec3:new(2361.167, -2728.077, -67.131),
    [57] = vec3:new(1824.039, -2973.19, -41.865),
    [58] = vec3:new(-575.734, -3132.886, -21.879),
    [59] = vec3:new(-1872.968, -2087.878, -61.897),
    [60] = vec3:new(-3205.486, -144.9, -31.784),
    [61] = vec3:new(-1760.539, 5721.301, -74.808),
    [62] = vec3:new(-1293.948, 5886.757, -27.186),
    [63] = vec3:new(-6.032, 7464.313, -12.313),
    [64] = vec3:new(3627.174, 5286.089, -35.437),
    [65] = vec3:new(3978.554, 4987.259, -69.702),
    [66] = vec3:new(3995.491, 4858.986, -37.555),
    [67] = vec3:new(4218.075, 4116.594, -29.013),
    [68] = vec3:new(3795.855, 2327.765, -37.352),
    [69] = vec3:new(3247.753, 1395.029, -50.268),
    [70] = vec3:new(3451.907, 278.014, -99.633),
    [71] = vec3:new(1061.475, 7157.525, -28.239),
    [72] = vec3:new(-1551.109, 5558.511, -22.472),
    [73] = vec3:new(-29.194, -3484.225, -34.377),
    [74] = vec3:new(2981.125, 843.773, -4.586),
    [75] = vec3:new(2446.59, -2413.441, -35.135),
    [76] = vec3:new(423.342, -2864.345, -16.944),
    [77] = vec3:new(668.404, -3173.142, -6.337),
    [78] = vec3:new(-2318.251, 4976.115, -101.11),
    [79] = vec3:new(806.924, 6846.94, -3.666),
    [80] = vec3:new(4404.907, 4617.076, -20.163),
    [81] = vec3:new(3276.699, 1648.139, -44.099),
    [82] = vec3:new(2979.325, 1.033, -16.746),
    [83] = vec3:new(-838.069, -1436.609, -10.248),
    [84] = vec3:new(-3334.358, 3276.015, -27.291),
    [85] = vec3:new(-808.456, 6165.307, -3.398),
    [86] = vec3:new(-397.854, 6783.974, -19.076),
    [87] = vec3:new(95.133, 3898.854, 24.086),
    [88] = vec3:new(660.099, 3760.461, 19.43),
    [89] = vec3:new(2241.487, 4022.88, 25.675),
    [90] = vec3:new(1553.867, 4321.805, 19.761),
    [91] = vec3:new(857.875, 3958.953, 6.001),
    [92] = vec3:new(3431.468, 717.226, -93.674),
    [93] = vec3:new(-1634.57, -1741.677, -34.462),
    [94] = vec3:new(-3378.466, 503.853, -27.274),
    [95] = vec3:new(-1732.212, 5336.15, -7.72),
    [96] = vec3:new(-2612.415, 4266.765, -30.535),
    [97] = vec3:new(3406.32, -584.198, -18.545),
    [98] = vec3:new(-3106.876, 2432.615, -23.172),
    [99] = vec3:new(-2172.952, -3199.194, -33.315)
}

local junk_skydive_coords = {
    [0] = vec3:new(-121.199, -962.557, 26.524),
    [1] = vec3:new(153.572, -721.103, 46.328),
    [2] = vec3:new(-812.47, 299.77, 85.407),
    [3] = vec3:new(-1223.345, 3856.44, 488.126),
    [4] = vec3:new(426.341, 5612.683, 765.588),
    [5] = vec3:new(503.8174, 5506.424, 773.6786),
    [6] = vec3:new(813.5065, 5720.6187, 693.7969),
    [7] = vec3:new(-860.4413, 4729.499, 275.6516),
    [8] = vec3:new(1717.6476, 3295.5166, 40.4591),
    [9] = vec3:new(2033.4845, 4733.43, 40.8773),
    [10] = vec3:new(-1167.212, -2494.621, 12.956),
    [11] = vec3:new(2790.4, 1465.635, 23.518),
    [12] = vec3:new(-782.166, -1452.285, 4.013),
    [13] = vec3:new(-559.43, -909.031, 22.863),
    [14] = vec3:new(-136.551, 6356.967, 30.492),
    [15] = vec3:new(742.95, 2535.935, 72.156),
    [16] = vec3:new(-2952.79, 441.363, 14.251),
    [17] = vec3:new(-1522.113, 1491.642, 110.595),
    [18] = vec3:new(261.555, -209.291, 60.566),
    [19] = vec3:new(739.4191, -1223.1754, 23.7705),
    [20] = vec3:new(-1724.4279, -1129.78, 12.0438),
    [21] = vec3:new(735.9623, 1303.1774, 359.293),
    [22] = vec3:new(2555.3403, 301.0995, 107.4623),
    [23] = vec3:new(-1143.5713, 2683.302, 17.0937),
    [24] = vec3:new(-917.5775, -1155.1293, 3.7723)
}

local treasure_chest_coords = {
    [0] = vec3:new(4877.7646, -4781.151, 1.1379),
    [1] = vec3:new(4535.187, -4703.817, 1.1286),
    [2] = vec3:new(3900.6318, -4704.9194, 3.4813),
    [3] = vec3:new(4823.4844, -4323.176, 4.6816),
    [4] = vec3:new(5175.097, -4678.9375, 1.4205),
    [5] = vec3:new(5590.9507, -5216.8467, 13.351),
    [6] = vec3:new(5457.7954, -5860.7734, 19.0936),
    [7] = vec3:new(4855.598, -5561.794, 26.5093),
    [8] = vec3:new(4854.77, -5162.7295, 1.4387),
    [9] = vec3:new(4178.2944, -4357.763, 1.5826),
    [10] = vec3:new(4942.0825, -5168.135, -3.575),
    [11] = vec3:new(4560.804, -4356.775, -7.888),
    [12] = vec3:new(5598.9644, -5604.2393, -6.0489),
    [13] = vec3:new(5264.7236, -4920.671, -2.8715),
    [14] = vec3:new(4944.2183, -4293.736, -6.6942),
    [15] = vec3:new(4560.804, -4356.775, -7.888),
    [16] = vec3:new(3983.0261, -4540.1865, -6.1264),
    [17] = vec3:new(4414.676, -4651.4575, -5.083),
    [18] = vec3:new(4540.07, -4774.899, -3.9321),
    [19] = vec3:new(4777.6006, -5394.6265, -5.0127)
}

local buried_stash_coords = {
    [0] = vec3:new(5579.7026, -5231.42, 14.2512),
    [1] = vec3:new(5481.595, -5855.187, 19.128),
    [2] = vec3:new(5549.2407, -5747.577, 10.427),
    [3] = vec3:new(5295.542, -5587.4307, 61.3964),
    [4] = vec3:new(5136.9844, -5524.6675, 52.7719),
    [5] = vec3:new(4794.91, -5546.516, 21.4945),
    [6] = vec3:new(4895.3125, -5335.3433, 9.0204),
    [7] = vec3:new(4994.968, -5136.416, 1.476),
    [8] = vec3:new(5323.654, -5276.0596, 33.0353),
    [9] = vec3:new(5362.1177, -5170.0854, 28.035),
    [10] = vec3:new(5164.5522, -4706.8384, 1.1632),
    [11] = vec3:new(4888.6104, -4789.4756, 1.4911),
    [12] = vec3:new(4735.3096, -4687.2236, 1.2879),
    [13] = vec3:new(4887.2036, -4630.111, 13.149),
    [14] = vec3:new(4796.803, -4317.4175, 4.3515),
    [15] = vec3:new(4522.936, -4649.638, 10.037),
    [16] = vec3:new(4408.228, -4470.875, 3.3683),
    [17] = vec3:new(4348.7827, -4311.3193, 1.3335),
    [18] = vec3:new(4235.67, -4552.0557, 4.0738),
    [19] = vec3:new(3901.899, -4720.187, 3.4537)
}

local exotic_export_coords_no_parts = {
    [0] = vec3:new(-1297.199, 252.495, 61.813),
    [1] = vec3:new(-1114.101, 479.205, 81.161),
    [2] = vec3:new(-345.267, 662.299, 168.587),
    [3] = vec3:new(-72.605, 902.579, 234.631),
    [4] = vec3:new(-161.232, 274.911, 92.534),
    [5] = vec3:new(-504.323, 424.21, 96.287),
    [6] = vec3:new(-1451.916, 533.495, 118.177),
    [7] = vec3:new(-1979.252, 586.078, 116.479),
    [8] = vec3:new(-1405.117, 81.983, 52.099),
    [9] = vec3:new(-1299.92, -228.464, 59.654),
    [10] = vec3:new(-1409.08, -590.823, 29.317),
    [11] = vec3:new(-1085.162, -476.529, 35.636),
    [12] = vec3:new(-817.325, -1201.59, 5.935),
    [13] = vec3:new(-1873.598, -343.933, 48.26),
    [14] = vec3:new(-1334.625, -1008.972, 6.867),
    [15] = vec3:new(-1043.008, -1010.464, 1.15),
    [16] = vec3:new(-489.189, -596.899, 30.174),
    [17] = vec3:new(-187.144, -175.854, 42.624),
    [18] = vec3:new(871.548, -75.386, 77.764),
    [19] = vec3:new(443.542, 253.197, 102.21),
    [20] = vec3:new(185.595, -1016.005, 28.3),
    [21] = vec3:new(110.261, -714.605, 32.133),
    [22] = vec3:new(-220.102, -590.273, 33.264),
    [23] = vec3:new(-74.575, -619.874, 35.173),
    [24] = vec3:new(283.769, -342.644, 43.92),
    [25] = vec3:new(-237.521, -2059.951, 26.62),
    [26] = vec3:new(-1044.016, -2608.022, 19.775),
    [27] = vec3:new(-801.566, -1313.922, 4.0),
    [28] = vec3:new(-972.578, -1464.273, 4.013),
    [29] = vec3:new(1309.942, -530.154, 70.312),
    [30] = vec3:new(1566.097, -1683.172, 87.205),
    [31] = vec3:new(339.481, 159.143, 102.146),
    [32] = vec3:new(-2316.493, 280.86, 168.467),
    [33] = vec3:new(-3036.574, 105.31, 10.593),
    [34] = vec3:new(-3071.87, 658.171, 9.918),
    [35] = vec3:new(-1534.826, 889.731, 180.803),
    [36] = vec3:new(140.945, 6606.513, 30.845),
    [37] = vec3:new(1362.672, 1178.352, 111.609),
    [38] = vec3:new(1869.749, 2622.154, 44.672),
    [39] = vec3:new(2673.478, 1678.569, 23.488),
    [40] = vec3:new(2593.022, 364.349, 107.457),
    [41] = vec3:new(-1886.248, 2016.572, 139.951),
    [42] = vec3:new(2537.084, -390.048, 91.993),
    [43] = vec3:new(3511.653, 3783.877, 28.925),
    [44] = vec3:new(2002.724, 3769.429, 31.181),
    [45] = vec3:new(-771.927, 5566.46, 32.486),
    [46] = vec3:new(1697.817, 6414.365, 31.73),
    [47] = vec3:new(386.663, 2640.138, 43.493),
    [48] = vec3:new(231.935, 1162.313, 224.464),
    [49] = vec3:new(1700.445, 4937.267, 41.078)
}

local exotic_export_coords_parts = {
    [0] = vec3:new(-582.454, -859.433, 25.034),
    [1] = vec3:new(-604.458, -1218.292, 13.507),
    [2] = vec3:new(-229.587, -1483.435, 30.352),
    [3] = vec3:new(28.385, -1707.341, 28.298),
    [4] = vec3:new(-22.296, -1851.577, 24.108),
    [5] = vec3:new(321.798, -1948.141, 23.627),
    [6] = vec3:new(455.602, -1695.263, 28.289),
    [7] = vec3:new(934.148, -1812.944, 29.812),
    [8] = vec3:new(1228.548, -1605.649, 50.736),
    [9] = vec3:new(-329.7, -700.958, 31.912),
    [10] = vec3:new(238.339, -35.01, 68.728),
    [11] = vec3:new(393.61, -649.557, 27.5),
    [12] = vec3:new(246.847, -1162.082, 28.16),
    [13] = vec3:new(124.231, -1472.496, 28.142),
    [14] = vec3:new(1136.156, -773.997, 56.632),
    [15] = vec3:new(1156.682, -1474.145, 33.693),
    [16] = vec3:new(1028.898, -2405.952, 28.494),
    [17] = vec3:new(-936.334, -2692.07, 15.611),
    [18] = vec3:new(-532.351, -2134.219, 4.992),
    [19] = vec3:new(-1530.625, -993.47, 12.017),
    [20] = vec3:new(-1528.444, -427.05, 34.447),
    [21] = vec3:new(-1640.424, -202.879, 54.146),
    [22] = vec3:new(-552.673, 309.154, 82.191),
    [23] = vec3:new(642.042, 587.747, 127.911),
    [24] = vec3:new(-1804.769, 804.137, 137.514),
    [25] = vec3:new(839.097, 2202.196, 50.46),
    [26] = vec3:new(756.539, 2525.957, 72.161),
    [27] = vec3:new(1205.454, 2658.357, 36.824),
    [28] = vec3:new(1991.707, 3078.063, 46.016),
    [29] = vec3:new(1977.207, 3837.1, 30.997),
    [30] = vec3:new(1350.173, 3601.249, 33.899),
    [31] = vec3:new(1819.042, 4592.234, 35.316),
    [32] = vec3:new(2905.354, 4419.682, 47.541),
    [33] = vec3:new(-472.038, 6034.981, 30.341),
    [34] = vec3:new(-165.839, 6454.25, 30.495),
    [35] = vec3:new(-2221.144, 4232.757, 46.132),
    [36] = vec3:new(-3138.864, 1086.83, 19.669),
    [37] = vec3:new(1546.591, 3781.791, 33.06),
    [38] = vec3:new(2717.772, 1391.725, 23.535),
    [39] = vec3:new(-1144.001, 2666.28, 17.094),
    [40] = vec3:new(-2555.512, 2322.827, 32.06),
    [41] = vec3:new(-2340.763, 296.197, 168.467),
    [42] = vec3:new(1122.086, 267.125, 79.856),
    [43] = vec3:new(629.014, 196.173, 96.128),
    [44] = vec3:new(1150.161, -991.569, 44.528),
    [45] = vec3:new(244.916, -860.606, 28.5),
    [46] = vec3:new(-340.099, -876.452, 30.071),
    [47] = vec3:new(387.275, -215.651, 55.835),
    [48] = vec3:new(-1234.105, -1646.832, 3.129),
    [49] = vec3:new(-1062.018, -226.736, 37.155)
}

local standard_trial_coords = {
    [0] = vec3:new(-1811.675, -1199.5421, 12.0174),
    [1] = vec3:new(-377.166, 1250.8182, 326.4899),
    [2] = vec3:new(-1253.2399, -380.457, 58.2873),
    [3] = vec3:new(2702.0369, 5145.717, 42.8568),
    [4] = vec3:new(1261.3533, -3278.38, 4.8335),
    [5] = vec3:new(-1554.3121, 2755.0088, 16.8004),
    [6] = vec3:new(637.1439, -1845.8552, 8.2676),
    [7] = vec3:new(-552.626, 5042.7026, 127.9448),
    [8] = vec3:new(-579.1157, 5324.664, 69.2662),
    [9] = vec3:new(1067.343, -2448.2366, 28.0683),
    [10] = vec3:new(1577.189, 6439.966, 23.6996),
    [11] = vec3:new(-199.7486, -1973.3108, 26.6204),
    [12] = vec3:new(-1504.541, 1482.4895, 116.053),
    [13] = vec3:new(-1502.0471, 4940.611, 63.8034),
    [14] = vec3:new(947.562, 142.6773, 79.8307),
    [15] = vec3:new(1246.2249, 2685.1099, 36.5944),
    [16] = vec3:new(-1021.1459, -2580.291, 33.6353),
    [17] = vec3:new(231.9767, 3301.4888, 39.5627),
    [18] = vec3:new(860.353, 536.8055, 124.7803),
    [19] = vec3:new(2820.6514, 1642.2759, 23.668),
    [20] = vec3:new(-2257.7986, 4315.927, 44.5551),
    [21] = vec3:new(526.397, 5624.461, 779.3564),
    [22] = vec3:new(175.2847, -3042.0754, 4.7734),
    [23] = vec3:new(813.3556, 1274.9536, 359.511),
    [24] = vec3:new(77.5248, 3629.9146, 38.6907),
    [25] = vec3:new(1004.6567, 898.837, 209.0257),
    [26] = vec3:new(104.8058, -1938.9818, 19.8037),
    [27] = vec3:new(-985.2776, -2698.696, 12.8307),
    [28] = vec3:new(230.6618, -1399.0258, 29.4856),
    [29] = vec3:new(-546.6672, -2857.9282, 5.0004),
    [30] = vec3:new(-172.8944, 1034.8262, 231.2332),
    [31] = vec3:new(1691.4703, -1458.6351, 111.7033)
}

local rc_trial_coords = {
    [0] = vec3:new(-486.1165, -916.59, 22.964),
    [1] = vec3:new(854.8221, -2189.789, 29.679604),
    [2] = vec3:new(-1730.7411, -188.57533, 57.337273),
    [3] = vec3:new(1409.3899, 1084.5609, 113.33391),
    [4] = vec3:new(-901.63, -779.377, 14.859),
    [5] = vec3:new(2562.03, 2707.7473, 41.071),
    [6] = vec3:new(-1194.2417, -1456.5526, 3.379667),
    [7] = vec3:new(-216.2158, -1109.7155, 21.9008),
    [8] = vec3:new(-889.356, -1071.848, 1.163),
    [9] = vec3:new(885.3417, -255.1916, 68.4006),
    [10] = vec3:new(-948.3436, -491.1428, 35.8333),
    [11] = vec3:new(750.3155, 597.0025, 124.9241),
    [12] = vec3:new(-402.4602, -1701.4429, 17.8213),
    [13] = vec3:new(-601.3092, 5295.396, 69.2145)
}

local bike_trial_coords = {
    [0] = vec3:new(501.6576, 5598.3604, 795.1221),
    [1] = vec3:new(493.7987, 5528.249, 777.3241),
    [2] = vec3:new(2820.5623, 5972.031, 349.5339),
    [3] = vec3:new(-1031.3934, 4721.9556, 235.3456),
    [4] = vec3:new(-1932.808, 1782.2681, 172.2726),
    [5] = vec3:new(-182.0154, 319.3242, 96.7999),
    [6] = vec3:new(1100.4553, -264.2758, 68.268),
    [7] = vec3:new(736.0028, 2574.1477, 74.2793),
    [8] = vec3:new(1746.0431, -1474.762, 111.8385),
    [9] = vec3:new(30.5142, 197.473, 104.6073),
    [10] = vec3:new(145.0902, -605.9424, 46.0762),
    [11] = vec3:new(-447.3499, 1600.9911, 357.3483),
    [12] = vec3:new(-2205.15, 199.7418, 173.6018),
    [13] = vec3:new(1321.0515, -505.2507, 70.4208)
}

local ls_tag_coords = {
    [0] = vec3:new(-977.6928, -2639.573, 16.474),
    [1] = vec3:new(819.4288, -2227.2385, 32.6184),
    [2] = vec3:new(37.9683, -1469.2217, 32.235),
    [3] = vec3:new(-768.9666, -1321.6681, 7.1244),
    [4] = vec3:new(1209.1267, -1505.5887, 36.4654),
    [5] = vec3:new(845.3231, -1203.0039, 27.46),
    [6] = vec3:new(188.2855, -1843.3844, 29.2995),
    [7] = vec3:new(182.0389, -941.2879, 32.2661),
    [8] = vec3:new(-501.2574, -684.436, 35.186),
    [9] = vec3:new(-1636.3019, -1063.8951, 15.1266),
    [10] = vec3:new(1165.2151, -314.1255, 71.217),
    [11] = vec3:new(369.5584, -326.8165, 49.145),
    [12] = vec3:new(-942.4161, -343.455, 40.765),
    [13] = vec3:new(-2066, -345.2393, 15.761),
    [14] = vec3:new(-359.6902, 141.5108, 68.5588),
    [15] = vec3:new(2581.005, 487.5057, 110.868),
    [16] = vec3:new(760.227, 583.9885, 128.3567),
    [17] = vec3:new(-481.0848, 1112.5974, 322.24),
    [18] = vec3:new(-1834.4456, 788.6052, 140.539),
    [19] = vec3:new(-3195.2385, 1318.3502, 11.5263),
    [20] = vec3:new(-2557.941, 2302.0186, 34.956),
    [21] = vec3:new(-2219.9644, 4222.4917, 49.078),
    [22] = vec3:new(2469.77, 4082.911, 39.8446),
    [23] = vec3:new(575.3076, 2676.81, 43.712),
    [24] = vec3:new(2741.5925, 3453.4548, 58.443),
    [25] = vec3:new(1928.9758, 3736.5696, 34.514),
    [26] = vec3:new(1723.0552, 4790.159, 43.9136),
    [27] = vec3:new(-756.7117, 5600.3823, 38.6646),
    [28] = vec3:new(1.7607, 6410.2383, 33.779),
    [29] = vec3:new(1411.0867, 3608.7688, 37.0159)
}

local madrazo_hit_coords = {
    [0] = vec3:new(1355.1779, 3600.6501, 33.9761),
    [1] = vec3:new(2258.5862, 3146.8416, 47.7513),
    [2] = vec3:new(2414.5872, 4850.1777, 37.2357),
    [3] = vec3:new(-306.0638, 6248.7246, 30.4665),
    [4] = vec3:new(924.7427, -2066.5093, 29.5178),
    [5] = vec3:new(302.9755, -1860.7911, 25.7811),
    [6] = vec3:new(-592.9996, -882.7405, 24.918),
    [7] = vec3:new(-140.1684, -1534.7019, 33.2548),
    [8] = vec3:new(1317.918, -1614.6876, 51.3666),
    [9] = vec3:new(650.728, -2872.411, 5.057),
    [10] = vec3:new(-3137.5437, 1055.0897, 19.3245),
    [11] = vec3:new(-965.4027, -2608.117, 12.981),
    [12] = vec3:new(219.8501, 284.7484, 104.4699),
    [13] = vec3:new(116.2243, 3401.1082, 36.7988),
    [14] = vec3:new(-559.1921, 175.2093, 67.6451)
}

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

local challenge_times = {
    [0] = "00:40.00",
    [1] = "00:40.00",
    [2] = "00:45.00",
    [3] = "01:25.00",
    [4] = "01:45.00",
    [5] = "01:35.00",
    [6] = "01:10.00",
    [7] = "00:40.00",
    [8] = "02:50.00",
    [9] = "02:50.00",
    [10] = "02:00.00",
    [11] = "01:55.00",
    [12] = "01:25.00",
    [13] = "01:20.00",
    [14] = "02:15.00",
    [15] = "01:30.00",
    [16] = "01:30.00",
    [17] = "01:47.00",
    [18] = "01:40.00",
    [19] = "01:50.00",
    [20] = "01:50.00",
    [21] = "01:35.00",
    [22] = "01:55.00",
    [23] = "01:50.00",
    [24] = "01:25.00"
}

local par_times = {
    [0] = {
        [0] = "01:43.20",
        [1] = "02:04.40",
        [2] = "02:04.90",
        [3] = "00:46.30",
        [4] = "04:09.50",
        [5] = "01:44.00",
        [6] = "00:38.50",
        [7] = "01:10.10",
        [8] = "02:15.00",
        [9] = "02:07.20",
        [10] = "01:41.30",
        [11] = "01:17.80",
        [12] = "00:58.80",
        [13] = "02:29.40",
        [14] = "01:00.00",
        [15] = "01:19.00",
        [16] = "01:43.40",
        [17] = "01:24.20",
        [18] = "02:58.80",
        [19] = "01:26.60",
        [20] = "01:16.60",
        [21] = "00:54.20",
        [22] = "01:40.00",
        [23] = "02:05.00",
        [24] = "02:00.00",
        [25] = "02:35.00",
        [26] = "01:20.00",
        [27] = "02:24.00",
        [28] = "02:16.00",
        [29] = "01:50.00",
        [30] = "01:26.00",
        [31] = "02:10.00"
    },
    [1] = {
        [0] = "01:50.00",
        [1] = "01:30.00",
        [2] = "01:20.00",
        [3] = "01:27.00",
        [4] = "01:10.00",
        [5] = "01:32.00",
        [6] = "02:05.00",
        [7] = "01:12.00",
        [8] = "01:53.00",
        [9] = "01:20.00",
        [10] = "01:23.00",
        [11] = "01:18.00",
        [12] = "01:27.00",
        [13] = "01:22.00"
    },
    [2] = {
        [0] = "02:20.00",
        [1] = "02:00.00",
        [2] = "01:55.00",
        [3] = "01:35.00",
        [4] = "02:10.00",
        [5] = "01:40.00",
        [6] = "02:00.00",
        [7] = "01:50.00",
        [8] = "01:35.00",
        [9] = "01:20.00",
        [10] = "01:50.00",
        [11] = "01:35.00",
        [12] = "02:10.00",
        [13] = "01:50.00"
    }
}

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
    if (coords == nil or ((coords.x + coords.y + coords.z) == 0)) then --Sanity check to make sure we don't send the user to the void if a function fucks up and returns its failure scenario.
        return
    end
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
    	local location = ENTITY.GET_ENTITY_COORDS(self.get_ped(), false)
    	local veh      = VEHICLE.CREATE_VEHICLE(vehicle_joaat, location.x, location.y, location.z, ENTITY.GET_ENTITY_HEADING(self.get_ped()), true, false, false)
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
    if SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(joaat("fm_content_stash_house")) == 0 then
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
    local offset        = globals.get_int(global_one + index) + 1
    local vehicle_joaat = globals.get_uint(global_two + offset)
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

local function set_daily_collectibles_state(state)
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
        stats.set_int("MPX_CBV_DELIVERED_BS", state and 1023 or 0) -- Exotic Exports
        stats.set_int("MPX_CBV_STATE", state and 1 or 0) -- Exotic Exports
    end)
end

local function draw_text(location, text)
    local _, screen_x, screen_y = GRAPHICS.GET_SCREEN_COORD_FROM_WORLD_COORD(location.x, location.y, location.z, screen_x, screen_y)

    HUD.BEGIN_TEXT_COMMAND_DISPLAY_TEXT("STRING")
    HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(text)
    HUD.SET_TEXT_RENDER_ID(1)
    HUD.SET_TEXT_OUTLINE()
    HUD.SET_TEXT_CENTRE(true)
    HUD.SET_TEXT_DROP_SHADOW()
    HUD.SET_TEXT_SCALE(0, 0.3)
    HUD.SET_TEXT_FONT(4)
    HUD.SET_TEXT_COLOUR(255, 255, 255, 240)
    HUD.END_TEXT_COMMAND_DISPLAY_TEXT(screen_x, screen_y, 0)
end

local function draw_esp()
    if esp_gs_cache then
        if not dead_drop_collected then
            local drop_coords = dead_drop_coords[dead_drop_area][dead_drop_loc] or vec3:new(0, 0, 0)
            draw_text(drop_coords, "G's Cache")
        end
    end
	
    if esp_stash_house then
        if not stash_house_raided then
            if HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(845)) then
                local house_coords = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(845))
                draw_text(house_coords, "Stash House")
            end
        end
    end	
    
    if esp_street_dealers then
        local dealer_coords = street_dealer_coords[street_dealer_loc[selected_dealer]] or vec3:new(0, 0, 0)
        draw_text(dealer_coords, "Street Dealer " .. selected_dealer + 1)
    end
    
    if esp_shipwreck then
        if not shipwrecked_collected then
            local shipwreck_coords = shipwrecked_coords[shipwrecked_loc] or vec3:new(0, 0, 0)
            draw_text(shipwreck_coords, "Shipwreck")
        end
    end
    
    if esp_hidden_cache then
        if not hidden_cache_collected[selected_cache + 1] then
            local cache_coords = hidden_cache_coords[hidden_cache_loc[selected_cache + 1]] or vec3:new(0, 0, 0)
            draw_text(cache_coords, "Hidden Cache " .. selected_cache + 1)
        end
    end
    
    if esp_treasure_chest then
        if not treasure_chest_collected[selected_treasure + 1] then
            local chest_coords = treasure_chest_coords[treasure_chest_loc[selected_treasure + 1]] or vec3:new(0, 0, 0)
            draw_text(chest_coords, "Treasure Chest " .. selected_treasure + 1)
        end
    end
    
    if esp_buried_stash then
        if not buried_stash_collected[selected_stash + 1] then
            local stash_coords = buried_stash_coords[buried_stash_loc[selected_stash + 1]] or vec3:new(0, 0, 0)
            draw_text(stash_coords, "Buried Stash " .. selected_stash + 1)
        end
    end
    
    if esp_exotic_vehicle then
        if vehicle_bitset ~= 1023 then
            if vehicle_location ~= -1 then
                local vehicle_coords = nil
                if is_second_part(globals.get_uint(global_two + vehicle_order)) then
                    vehicle_coords = exotic_export_coords_no_parts[vehicle_location]
                else
                    vehicle_coords = exotic_export_coords_parts[vehicle_location]
                end
                if vehicle_coords then 
                    draw_text(vehicle_coords, "Exotic Exports Vehicle")
                end
            end
        end
    end
    
    if esp_ls_tag then
        if not ls_tag_sprayed[selected_tag + 1] then
            local tag_coords = ls_tag_coords[ls_tag_loc[selected_tag + 1]]
            if( tag_coords ~= nil ) then
                draw_text(tag_coords, "LS Tag " .. selected_tag + 1)
            end
        end
    end    
    
    if esp_madrazo_hit then
        if not hit_completed then
            local hit_coords = madrazo_hit_coords[hit_loc]
            if hit_coords ~= nil then
                draw_text(hit_coords, "Madrazo Hit")
            end
        end
    end
end

script.register_looped("Daily Collectibles", function()
    daily_obj[1]                = globals.get_int(current_objectives_global + (1 + (0 * current_objectives_global_offset)) + 681 + 4244 + (1 + (0 * 3)))
    daily_obj[2]                = globals.get_int(current_objectives_global + (1 + (0 * current_objectives_global_offset)) + 681 + 4244 + (1 + (1 * 3)))
    daily_obj[3]                = globals.get_int(current_objectives_global + (1 + (0 * current_objectives_global_offset)) + 681 + 4244 + (1 + (2 * 3)))
    street_dealer_loc[0]        = globals.get_int(global_three + global_three_offset_one + 1 + (0 * 7))
    street_dealer_loc[1]        = globals.get_int(global_three + global_three_offset_one + 1 + (1 * 7))
    street_dealer_loc[2]        = globals.get_int(global_three + global_three_offset_one + 1 + (2 * 7))
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
    hit_loc                     = globals.get_int(global_three + 6838)
    vehicle_location            = globals.get_int(global_four + 302 + 1)
    vehicle_index               = globals.get_int(global_four + 302)
    vehicle_order               = (globals.get_int(global_one + vehicle_index + 1) + 1)
    active_vehicle              = globals.get_uint(global_three + global_three_offset_two + 3)
    exotic_order_cooldown       = globals.get_int(global_five + global_five_offset)
    time_trial_loc[2]           = locals.get_int("freemode", freemode_local_one)
    time_trial_loc[3]           = locals.get_int("freemode", freemode_local_two + 3)
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
    ls_tag_loc[1]               = stats.get_packed_stat_int(51546)
    ls_tag_loc[2]               = stats.get_packed_stat_int(51547)
    ls_tag_loc[3]               = stats.get_packed_stat_int(51548)
    ls_tag_loc[4]               = stats.get_packed_stat_int(51549)
    ls_tag_loc[5]               = stats.get_packed_stat_int(51550)
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
    -- TO-DO: Remove these when LS Tags & Madrazo Hits are officially released
    tunables.set_bool(-2022924242, true)
    tunables.set_bool(-676725789, true)    
    draw_esp()
end)

daily_collectibles_tab:add_imgui(function()
    local hours, minutes, seconds = get_daily_reset_time()
    
    ImGui.Text(string.format("Daily Reset Time (6 AM UTC): %02d:%02d:%02d", hours, minutes, seconds))
	
    if ImGui.Button("Reset All Daily Collectibles") then
        set_daily_collectibles_state(false)
        gui.show_message("Daily Collectibles", "All Daily Collectibles have been reset.")
    end
    
    if ImGui.Button("Complete All Daily Collectibles") then
        set_daily_collectibles_state(true)
        gui.show_message("Daily Collectibles", "All Daily Collectibles have been completed.")
    end
    
    ImGui.Text("Switch session to apply the changes.")
end)

challenges_tab:add_imgui(function()
    if ImGui.TreeNode("Daily Challenges") then
        if daily_obj[1] or daily_obj[2] or daily_obj[3] then
        	ImGui.Text(daily_challenges[daily_obj[1] + 1])
        	ImGui.Text(daily_challenges[daily_obj[2] + 1])
        	ImGui.Text(daily_challenges[daily_obj[3] + 1])
        end
        ImGui.TreePop()
    end
    
    if ImGui.TreeNode("Weekly Challenge") then
        if weekly_obj_id then
            ImGui.Text(weekly_challenges[weekly_obj_id + 1])
            ImGui.Text("Override: " .. weekly_obj_override)
        end
        ImGui.TreePop()
    end
    
    if ImGui.Button("Complete all Challenges") then
        for i = 0, 2 do --Unlock all daily rewards.
            local objective = globals.get_int(current_objectives_global + (1 + (0 * current_objectives_global_offset)) + 681 + 4244 + (1 + (i * 3)))
            globals.set_int(objectives_state_global + 1 + (1 + (i * 1)), objective)
        end
        globals.set_int(objectives_state_global, 1)
        globals.set_int(weekly_objectives_global + (1 + (0 * 6)) + 1, globals.get_int(weekly_objectives_global + (1 + (0 * 6)) + 2)) --Unlock Weekly Objective
    end
end)

dead_drop_tab:add_imgui(function()
    ImGui.Text("Status: " .. (dead_drop_collected and "collected" or "ready"))
    
    if ImGui.Button("Teleport") then
        if not dead_drop_collected then
			teleport(dead_drop_coords[dead_drop_area][dead_drop_loc] or vec3:new(0, 0, 0))
        else
            gui.show_message("Daily Collectibles", "G's Cache has already been collected.")
        end
    end
    
    ImGui.SameLine()
    esp_gs_cache = ImGui.Checkbox("Draw ESP", esp_gs_cache)
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
    esp_stash_house = ImGui.Checkbox("Draw ESP", esp_stash_house)
    
    if ImGui.Button("Enter Safe Combination") then
        for i = 0, 2, 1 do
            local safe_combination = locals.get_int("fm_content_stash_house", stash_house_local_two + 22 + (1 + (i * 2)) + 1)
            locals.set_float("fm_content_stash_house", stash_house_local_two + 22 + (1 + (i * 2)), safe_combination)
        end
    end
end)

street_dealer_tab:add_imgui(function()
    selected_dealer = ImGui.Combo("Select Dealer", selected_dealer, { "1", "2", "3" }, 3)
    
    if ImGui.Button("Teleport") then
        teleport(street_dealer_coords[street_dealer_loc[selected_dealer]] or vec3:new(0, 0, 0))
    end
    
    ImGui.SameLine()
    
    esp_street_dealers = ImGui.Checkbox("Draw ESP", esp_street_dealers)
    
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
            teleport(shipwrecked_coords[shipwrecked_loc] or vec3:new(0, 0, 0))
        else
            gui.show_message("Daily Collectibles", "Shipwreck has already been collected.")
        end
    end

    ImGui.SameLine()
    esp_shipwreck = ImGui.Checkbox("Draw ESP", esp_shipwreck)
end)

hidden_cache_tab:add_imgui(function()
    ImGui.Text("Status: " .. (hidden_cache_collected[selected_cache + 1] and "collected" or "ready"))
    
    selected_cache = ImGui.Combo("Select Cache", selected_cache, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, 10)
    
    if ImGui.Button("Teleport") then
        if not hidden_cache_collected[selected_cache + 1] then
            teleport(hidden_cache_coords[hidden_cache_loc[selected_cache + 1]] or vec3:new(0, 0, 0))
        else
            gui.show_message("Daily Collectibles", "Hidden Cache has already been collected.")
        end
    end

    ImGui.SameLine()
    esp_hidden_cache = ImGui.Checkbox("Draw ESP", esp_hidden_cache)
end)

junk_skydive_tab:add_imgui(function()
    ImGui.Text("Challenge Time: " .. challenge_times[junk_skydive_loc[selected_skydive + 1]])
    
    selected_skydive = ImGui.Combo("Select Skydive", selected_skydive, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, 10)
    
    if ImGui.Button("Teleport") then
        teleport(junk_skydive_coords[junk_skydive_loc[selected_skydive + 1]] or vec3:new(0, 0, 0))
    end
end)

treasure_chest_tab:add_imgui(function()
    ImGui.Text("Status: " .. (treasure_chest_collected[selected_treasure + 1] and "collected" or "ready"))
    
    selected_treasure = ImGui.Combo("Select Treasure", selected_treasure, { "1", "2" }, 2)
    
    if ImGui.Button("Teleport") then
        if not treasure_chest_collected[selected_treasure + 1] then
            teleport(treasure_chest_coords[treasure_chest_loc[selected_treasure + 1]] or vec3:new(0, 0, 0))
        else
            gui.show_message("Daily Collectibles", "Treasure Chest has already been collected.")
        end
    end

    ImGui.SameLine()
    esp_treasure_chest = ImGui.Checkbox("Draw ESP", esp_treasure_chest)
end)

buried_stash_tab:add_imgui(function()
    ImGui.Text("Status: " .. (buried_stash_collected[selected_stash + 1] and "collected" or "ready"))
    
    selected_stash = ImGui.Combo("Select Stash", selected_stash, { "1", "2" }, 2)
    
    if ImGui.Button("Teleport") then
        if not buried_stash_collected[selected_stash + 1] then
            teleport(buried_stash_coords[buried_stash_loc[selected_stash + 1]] or vec3:new(0, 0, 0))
        else
            gui.show_message("Daily Collectibles", "Buried Stash has already been collected.")
        end
    end

    ImGui.SameLine()
    esp_buried_stash = ImGui.Checkbox("Draw ESP", esp_buried_stash)
end)

exotic_exports_tab:add_imgui(function()
    ImGui.Text("Reward Ready: " .. (exotic_reward_ready and "Yes" or "No"))
        
    if ImGui.Button("Teleport to Vehicle") then
        if vehicle_bitset ~= 1023 then
            if vehicle_location ~= -1 then
                local vehicle_coords = nil
                if is_second_part(globals.get_uint(global_two + vehicle_order)) then
                    vehicle_coords = exotic_export_coords_no_parts[vehicle_location]
                else
                    vehicle_coords = exotic_export_coords_parts[vehicle_location]
                end
                teleport(vehicle_coords)
            else
                gui.show_message("Daily Collectibles", "Please wait until the next vehicle is spawned (90 seconds).")
            end
        else
            gui.show_message("Daily Collectibles", "You have already delivered all the vehicles.")
        end
    end

    ImGui.SameLine()
    esp_exotic_vehicle = ImGui.Checkbox("Draw ESP", esp_exotic_vehicle)
    
    if ImGui.Button("Deliver Vehicle") then
        if vehicle_bitset ~= 1023 then
            if not exotic_reward_ready then
                gui.show_message("Daily Collectibles", "You have just delivered a vehicle. Wait a moment.")
            else
                script.run_in_fiber(function()
                    if PLAYER.GET_PLAYER_WANTED_LEVEL(self.get_id()) ~= 0 then
                        gui.show_message("Daily Collectibles", "Lose your wanted level.")
                    elseif HUD.DOES_BLIP_EXIST(HUD.GET_FIRST_BLIP_INFO_ID(780)) then
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
                if not has_bit_set(vehicle_bitset, globals.get_int(global_one + i)) then
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

time_trials_tab:add_imgui(function()
    ImGui.Text("Par Time: " .. par_times[selected_trial][time_trial_loc[selected_trial + 1]])
    
    selected_trial = ImGui.Combo("Select Variant", selected_trial, { "Standard Time Trial", "RC Bandito Time Trial", "Junk Energy Bike Time Trial" }, 3)
    
    if ImGui.Button("Teleport") then
        if selected_trial == 0 then teleport(standard_trial_coords[time_trial_loc[1]])
        elseif selected_trial == 1 then teleport(rc_trial_coords[time_trial_loc[2]])
        elseif selected_trial == 2 then teleport(bike_trial_coords[time_trial_loc[3]])
        end
    end
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
            teleport(ls_tag_coords[ls_tag_loc[selected_tag + 1]])
        else
            gui.show_message("Daily Collectibles", "LS Tag has already been sprayed.")
        end
    end
    
    ImGui.SameLine()
    esp_ls_tag = ImGui.Checkbox("Draw ESP", esp_ls_tag)
end)

madrazo_hits_tab:add_imgui(function()
    ImGui.Text("Status: " .. (hit_completed and "completed" or "ready"))
    
    if ImGui.Button("Teleport") then
        if not hit_completed then
            teleport(madrazo_hit_coords[hit_loc])
        else
            gui.show_message("Daily Collectibles", "Madrazo Hit has already been completed.")
        end
    end

    ImGui.SameLine()
    esp_madrazo_hit = ImGui.Checkbox("Draw ESP", esp_madrazo_hit)
end)