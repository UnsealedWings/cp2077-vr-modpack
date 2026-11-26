local Suspension = {}

local CAR_SPECS_25 = {
    { match = "mt28",           refMass = 9200.0, minMass = 7000.0, wheels = 6, dualRear = true,  minFreq = 0.96, maxFreq = 1.10, stiffMul = 1.02, bumpZeta = 0.40, rebZeta = 0.80, lowBumpZeta = 0.62, lowRebZeta = 0.96, swayMul = 1.06, antiSway = 0.95, maxWheelMass = 25.0, extremeComp = 0.10, compAdd = 0.00 },
    { match = "coach",          refMass = 9200.0, minMass = 7000.0, wheels = 6, dualRear = true,  minFreq = 0.96, maxFreq = 1.10, stiffMul = 1.02, bumpZeta = 0.40, rebZeta = 0.80, lowBumpZeta = 0.62, lowRebZeta = 0.96, swayMul = 1.06, antiSway = 0.95, maxWheelMass = 25.0, extremeComp = 0.10, compAdd = 0.00 },
    { match = "behemoth",       refMass = 8500.0, minMass = 6500.0, wheels = 6, dualRear = true,  minFreq = 0.98, maxFreq = 1.12, stiffMul = 1.02, bumpZeta = 0.40, rebZeta = 0.78, lowBumpZeta = 0.60, lowRebZeta = 0.95, swayMul = 1.05, antiSway = 0.94, maxWheelMass = 24.0, extremeComp = 0.10, compAdd = 0.00 },
    { match = "bratsk",         refMass = 7800.0, minMass = 6000.0, wheels = 6, dualRear = true,  minFreq = 0.98, maxFreq = 1.12, stiffMul = 1.02, bumpZeta = 0.40, rebZeta = 0.78, lowBumpZeta = 0.60, lowRebZeta = 0.95, swayMul = 1.05, antiSway = 0.94, maxWheelMass = 24.0, extremeComp = 0.10, compAdd = 0.00 },
    { match = "u4020",          refMass = 7800.0, minMass = 6000.0, wheels = 6, dualRear = true,  minFreq = 0.98, maxFreq = 1.12, stiffMul = 1.02, bumpZeta = 0.40, rebZeta = 0.78, lowBumpZeta = 0.60, lowRebZeta = 0.95, swayMul = 1.05, antiSway = 0.94, maxWheelMass = 24.0, extremeComp = 0.10, compAdd = 0.00 },
    { match = "flatbed",        refMass = 7200.0, minMass = 5500.0, wheels = 6, dualRear = true,  minFreq = 0.98, maxFreq = 1.12, stiffMul = 1.00, bumpZeta = 0.40, rebZeta = 0.78, lowBumpZeta = 0.58, lowRebZeta = 0.94, swayMul = 1.04, antiSway = 0.92, maxWheelMass = 24.0, extremeComp = 0.10, compAdd = 0.00 },
    { match = "hellhound",      refMass = 4600.0, minMass = 3800.0, wheels = 4,                   minFreq = 1.02, maxFreq = 1.16, stiffMul = 1.00, bumpZeta = 0.39, rebZeta = 0.78, lowBumpZeta = 0.58, lowRebZeta = 0.94, swayMul = 1.04, antiSway = 0.92, maxWheelMass = 22.0, extremeComp = 0.10, compAdd = 0.00 },
    { match = "zeya",           refMass = 4200.0, minMass = 3400.0, wheels = 4,                   minFreq = 1.00, maxFreq = 1.14, stiffMul = 1.00, bumpZeta = 0.39, rebZeta = 0.78, lowBumpZeta = 0.58, lowRebZeta = 0.94, swayMul = 1.02, antiSway = 0.92, maxWheelMass = 22.0, extremeComp = 0.10, compAdd = 0.00 },
    { match = "u420",           refMass = 4200.0, minMass = 3400.0, wheels = 4,                   minFreq = 1.00, maxFreq = 1.14, stiffMul = 1.00, bumpZeta = 0.39, rebZeta = 0.78, lowBumpZeta = 0.58, lowRebZeta = 0.94, swayMul = 1.02, antiSway = 0.92, maxWheelMass = 22.0, extremeComp = 0.10, compAdd = 0.00 },
    { match = "2ty",            refMass = 4000.0, minMass = 3300.0, wheels = 4,                   minFreq = 1.00, maxFreq = 1.14, stiffMul = 1.00, bumpZeta = 0.39, rebZeta = 0.78, lowBumpZeta = 0.58, lowRebZeta = 0.94, swayMul = 1.02, antiSway = 0.92, maxWheelMass = 22.0, extremeComp = 0.10, compAdd = 0.00 },
    { match = "legatus",        refMass = 3850.0, minMass = 3200.0, wheels = 4,                   minFreq = 1.04, maxFreq = 1.18, stiffMul = 1.00, bumpZeta = 0.38, rebZeta = 0.76, lowBumpZeta = 0.58, lowRebZeta = 0.92, swayMul = 1.02, antiSway = 0.92, maxWheelMass = 22.0, extremeComp = 0.11, compAdd = 0.00 },
    { match = "aquila",         refMass = 3850.0, minMass = 3200.0, wheels = 4,                   minFreq = 1.04, maxFreq = 1.18, stiffMul = 1.00, bumpZeta = 0.38, rebZeta = 0.76, lowBumpZeta = 0.58, lowRebZeta = 0.92, swayMul = 1.02, antiSway = 0.92, maxWheelMass = 22.0, extremeComp = 0.11, compAdd = 0.00 },
    { match = "centurion",      refMass = 3650.0, minMass = 3000.0, wheels = 4, dualRear = true,  minFreq = 1.02, maxFreq = 1.16, stiffMul = 1.00, bumpZeta = 0.38, rebZeta = 0.76, lowBumpZeta = 0.58, lowRebZeta = 0.93, swayMul = 1.02, antiSway = 0.91, maxWheelMass = 22.0, extremeComp = 0.11, compAdd = 0.00 },
    { match = "demiurge",       refMass = 3650.0, minMass = 3000.0, wheels = 4,                   minFreq = 1.00, maxFreq = 1.14, stiffMul = 0.98, bumpZeta = 0.40, rebZeta = 0.80, lowBumpZeta = 0.62, lowRebZeta = 0.96, swayMul = 1.05, antiSway = 0.94, maxWheelMass = 22.0, extremeComp = 0.10, compAdd = 0.00 },

    { match = "ironclad",       refMass = 3350.0, minMass = 2850.0, wheels = 4,                   minFreq = 1.04, maxFreq = 1.18, stiffMul = 0.98, bumpZeta = 0.38, rebZeta = 0.77, lowBumpZeta = 0.58, lowRebZeta = 0.93, swayMul = 1.00, antiSway = 0.91, maxWheelMass = 21.5, extremeComp = 0.11, compAdd = 0.00 },
    { match = "dominator",      refMass = 3200.0, minMass = 2750.0, wheels = 4,                   minFreq = 1.04, maxFreq = 1.18, stiffMul = 0.97, bumpZeta = 0.38, rebZeta = 0.76, lowBumpZeta = 0.57, lowRebZeta = 0.92, swayMul = 0.99, antiSway = 0.90, maxWheelMass = 21.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "ragnar",         refMass = 3050.0, minMass = 2600.0, wheels = 4,                   minFreq = 1.04, maxFreq = 1.18, stiffMul = 0.96, bumpZeta = 0.38, rebZeta = 0.76, lowBumpZeta = 0.56, lowRebZeta = 0.92, swayMul = 0.98, antiSway = 0.90, maxWheelMass = 21.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "emperor",        refMass = 3050.0, minMass = 2600.0, wheels = 4,                   minFreq = 1.04, maxFreq = 1.18, stiffMul = 0.96, bumpZeta = 0.38, rebZeta = 0.76, lowBumpZeta = 0.56, lowRebZeta = 0.92, swayMul = 0.98, antiSway = 0.90, maxWheelMass = 21.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "warlock",        refMass = 2850.0, minMass = 2400.0, wheels = 4,                   minFreq = 1.04, maxFreq = 1.18, stiffMul = 0.96, bumpZeta = 0.38, rebZeta = 0.75, lowBumpZeta = 0.56, lowRebZeta = 0.90, swayMul = 0.98, antiSway = 0.90, maxWheelMass = 21.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "merrimac",       refMass = 2800.0, minMass = 2400.0, wheels = 4,                   minFreq = 1.04, maxFreq = 1.18, stiffMul = 0.96, bumpZeta = 0.38, rebZeta = 0.75, lowBumpZeta = 0.56, lowRebZeta = 0.90, swayMul = 0.98, antiSway = 0.90, maxWheelMass = 21.0, extremeComp = 0.12, compAdd = 0.00 },

    { match = "mackinaw_ncu",   refMass = 2620.0, minMass = 2250.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.95, bumpZeta = 0.38, rebZeta = 0.76, lowBumpZeta = 0.56, lowRebZeta = 0.92, swayMul = 0.96, antiSway = 0.90, maxWheelMass = 20.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "beast",          refMass = 2620.0, minMass = 2250.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.95, bumpZeta = 0.38, rebZeta = 0.76, lowBumpZeta = 0.56, lowRebZeta = 0.92, swayMul = 0.96, antiSway = 0.90, maxWheelMass = 20.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "saguaro",        refMass = 2580.0, minMass = 2250.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.95, bumpZeta = 0.38, rebZeta = 0.76, lowBumpZeta = 0.56, lowRebZeta = 0.92, swayMul = 0.96, antiSway = 0.90, maxWheelMass = 20.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "warhorse",       refMass = 2550.0, minMass = 2200.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.95, bumpZeta = 0.38, rebZeta = 0.76, lowBumpZeta = 0.56, lowRebZeta = 0.92, swayMul = 0.96, antiSway = 0.90, maxWheelMass = 20.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "larimore",       refMass = 2520.0, minMass = 2180.0, wheels = 4,                   minFreq = 1.05, maxFreq = 1.20, stiffMul = 0.94, bumpZeta = 0.37, rebZeta = 0.75, lowBumpZeta = 0.55, lowRebZeta = 0.90, swayMul = 0.95, antiSway = 0.90, maxWheelMass = 20.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "mtl1",           refMass = 2480.0, minMass = 2150.0, wheels = 4,                   minFreq = 1.05, maxFreq = 1.20, stiffMul = 0.94, bumpZeta = 0.37, rebZeta = 0.75, lowBumpZeta = 0.55, lowRebZeta = 0.90, swayMul = 0.95, antiSway = 0.90, maxWheelMass = 20.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "mackinaw",       refMass = 2480.0, minMass = 2150.0, wheels = 4,                   minFreq = 1.05, maxFreq = 1.20, stiffMul = 0.94, bumpZeta = 0.37, rebZeta = 0.75, lowBumpZeta = 0.55, lowRebZeta = 0.90, swayMul = 0.95, antiSway = 0.90, maxWheelMass = 20.0, extremeComp = 0.12, compAdd = 0.00 },

    { match = "herman",         refMass = 2650.0, minMass = 2280.0, wheels = 6, dualFront = true, minFreq = 1.04, maxFreq = 1.18, stiffMul = 0.93, bumpZeta = 0.37, rebZeta = 0.75, lowBumpZeta = 0.55, lowRebZeta = 0.90, swayMul = 0.94, antiSway = 0.89, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "vato",           refMass = 2520.0, minMass = 2200.0, wheels = 6, dualFront = true, minFreq = 1.05, maxFreq = 1.20, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.54, lowRebZeta = 0.88, swayMul = 0.92, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.01 },
    { match = "playboy",        refMass = 2500.0, minMass = 2180.0, wheels = 6, dualFront = true, minFreq = 1.05, maxFreq = 1.20, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.54, lowRebZeta = 0.88, swayMul = 0.92, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.01 },
    { match = "delegate",       refMass = 2550.0, minMass = 2200.0, wheels = 6, dualFront = true, minFreq = 1.05, maxFreq = 1.20, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.54, lowRebZeta = 0.88, swayMul = 0.92, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.01 },
    { match = "alvarado",       refMass = 2550.0, minMass = 2200.0, wheels = 6, dualFront = true, minFreq = 1.05, maxFreq = 1.20, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.54, lowRebZeta = 0.88, swayMul = 0.92, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.01 },

    { match = "trailbruiser",   refMass = 2550.0, minMass = 2150.0, wheels = 4,                   minFreq = 1.05, maxFreq = 1.20, stiffMul = 0.95, bumpZeta = 0.38, rebZeta = 0.76, lowBumpZeta = 0.58, lowRebZeta = 0.92, swayMul = 0.98, antiSway = 0.92, maxWheelMass = 20.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "supron",         refMass = 2200.0, minMass = 1900.0, wheels = 4,                   minFreq = 1.05, maxFreq = 1.20, stiffMul = 0.94, bumpZeta = 0.37, rebZeta = 0.75, lowBumpZeta = 0.56, lowRebZeta = 0.90, swayMul = 0.96, antiSway = 0.90, maxWheelMass = 20.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "sea_dragon",     refMass = 2380.0, minMass = 2020.0, wheels = 4,                   minFreq = 1.04, maxFreq = 1.18, stiffMul = 0.94, bumpZeta = 0.37, rebZeta = 0.75, lowBumpZeta = 0.56, lowRebZeta = 0.90, swayMul = 0.96, antiSway = 0.90, maxWheelMass = 20.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "columbus",       refMass = 2350.0, minMass = 2000.0, wheels = 4,                   minFreq = 1.04, maxFreq = 1.18, stiffMul = 0.94, bumpZeta = 0.37, rebZeta = 0.75, lowBumpZeta = 0.56, lowRebZeta = 0.90, swayMul = 0.96, antiSway = 0.90, maxWheelMass = 20.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "camper",         refMass = 2080.0, minMass = 1820.0, wheels = 4,                   minFreq = 1.05, maxFreq = 1.20, stiffMul = 0.94, bumpZeta = 0.37, rebZeta = 0.75, lowBumpZeta = 0.56, lowRebZeta = 0.90, swayMul = 0.96, antiSway = 0.90, maxWheelMass = 19.5, extremeComp = 0.12, compAdd = 0.00 },
    { match = "c210",           refMass = 2080.0, minMass = 1820.0, wheels = 4,                   minFreq = 1.05, maxFreq = 1.20, stiffMul = 0.94, bumpZeta = 0.37, rebZeta = 0.75, lowBumpZeta = 0.56, lowRebZeta = 0.90, swayMul = 0.96, antiSway = 0.90, maxWheelMass = 19.5, extremeComp = 0.12, compAdd = 0.00 },

    { match = "hammer_drill",   refMass = 2520.0, minMass = 2150.0, wheels = 4,                   minFreq = 1.06, maxFreq = 1.22, stiffMul = 0.94, bumpZeta = 0.37, rebZeta = 0.74, lowBumpZeta = 0.55, lowRebZeta = 0.90, swayMul = 0.94, antiSway = 0.89, maxWheelMass = 20.5, extremeComp = 0.12, compAdd = 0.00 },
    { match = "fire_fang",      refMass = 2480.0, minMass = 2120.0, wheels = 4,                   minFreq = 1.06, maxFreq = 1.22, stiffMul = 0.94, bumpZeta = 0.37, rebZeta = 0.74, lowBumpZeta = 0.55, lowRebZeta = 0.90, swayMul = 0.94, antiSway = 0.89, maxWheelMass = 20.5, extremeComp = 0.12, compAdd = 0.00 },
    { match = "decurion",       refMass = 2450.0, minMass = 2100.0, wheels = 4,                   minFreq = 1.06, maxFreq = 1.22, stiffMul = 0.93, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.54, lowRebZeta = 0.89, swayMul = 0.93, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "jefferson",      refMass = 2350.0, minMass = 2000.0, wheels = 4,                   minFreq = 1.06, maxFreq = 1.22, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.73, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.92, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.01 },
    { match = "thrax",          refMass = 2350.0, minMass = 2000.0, wheels = 4,                   minFreq = 1.06, maxFreq = 1.22, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.73, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.92, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.01 },

    { match = "aerondight",     refMass = 2120.0, minMass = 1850.0, wheels = 4,                   minFreq = 1.15, maxFreq = 1.32, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.73, lowBumpZeta = 0.52, lowRebZeta = 0.86, swayMul = 0.92, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.01 },
    { match = "guinevere",      refMass = 2120.0, minMass = 1850.0, wheels = 4,                   minFreq = 1.15, maxFreq = 1.32, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.73, lowBumpZeta = 0.52, lowRebZeta = 0.86, swayMul = 0.92, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.01 },
    { match = "overlord",       refMass = 2280.0, minMass = 1950.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.54, lowRebZeta = 0.88, swayMul = 0.92, antiSway = 0.89, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "delamain",       refMass = 2080.0, minMass = 1780.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.72, lowBumpZeta = 0.52, lowRebZeta = 0.86, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "valor",          refMass = 2020.0, minMass = 1750.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.72, lowBumpZeta = 0.52, lowRebZeta = 0.86, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "cortes",         refMass = 2020.0, minMass = 1750.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.72, lowBumpZeta = 0.52, lowRebZeta = 0.86, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },

    { match = "kuma",           refMass = 1420.0, minMass = 1200.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.92, bumpZeta = 0.37, rebZeta = 0.76, lowBumpZeta = 0.56, lowRebZeta = 0.92, swayMul = 0.94, antiSway = 0.90, maxWheelMass = 18.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "tanishi",        refMass = 1350.0, minMass = 1150.0, wheels = 4,                   minFreq = 1.06, maxFreq = 1.22, stiffMul = 0.92, bumpZeta = 0.37, rebZeta = 0.76, lowBumpZeta = 0.56, lowRebZeta = 0.92, swayMul = 0.94, antiSway = 0.90, maxWheelMass = 18.0, extremeComp = 0.12, compAdd = 0.00 },
    { match = "weiler",         refMass = 1980.0, minMass = 1750.0, wheels = 4,                   minFreq = 1.20, maxFreq = 1.38, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.72, lowBumpZeta = 0.50, lowRebZeta = 0.85, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "outlaw",         refMass = 1820.0, minMass = 1600.0, wheels = 4,                   minFreq = 1.20, maxFreq = 1.38, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "vindicator",     refMass = 1800.0, minMass = 1550.0, wheels = 4,                   minFreq = 1.18, maxFreq = 1.35, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "deleon",         refMass = 1760.0, minMass = 1550.0, wheels = 4,                   minFreq = 1.16, maxFreq = 1.34, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.70, lowBumpZeta = 0.49, lowRebZeta = 0.83, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },

    { match = "vigilante",      refMass = 1850.0, minMass = 1600.0, wheels = 4,                   minFreq = 1.18, maxFreq = 1.35, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "charon",         refMass = 1840.0, minMass = 1600.0, wheels = 4,                   minFreq = 1.18, maxFreq = 1.35, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "chiaroscuro",    refMass = 1820.0, minMass = 1600.0, wheels = 4,                   minFreq = 1.18, maxFreq = 1.35, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "sterling",       refMass = 1820.0, minMass = 1600.0, wheels = 4,                   minFreq = 1.18, maxFreq = 1.35, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "sport_r7",       refMass = 1820.0, minMass = 1600.0, wheels = 4,                   minFreq = 1.18, maxFreq = 1.35, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },

    { match = "javelina",       refMass = 1860.0, minMass = 1650.0, wheels = 4,                   minFreq = 1.16, maxFreq = 1.34, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.52, lowRebZeta = 0.88, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "reaver",         refMass = 1860.0, minMass = 1650.0, wheels = 4,                   minFreq = 1.16, maxFreq = 1.34, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.52, lowRebZeta = 0.88, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "wingate",        refMass = 1860.0, minMass = 1650.0, wheels = 4,                   minFreq = 1.16, maxFreq = 1.34, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.52, lowRebZeta = 0.88, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "hoon",           refMass = 1750.0, minMass = 1550.0, wheels = 4,                   minFreq = 1.20, maxFreq = 1.38, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.73, lowBumpZeta = 0.52, lowRebZeta = 0.86, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.13, compAdd = 0.01 },
    { match = "cthulhu",        refMass = 1740.0, minMass = 1520.0, wheels = 4,                   minFreq = 1.18, maxFreq = 1.36, stiffMul = 0.91, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.89, antiSway = 0.87, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "avenger",        refMass = 1740.0, minMass = 1520.0, wheels = 4,                   minFreq = 1.18, maxFreq = 1.36, stiffMul = 0.91, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.89, antiSway = 0.87, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "bullitt",        refMass = 1720.0, minMass = 1500.0, wheels = 4,                   minFreq = 1.18, maxFreq = 1.36, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "bulitt",         refMass = 1720.0, minMass = 1500.0, wheels = 4,                   minFreq = 1.18, maxFreq = 1.36, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "rowley",         refMass = 1720.0, minMass = 1500.0, wheels = 4,                   minFreq = 1.16, maxFreq = 1.34, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.70, lowBumpZeta = 0.49, lowRebZeta = 0.83, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "mistral",        refMass = 1720.0, minMass = 1500.0, wheels = 4,                   minFreq = 1.16, maxFreq = 1.34, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.70, lowBumpZeta = 0.49, lowRebZeta = 0.83, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "type66",         refMass = 1720.0, minMass = 1500.0, wheels = 4,                   minFreq = 1.16, maxFreq = 1.34, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.70, lowBumpZeta = 0.49, lowRebZeta = 0.83, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.01 },

    { match = "vtech",          refMass = 1580.0, minMass = 1420.0, wheels = 4,                   minFreq = 1.26, maxFreq = 1.45, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.87, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.02 },
    { match = "raijin",         refMass = 1570.0, minMass = 1400.0, wheels = 4,                   minFreq = 1.26, maxFreq = 1.45, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.87, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.02 },
    { match = "turbo",          refMass = 1560.0, minMass = 1400.0, wheels = 4,                   minFreq = 1.25, maxFreq = 1.44, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.70, lowBumpZeta = 0.49, lowRebZeta = 0.83, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.02 },

    { match = "coyote",         refMass = 1580.0, minMass = 1400.0, wheels = 4,                   minFreq = 1.14, maxFreq = 1.32, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 19.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "samum",          refMass = 1620.0, minMass = 1420.0, wheels = 4,                   minFreq = 1.14, maxFreq = 1.32, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 19.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "bonewrecker",    refMass = 1580.0, minMass = 1400.0, wheels = 4,                   minFreq = 1.14, maxFreq = 1.32, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 19.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "wendigo",        refMass = 1600.0, minMass = 1400.0, wheels = 4,                   minFreq = 1.14, maxFreq = 1.32, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 19.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "kyokotsu",       refMass = 1520.0, minMass = 1350.0, wheels = 4,                   minFreq = 1.22, maxFreq = 1.40, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 19.0, extremeComp = 0.14, compAdd = 0.02 },
    { match = "targa",          refMass = 1500.0, minMass = 1340.0, wheels = 4,                   minFreq = 1.24, maxFreq = 1.42, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.70, lowBumpZeta = 0.49, lowRebZeta = 0.83, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 19.0, extremeComp = 0.14, compAdd = 0.02 },
    { match = "shion",          refMass = 1480.0, minMass = 1320.0, wheels = 4,                   minFreq = 1.24, maxFreq = 1.42, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.70, lowBumpZeta = 0.49, lowRebZeta = 0.83, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 19.0, extremeComp = 0.14, compAdd = 0.02 },

    { match = "mordred",        refMass = 1680.0, minMass = 1500.0, wheels = 4,                   minFreq = 1.30, maxFreq = 1.48, stiffMul = 0.92, bumpZeta = 0.35, rebZeta = 0.72, lowBumpZeta = 0.50, lowRebZeta = 0.85, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.02 },
    { match = "murk",           refMass = 1620.0, minMass = 1450.0, wheels = 4,                   minFreq = 1.30, maxFreq = 1.48, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.02 },
    { match = "caliburn",       refMass = 1620.0, minMass = 1450.0, wheels = 4,                   minFreq = 1.30, maxFreq = 1.48, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.02 },
    { match = "semimaru",       refMass = 1620.0, minMass = 1450.0, wheels = 4,                   minFreq = 1.30, maxFreq = 1.48, stiffMul = 0.92, bumpZeta = 0.35, rebZeta = 0.72, lowBumpZeta = 0.50, lowRebZeta = 0.85, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 20.0, extremeComp = 0.14, compAdd = 0.02 },
    { match = "terrier",        refMass = 1520.0, minMass = 1350.0, wheels = 4,                   minFreq = 1.28, maxFreq = 1.46, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.88, maxWheelMass = 19.0, extremeComp = 0.14, compAdd = 0.02 },
    { match = "riptide",        refMass = 1520.0, minMass = 1350.0, wheels = 4,                   minFreq = 1.28, maxFreq = 1.46, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.88, maxWheelMass = 19.0, extremeComp = 0.14, compAdd = 0.02 },
    { match = "cabriolet",      refMass = 1460.0, minMass = 1300.0, wheels = 4,                   minFreq = 1.25, maxFreq = 1.43, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.88, maxWheelMass = 19.0, extremeComp = 0.14, compAdd = 0.02 },
    { match = "911",            refMass = 1440.0, minMass = 1280.0, wheels = 4,                   minFreq = 1.26, maxFreq = 1.44, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.88, maxWheelMass = 19.0, extremeComp = 0.14, compAdd = 0.02 },
    { match = "porsche",        refMass = 1440.0, minMass = 1280.0, wheels = 4,                   minFreq = 1.26, maxFreq = 1.44, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.88, maxWheelMass = 19.0, extremeComp = 0.14, compAdd = 0.02 },
    { match = "hoseki",         refMass = 1440.0, minMass = 1250.0, wheels = 4,                   minFreq = 1.18, maxFreq = 1.36, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 18.5, extremeComp = 0.14, compAdd = 0.01 },
    { match = "hozuki",         refMass = 1420.0, minMass = 1250.0, wheels = 4,                   minFreq = 1.18, maxFreq = 1.36, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 18.5, extremeComp = 0.14, compAdd = 0.01 },

    { match = "sidewinder",     refMass = 1450.0, minMass = 1250.0, wheels = 4,                   minFreq = 1.14, maxFreq = 1.32, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.73, lowBumpZeta = 0.52, lowRebZeta = 0.86, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 18.5, extremeComp = 0.13, compAdd = 0.00 },
    { match = "specter",        refMass = 1450.0, minMass = 1250.0, wheels = 4,                   minFreq = 1.16, maxFreq = 1.34, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.73, lowBumpZeta = 0.52, lowRebZeta = 0.86, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 18.5, extremeComp = 0.13, compAdd = 0.00 },
    { match = "bandit",         refMass = 1420.0, minMass = 1250.0, wheels = 4,                   minFreq = 1.14, maxFreq = 1.32, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.73, lowBumpZeta = 0.52, lowRebZeta = 0.86, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 18.5, extremeComp = 0.13, compAdd = 0.00 },
    { match = "r660",           refMass = 1380.0, minMass = 1220.0, wheels = 4,                   minFreq = 1.18, maxFreq = 1.36, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 18.5, extremeComp = 0.14, compAdd = 0.01 },
    { match = "quartz",         refMass = 1360.0, minMass = 1200.0, wheels = 4,                   minFreq = 1.18, maxFreq = 1.36, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.84, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 18.5, extremeComp = 0.14, compAdd = 0.01 },

    { match = "enforcer",       refMass = 1880.0, minMass = 1650.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.91, bumpZeta = 0.36, rebZeta = 0.73, lowBumpZeta = 0.52, lowRebZeta = 0.87, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 19.5, extremeComp = 0.13, compAdd = 0.00 },
    { match = "voyage",         refMass = 1760.0, minMass = 1540.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.89, bumpZeta = 0.35, rebZeta = 0.72, lowBumpZeta = 0.51, lowRebZeta = 0.86, swayMul = 0.89, antiSway = 0.87, maxWheelMass = 19.5, extremeComp = 0.14, compAdd = 0.01 },
    { match = "hella",          refMass = 1680.0, minMass = 1480.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.88, bumpZeta = 0.35, rebZeta = 0.71, lowBumpZeta = 0.50, lowRebZeta = 0.85, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 19.5, extremeComp = 0.14, compAdd = 0.01 },

    { match = "barghest",       refMass = 1820.0, minMass = 1580.0, wheels = 4,                   minFreq = 1.10, maxFreq = 1.26, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.92, antiSway = 0.88, maxWheelMass = 19.5, extremeComp = 0.13, compAdd = 0.00 },
    { match = "gran_butte",     refMass = 1780.0, minMass = 1550.0, wheels = 4,                   minFreq = 1.10, maxFreq = 1.26, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.92, antiSway = 0.88, maxWheelMass = 19.5, extremeComp = 0.13, compAdd = 0.00 },
    { match = "little_mule",    refMass = 1780.0, minMass = 1550.0, wheels = 4,                   minFreq = 1.10, maxFreq = 1.26, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.92, antiSway = 0.88, maxWheelMass = 19.5, extremeComp = 0.13, compAdd = 0.00 },
    { match = "vulture",        refMass = 1780.0, minMass = 1550.0, wheels = 4,                   minFreq = 1.10, maxFreq = 1.26, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.92, antiSway = 0.88, maxWheelMass = 19.5, extremeComp = 0.13, compAdd = 0.00 },
    { match = "vaquero",        refMass = 1760.0, minMass = 1540.0, wheels = 4,                   minFreq = 1.10, maxFreq = 1.26, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.92, antiSway = 0.88, maxWheelMass = 19.5, extremeComp = 0.13, compAdd = 0.00 },
    { match = "revenant",       refMass = 1760.0, minMass = 1540.0, wheels = 4,                   minFreq = 1.10, maxFreq = 1.26, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.92, antiSway = 0.88, maxWheelMass = 19.5, extremeComp = 0.13, compAdd = 0.00 },
    { match = "butte",          refMass = 1720.0, minMass = 1500.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.73, lowBumpZeta = 0.52, lowRebZeta = 0.87, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 19.5, extremeComp = 0.13, compAdd = 0.00 },
    { match = "cst40",          refMass = 1680.0, minMass = 1480.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.91, bumpZeta = 0.35, rebZeta = 0.72, lowBumpZeta = 0.52, lowRebZeta = 0.86, swayMul = 0.89, antiSway = 0.87, maxWheelMass = 19.0, extremeComp = 0.14, compAdd = 0.01 },
    { match = "colby",          refMass = 1620.0, minMass = 1420.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.72, lowBumpZeta = 0.51, lowRebZeta = 0.86, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 19.0, extremeComp = 0.14, compAdd = 0.01 },

    { match = "rattler",        refMass = 1320.0, minMass = 1150.0, wheels = 4,                   minFreq = 1.12, maxFreq = 1.28, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 18.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "gecko",          refMass = 1340.0, minMass = 1150.0, wheels = 4,                   minFreq = 1.12, maxFreq = 1.28, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 18.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "ghoul",          refMass = 1360.0, minMass = 1150.0, wheels = 4,                   minFreq = 1.12, maxFreq = 1.28, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 18.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "locust",         refMass = 1360.0, minMass = 1150.0, wheels = 4,                   minFreq = 1.12, maxFreq = 1.28, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 18.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "the_rat",        refMass = 1320.0, minMass = 1150.0, wheels = 4,                   minFreq = 1.12, maxFreq = 1.28, stiffMul = 0.92, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.53, lowRebZeta = 0.88, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 18.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "ga32t",          refMass = 1260.0, minMass = 1100.0, wheels = 4,                   minFreq = 1.10, maxFreq = 1.26, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.72, lowBumpZeta = 0.52, lowRebZeta = 0.86, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 17.5, extremeComp = 0.14, compAdd = 0.01 },
    { match = "galena",         refMass = 1220.0, minMass = 1080.0, wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.90, bumpZeta = 0.35, rebZeta = 0.72, lowBumpZeta = 0.52, lowRebZeta = 0.86, swayMul = 0.88, antiSway = 0.86, maxWheelMass = 17.5, extremeComp = 0.14, compAdd = 0.01 },

    { match = "e126",           refMass = 880.0,  minMass = 760.0,  wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.90, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.54, lowRebZeta = 0.90, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 15.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "p126",           refMass = 860.0,  minMass = 750.0,  wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.90, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.54, lowRebZeta = 0.90, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 15.0, extremeComp = 0.13, compAdd = 0.00 },
    { match = "maimai",         refMass = 860.0,  minMass = 750.0,  wheels = 4,                   minFreq = 1.08, maxFreq = 1.24, stiffMul = 0.90, bumpZeta = 0.36, rebZeta = 0.74, lowBumpZeta = 0.54, lowRebZeta = 0.90, swayMul = 0.90, antiSway = 0.88, maxWheelMass = 15.0, extremeComp = 0.13, compAdd = 0.00 }
}

