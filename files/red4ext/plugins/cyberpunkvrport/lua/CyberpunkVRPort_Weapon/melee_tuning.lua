-- Shared by ordinary melee and tracked arm cyberware.
return {
    swingSpeed=1.5,        -- was 3.0: even moderate swings register a hit
    whooshSpeed=2.5,       -- was 3.5
    gorillaSwingSpeed=1.0, -- was 2.0
    gorillaWhooshSpeed=1.5,-- was 2.0
    rearmSpeed=100.0,      -- was 1.0: effectively always below -> always re-arms
    fastSpeed=3.0,         -- was 4.2
    minGap=.25,
    window=.09,
    minSpan=.04,
    teleport=.60,          -- was .30: tolerant of fast flicks
    equipMute=.2,          -- was .8: swing sooner after equipping
}
