LANGUAGE = "en"

REQUIRED_POLICE = 0

MAX_SELL = 7    -- MAX AMOUNT OF DRUG SOLD AT ONCE

REPUTATION_LOSS = 2 -- AMOUNT OF REPUTATION POINTS LOST
REPUTATION_LOSS_TIMER = 60*60000 -- DELAY BETWEEN 2 REPUTATION POINTS LOST

POL_ALERT_TIME = 30 * 1000  -- 30 seconds
POL_ALERT_SPRITE = 51      -- radar_crim_drugs
POL_ALERT_COLOR = 1         -- Red
POL_ALERT_WAVE = true       -- Enables the blip wave.

PERCENTAGES_ADV = { -- BE SURE TO NEVER GO OVER A TOTAL OF 100
    COPS = 20,
    GANG = 30,
    DENY = 0
}

PERCENTAGES_OWN = { -- BE SURE TO NEVER GO OVER A TOTAL OF 100
    COPS = 20,
    DENY = 20
}

PERCENTAGES_OUT = { -- BE SURE TO NEVER GO OVER A TOTAL OF 100
    COPS = 30,
    DENY = 25
}

TURF_MULTIPLIER = 1.5 -- 1 = 100%

DRUGS = { -- Item prices for sell
    ["weed"] = 91,
    ["meth"] = 200,
}

GANG_COLORS = {
    neutral = "white", -- DEFAULT TURF GANG, WHEN NO REAL GANG HAS REPUTATION, 
    vagos = "yellow",
    ballas = "purple"
}

TURFS = {
    DEL_PERRO = {
        Polygon = {
            vector2(-2240.08, -367.21),
            vector2(-2068.57, -32.42),
            vector2(-1557.0, -184.18),
            vector2(-1083.4, -761.62),
            vector2(-1779.0, -1349.0),
            vector2(-1930.0, -1245.0)
        }
    },
    VINEWOOD = {
        Polygon = {
            vector2(593.9, 248.8),
            vector2(429.26, -120.44),
            vector2(-57.38, 48.9),
            vector2(21.8, 270.4),
            vector2(67.86, 328.24),
            vector2(170.21, 378.01),
            vector2(421.87, 315.1)
        }
    },
    MIRROR = {
        Polygon = {
            vector2(836.86, -536.5),
            vector2(1244.39, -293.01),
            vector2(1428.18, -573.14),
            vector2(1233.37, -789.78),
            vector2(1028.39, -797.16)
        }
    },
    VESPUCCI = {
        Polygon = {
            vector2(-1242.48, -1850.23),
            vector2(-1771.62, -1357.38),
            vector2(-1080.35, -763.2),
            vector2(-946.93, -841.41),
            vector2(-627.78, -1376.37)
        }
    },

    LITTLE_SEOUL = {
        Polygon = {
            vector2(-649.12, -1259.53),
            vector2(-929.71, -831.04),
            vector2(-437.15, -843.93),
            vector2(-437.43, -1235.37)
        }
    },

    CYPRESS_FLATS = {
        Polygon = {
            vector2(1321.54, -2274.51),
            vector2(1318.5, -2437.57),
            vector2(1175.57, -2548.43),
            vector2(613.39, -2547.27),
            vector2(681.98, -1728.87),
            vector2(1103.73, -1734.91)
        }
    }
}