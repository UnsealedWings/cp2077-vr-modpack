local Config = {
    enableHandling     = true,  -- สวิตช์หลักของระบบควบคุมทั้งหมด
    enableCarHandling  = true,  -- 01A: เปิด/ปิด เฉพาะระบบควบคุมรถยนต์
    enableBikeHandling = true,  -- 01B: เปิด/ปิด เฉพาะระบบควบคุมมอเตอร์ไซค์
    enableSuspension   = true,  -- 02: ระบบช่วงล่างนุ่มนวล ไม่แข็งกระด้าง
    enableAirControl   = true,  -- 03: ระบบเหินและพลิกรถกลางอากาศแบบ GTA V
    enableClimbing     = true,  -- 04: ระบบไต่ฟุตบาท ก้อนหิน และขอบแบริเออร์
    enableCollision    = true,  -- 05: ระบบชนแล้วไถลตามแรงเฉื่อย ไม่หยุดนิ่งแข็งทื่อ

    handling = {
        steeringSpeedMul    = 1.32,
        tireGripMul         = 1.16,
        wheelspinGripMul    = 0.93,
        handbrakeTorqueMul  = 1.65,
        handbrakeSlideBoost = 2.50,
        -- ค่ารถยนต์
        rollInertiaBoost    = 1.35,
        carTurnBoost        = 3.45,
        antiDriftStrength   = 3.00,
        -- ค่ามอเตอร์ไซค์
        bikeTiltSpeedMul    = 1.38,
        bikeTurnBoost       = 4.35,
        bikeStability       = 5.80
    },
    suspension = {
        stiffnessMul       = 0.78,
        compressionAdd     = 0.08,
        swaybarMul         = 0.72
    },
    airControl = {
        gravityScale       = 0.80,
        pitchStrength      = 2.60,
        rollStrength       = 3.10,
        yawStrength        = 1.40,
        angularDamping     = 0.92,
        autoUprightAssist  = true
    },
    climbing = {
        climbForce         = 5.80,
        sideClimbBoost     = 1.45,
        maxObstacleHeight  = 1.35,
        detectDistance     = 2.40,
        sideDetectDistance = 1.65
    },
    collision = {
        bodyFrictionMul    = 0.35,
        momentumKeepRatio  = 0.45,
        impactThreshold    = 6.0
    }
}

return Config