local COPY_WHEEL_FLATS = {
    "frictionMulLateral",
    "frictionMulLongitudinal",
    "tireLateralSlipEffectsMul",
    "tireLongitudinalSlipEffectsMul",
    "maxBrakingTorque",
    "tireFrictionCoef",
    "tireRollingResistanceCoef"
}

local function clamp(val, minV, maxV)
    if val < minV then return minV end
    if val > maxV then return maxV end
    return val
end

local function buildDynamicSpecFromMass(vMass, isSixWheel)
    local t = clamp((vMass - 1200.0) / 2800.0, 0.0, 1.0)
    return {
        refMass      = vMass,
        minMass      = 750.0,
        wheels       = isSixWheel and 6 or 4,
        dualRear     = isSixWheel,
        minFreq      = 1.14 - (0.12 * t),
        maxFreq      = 1.34 - (0.16 * t),
        stiffMul     = 0.90 + (0.08 * t),
        bumpZeta     = 0.35 + (0.04 * t),
        rebZeta      = 0.71 + (0.07 * t),
        lowBumpZeta  = 0.50 + (0.09 * t),
        lowRebZeta   = 0.84 + (0.10 * t),
        swayMul      = 0.88 + (0.12 * t),
        antiSway     = 0.86 + (0.06 * t),
        maxWheelMass = 19.0 + (4.0 * t),
        extremeComp  = 0.14 - (0.03 * t),
        compAdd      = (vMass < 1850.0) and 0.01 or 0.00
    }
end

local function findCarSpec(searchText, vMass, isSixWheel)
    local combined = string.lower(searchText or "")
    for _, spec in ipairs(CAR_SPECS_25) do
        if string.find(combined, spec.match, 1, true) then
            return spec
        end
    end
    return buildDynamicSpecFromMass(vMass, isSixWheel)
end

local function ensureIsolatedPreset(cloneName, srcID)
    if not srcID or srcID.value == "" then return nil end
    if srcID.value == cloneName then return srcID end

    local cloneID = TweakDBID.new(cloneName)
    if not TweakDB:GetRecord(cloneID) then
        pcall(function()
            TweakDB:CloneRecord(cloneName, srcID)
        end)
    end

    if TweakDB:GetRecord(cloneID) then
        for _, flatName in ipairs(COPY_WHEEL_FLATS) do
            local ok, val = pcall(function() return TweakDB:GetFlat(srcID.value .. "." .. flatName) end)
            if ok and val ~= nil then
                TweakDB:SetFlatNoUpdate(cloneName .. "." .. flatName, val)
            end
        end
        return cloneID
    end

    return srcID
end

local function tuneCarWheelPreset(presetID, cornerMass, spec, isFront)
    if not presetID or presetID.value == "" then return false end
    local pPath = presetID.value

    local stiff   = TweakDB:GetFlat(pPath .. ".springStiffness")
    local sway    = TweakDB:GetFlat(pPath .. ".swaybarStiffness")
    local compLen = TweakDB:GetFlat(pPath .. ".logicalSuspensionCompressionLength")
    local wMass   = TweakDB:GetFlat(pPath .. ".mass")

    if type(stiff) ~= "number" or stiff <= 0.0 then return false end

    local safeCornerMass = clamp(cornerMass, 140.0, 2400.0)
    local newStiff = stiff * spec.stiffMul

    local twoPi = 2.0 * math.pi
    local kMin  = (safeCornerMass * (twoPi * spec.minFreq) * (twoPi * spec.minFreq)) / 1000.0
    local kMax  = (safeCornerMass * (twoPi * spec.maxFreq) * (twoPi * spec.maxFreq)) / 1000.0

    newStiff = clamp(newStiff, kMin, kMax)
    newStiff = clamp(newStiff, stiff * 0.80, stiff * 1.24)
    TweakDB:SetFlatNoUpdate(pPath .. ".springStiffness", newStiff)

    local cCrit       = 2.0 * math.sqrt((newStiff * 1000.0) * safeCornerMass)
    local rearRebBias = isFront and 1.00 or 1.05

    local newHighBump    = cCrit * spec.bumpZeta
    local newHighRebound = cCrit * spec.rebZeta * rearRebBias
    local newLowBump     = cCrit * spec.lowBumpZeta
    local newLowRebound  = cCrit * spec.lowRebZeta * rearRebBias

    TweakDB:SetFlatNoUpdate(pPath .. ".springDamping", newHighBump)
    TweakDB:SetFlatNoUpdate(pPath .. ".springReboundDamping", newHighRebound)
    TweakDB:SetFlatNoUpdate(pPath .. ".springBoundDampingLowRate", newLowBump)
    TweakDB:SetFlatNoUpdate(pPath .. ".springReboundDampingLowRate", newLowRebound)
    TweakDB:SetFlatNoUpdate(pPath .. ".springDampingLowRateCompression", 0.20)
    TweakDB:SetFlatNoUpdate(pPath .. ".springDampingHighRateCompression", 0.36)

    if type(sway) == "number" and sway > 0.0 then
        TweakDB:SetFlatNoUpdate(pPath .. ".swaybarStiffness", sway * spec.swayMul)
    end

    if type(wMass) == "number" and wMass > spec.maxWheelMass then
        TweakDB:SetFlatNoUpdate(pPath .. ".mass", spec.maxWheelMass)
    end

    if type(compLen) == "number" and spec.compAdd > 0.0 and compLen < 0.36 then
        TweakDB:SetFlatNoUpdate(pPath .. ".logicalSuspensionCompressionLength", compLen + spec.compAdd)
    end

    TweakDB:SetFlatNoUpdate(pPath .. ".extremeCompressionEventScalor", spec.extremeComp)
    TweakDB:Update(presetID)
    return true
end

function Suspension.applyAll(cfg)
    if not cfg.enableSuspension then return 0 end
    local count = 0

    local processedDrives      = {}
    local processedBikePresets = {}
    local tunedPresetPaths     = {}
    local bikePresets          = {}

    local baseStiffMul = (cfg.suspension and cfg.suspension.stiffnessMul) or 0.78
    local baseSwayMul  = (cfg.suspension and cfg.suspension.swaybarMul) or 0.72
    local baseCompAdd  = (cfg.suspension and cfg.suspension.compressionAdd) or 0.08

    local vehicles = TweakDB:GetRecords("gamedataVehicle_Record")
    if vehicles then
        for _, veh in ipairs(vehicles) do
            pcall(function()
                local vehID   = veh:GetID()
                local vehPath = vehID.value
                if not vehPath or vehPath == "" then return end

                local bDriveID = TweakDB:GetFlat(vehPath .. ".bikeDriveModelData")
                if bDriveID and bDriveID.value ~= "" then
                    local bwsID = TweakDB:GetFlat(bDriveID.value .. ".wheelSetup")
                    if bwsID and bwsID.value ~= "" then
                        local bfID = TweakDB:GetFlat(bwsID.value .. ".frontPreset")
                        local bbID = TweakDB:GetFlat(bwsID.value .. ".backPreset") or TweakDB:GetFlat(bwsID.value .. ".rearPreset")
                        if bfID and bfID.value ~= "" then bikePresets[bfID.value] = true end
                        if bbID and bbID.value ~= "" then bikePresets[bbID.value] = true end
                    end
                    return
                end

                local driveID = nil
                local driveRec = veh:VehDriveModelData()
                if driveRec then
                    driveID = driveRec:GetID()
                else
                    driveID = TweakDB:GetFlat(vehPath .. ".vehDriveModelData")
                end
                if not driveID or driveID.value == "" then return end
                local drivePath = driveID.value

                local okBike, bikeTilt = pcall(function() return TweakDB:GetFlat(drivePath .. ".bikeMaxTilt") end)
                if okBike and type(bikeTilt) == "number" then
                    local wsID = TweakDB:GetFlat(drivePath .. ".wheelSetup")
                    if wsID and wsID.value ~= "" then
                        local fID = TweakDB:GetFlat(wsID.value .. ".frontPreset")
                        local bID = TweakDB:GetFlat(wsID.value .. ".backPreset") or TweakDB:GetFlat(wsID.value .. ".rearPreset")
                        if fID and fID.value ~= "" then bikePresets[fID.value] = true end
                        if bID and bID.value ~= "" then bikePresets[bID.value] = true end
                    end
                    return
                end

                if processedDrives[drivePath] then return end
                processedDrives[drivePath] = true

                local wsID = TweakDB:GetFlat(drivePath .. ".wheelSetup")
                if not wsID or wsID.value == "" then return end
                local wsPath = wsID.value

                local lmID = TweakDB:GetFlat(wsPath .. ".LM")
                local rmID = TweakDB:GetFlat(wsPath .. ".RM")
                local hasMidAxle = (lmID and lmID.value ~= "") or (rmID and rmID.value ~= "") or (string.find(string.lower(vehPath .. " " .. wsPath), "6w", 1, true) ~= nil)

                local entPath = ""
                pcall(function()
                    local ent = TweakDB:GetFlat(vehPath .. ".entityTemplatePath")
                    if ent then entPath = tostring(ent) end
                end)

                local tMass = TweakDB:GetFlat(drivePath .. ".total_mass")
                local cMass = TweakDB:GetFlat(drivePath .. ".chassis_mass")
                local rawMass = 0.0
                if type(tMass) == "number" and tMass > 300.0 then rawMass = tMass end
                if type(cMass) == "number" and cMass > rawMass then rawMass = cMass end

                local searchTags = vehPath .. " " .. drivePath .. " " .. entPath
                local spec = findCarSpec(searchTags, (rawMass > 300.0) and rawMass or 1650.0, hasMidAxle)

                local vMass = (rawMass > 300.0) and rawMass or spec.refMass
                if spec.match == "centurion" and hasMidAxle and vMass < 4200.0 then
                    vMass = 4300.0
                elseif spec.minMass and vMass < spec.minMass then
                    vMass = spec.minMass
                end

                if type(tMass) == "number" and tMass > 300.0 and type(cMass) == "number" and cMass > 100.0 and cMass < tMass * 0.90 then
                    TweakDB:SetFlatNoUpdate(drivePath .. ".chassis_mass", tMass)
                end

                TweakDB:SetFlatNoUpdate(drivePath .. ".antiSwaybarDampingScalor", spec.antiSway or 0.88)

                local fID = TweakDB:GetFlat(wsPath .. ".frontPreset")
                local bID = TweakDB:GetFlat(wsPath .. ".backPreset")
                local rID = TweakDB:GetFlat(wsPath .. ".rearPreset")
                local activeBackID = (bID and bID.value ~= "") and bID or rID

                local targetWsID   = wsID
                local customWsName = drivePath .. "_bd25_ws"
                local customWsID   = TweakDBID.new(customWsName)
                if wsPath ~= customWsName then
                    if not TweakDB:GetRecord(customWsID) then
                        pcall(function() TweakDB:CloneRecord(customWsName, wsID) end)
                    end
                    if TweakDB:GetRecord(customWsID) then
                        targetWsID = customWsID
                    end
                end

                local targetFrontID = ensureIsolatedPreset(drivePath .. "_bd25_fp", fID)
                local targetBackID  = ensureIsolatedPreset(drivePath .. "_bd25_bp", activeBackID)

                local frontWeightShare = 0.50
                local okCom, com = pcall(function() return TweakDB:GetFlat(drivePath .. ".center_of_mass_offset") end)
                if okCom and com and type(com.y) == "number" then
                    frontWeightShare = clamp(0.50 + (com.y * 0.12), 0.42, 0.58)
                end

                local nFront = 2.0
                local nRear  = 2.0
                if spec.wheels == 6 or hasMidAxle then
                    if spec.dualFront then
                        nFront = 4.0
                        nRear  = 2.0
                    else
                        nFront = 2.0
                        nRear  = 4.0
                    end
                end

                local frontCornerMass = (vMass * frontWeightShare) / nFront
                local rearCornerMass  = (vMass * (1.0 - frontWeightShare)) / nRear

                if targetFrontID then
                    tuneCarWheelPreset(targetFrontID, frontCornerMass, spec, true)
                    tunedPresetPaths[targetFrontID.value] = true
                    if fID then tunedPresetPaths[fID.value] = true end
                end
                if targetBackID then
                    tuneCarWheelPreset(targetBackID, rearCornerMass, spec, false)
                    tunedPresetPaths[targetBackID.value] = true
                    if activeBackID then tunedPresetPaths[activeBackID.value] = true end
                end

                if targetWsID.value == customWsName then
                    if targetFrontID then
                        TweakDB:SetFlatNoUpdate(customWsName .. ".frontPreset", targetFrontID)
                    end
                    if targetBackID then
                        if bID and bID.value ~= "" then
                            TweakDB:SetFlatNoUpdate(customWsName .. ".backPreset", targetBackID)
                        end
                        if rID and rID.value ~= "" then
                            TweakDB:SetFlatNoUpdate(customWsName .. ".rearPreset", targetBackID)
                        end
                    end
                    TweakDB:Update(targetWsID)
                    TweakDB:SetFlatNoUpdate(drivePath .. ".wheelSetup", targetWsID)
                end

                TweakDB:Update(driveID)
                TweakDB:Update(vehID)
                count = count + 1
            end)
        end
    end

    for bPath, _ in pairs(bikePresets) do
        if not processedBikePresets[bPath] and not tunedPresetPaths[bPath] then
            processedBikePresets[bPath] = true
            pcall(function()
                local pID     = TweakDBID.new(bPath)
                local stiff   = TweakDB:GetFlat(bPath .. ".springStiffness")
                local sway    = TweakDB:GetFlat(bPath .. ".swaybarStiffness")
                local damp    = TweakDB:GetFlat(bPath .. ".springDamping")
                local reb     = TweakDB:GetFlat(bPath .. ".springReboundDamping")
                local compLen = TweakDB:GetFlat(bPath .. ".logicalSuspensionCompressionLength")
                local droop   = TweakDB:GetFlat(bPath .. ".visualSuspensionDroop")

                if type(stiff) == "number" and stiff > 0 then
                    TweakDB:SetFlatNoUpdate(bPath .. ".springStiffness", stiff * baseStiffMul)
                end
                if type(sway) == "number" and sway > 0 then
                    TweakDB:SetFlatNoUpdate(bPath .. ".swaybarStiffness", sway * baseSwayMul)
                end
                if type(damp) == "number" and type(reb) == "number" then
                    local baseAvg = (damp + reb) * 0.5
                    local newDamp = baseAvg * 0.72
                    local newReb  = baseAvg * 1.12
                    TweakDB:SetFlatNoUpdate(bPath .. ".springDamping", newDamp)
                    TweakDB:SetFlatNoUpdate(bPath .. ".springReboundDamping", newReb)
                    TweakDB:SetFlatNoUpdate(bPath .. ".springBoundDampingLowRate", newDamp * 0.65)
                    TweakDB:SetFlatNoUpdate(bPath .. ".springReboundDampingLowRate", newReb * 0.65)
                end
                if type(compLen) == "number" then
                    TweakDB:SetFlatNoUpdate(bPath .. ".logicalSuspensionCompressionLength", compLen + baseCompAdd)
                end
                if type(droop) == "number" then
                    TweakDB:SetFlatNoUpdate(bPath .. ".visualSuspensionDroop", droop + 0.04)
                end
                TweakDB:Update(pID)
            end)
        end
    end

    return count
end

return Suspension
