public class BackstoryManager {

    public static func GenerateBackstoryUI(target: wref<NPCPuppet>) -> BackstoryUI {
        let entityIDHash: Int32 = Cast(EntityID.GetHash(target.GetEntityID()));
        let seed = RandRange(entityIDHash, 0, 2147483647);
        let lifePath: ref<LifePath> = LifePath.Create(target);

        let background = BackstoryManager.GenerateChildhoodHome(seed, lifePath) + BackstoryManager.GenerateUpbringingEvent(seed, lifePath);
        let earlyLife = BackstoryManager.GenerateChildhoodEvents(seed, lifePath);
        let significantEvents = BackstoryManager.GenerateFirstJob(seed, lifePath) + BackstoryManager.GenerateAdultEvents(seed, lifePath);

        let backstoryUI: BackstoryUI;
        backstoryUI.background = background;
        backstoryUI.earlyLife = earlyLife;
        backstoryUI.significantEvents = significantEvents;
        return backstoryUI;
    }

    private static func GenerateUpbringingEvent(seed: Int32, lifePath: ref<LifePath>) -> String {
        return BackstoryManager.GenerateEvent(seed, lifePath, lifePath.possibleEvents.m_weightedUpbringingEvents, lifePath.possibleEvents.m_cdfWeightedUpbringingEvents);
    }

    public static func GenerateChildhoodHome(seed: Int32, lifePath: ref<LifePath>) -> String {
        return BackstoryManager.GenerateEvent(seed, lifePath, lifePath.possibleEvents.m_weightedHomeEvents, lifePath.possibleEvents.m_cdfWeightedHomeEvents);
    }

    private static func GenerateChildhoodEvents(seed: Int32, lifePath: ref<LifePath>) -> String {
        let childhoodEvents: String;
        let eventsCount: Int32 = RandRange(seed + 21620, 1, 2);

        let i = 0;
        while i < eventsCount {
            childhoodEvents += BackstoryManager.GenerateEvent(seed + (i * 199), lifePath, lifePath.possibleEvents.m_weightedChildhoodEvents, lifePath.possibleEvents.m_cdfWeightedChildhoodEvents);
            i += 1;
        }  
        return childhoodEvents;
    }

    private static func GenerateFirstJob(seed: Int32, lifePath: ref<LifePath>) -> String {
        return BackstoryManager.GenerateEvent(seed, lifePath, lifePath.possibleEvents.m_weightedJobEvents, lifePath.possibleEvents.m_cdfWeightedJobEvents);
    }

    private static func GenerateAdultEvents(seed: Int32, lifePath: ref<LifePath>) -> String {
        let adultEvents: String;
        let eventsCount: Int32 = RandRange(seed + 21620, 1, 2);

        let i = 0;
        while i < eventsCount {
            adultEvents += BackstoryManager.GenerateEvent(seed + (i * 199), lifePath, lifePath.possibleEvents.m_weightedAdultEvents, lifePath.possibleEvents.m_cdfWeightedAdultEvents);
            i += 1;
        }  
        return adultEvents;
    }

    private static func GenerateEvent(seed: Int32, lifePath: ref<LifePath>, arr: array<ref<LifePathEvent>>, cdf: array<Int32>) -> String {
        let cdfSize = ArraySize(cdf);
        let totalWeight = cdf[cdfSize - 1];
        let val = RandRange(seed, 0, totalWeight);
        let eventIndex = BackstoryManager.getCorrespondingIndex(cdf, val);

        let event = arr[eventIndex];
        let eventText = event.GetText(lifePath.gender);
        return BackstoryManager.FillReplacements(seed, eventText);
    }

    private static func FillReplacements(seed: Int32, text: String) -> String {
        let ret = text;
        if(StrContains(ret, "%corp%")) {
            ret = ReplaceFirst(ret, "%corp%", BackstoryManager.GetRandomCorpo(seed));
        };
        if(StrContains(ret, "%eddies%")) {
            ret = ReplaceFirst(ret, "%eddies%", IntToString(RandRange(seed, 100, 10000)));
        };
        if(StrContains(ret, "%years%")) {
            ret = ReplaceFirst(ret, "%years%", IntToString(RandRange(seed, 2, 10)));
        };
        if(StrContains(ret, "%year%")) {
            ret = ReplaceFirst(ret, "%year%", IntToString(RandRange(seed, 2020, 2050)));
        };
        if(StrContains(ret, "%young_age%")) {
            ret = ReplaceFirst(ret, "%young_age%", IntToString(RandRange(seed, 10, 16)));
        };
        return ret;
    }

    private static func getCorrespondingIndex(arr: array<Int32>, val: Int32) -> Int32 {
        let acc = 0;
        let i = 0;
        while val > arr[i] {
            i += 1;
        }
        return i;
    }


    private static func GetRandomCorpo(seed: Int32) -> String {
        let corpos: array<String>;
        
        ArrayPush(corpos, Text.NIPPON_NETWORK());
        ArrayPush(corpos, Text.DIVERSE_MEDIA());
        ArrayPush(corpos, Text.WORLD_NEWS());
        ArrayPush(corpos, Text.AKAROMI());
        ArrayPush(corpos, Text.CONAG());
        ArrayPush(corpos, Text.NN54());
        ArrayPush(corpos, Text.PETROCHEM());
        ArrayPush(corpos, Text.SOVOIL());
        ArrayPush(corpos, Text.ARASAKA());
        ArrayPush(corpos, Text.KANG_TAO());
        ArrayPush(corpos, Text.Militech());
        ArrayPush(corpos, Text.MITSU_SUGO());
        ArrayPush(corpos, Text.SEG_ATARI());
        ArrayPush(corpos, Text.TDS());
        ArrayPush(corpos, Text.AHI());
        ArrayPush(corpos, Text.EBM());
        ArrayPush(corpos, Text.IEC());
        ArrayPush(corpos, Text.MICROTECH());
        ArrayPush(corpos, Text.ZETATECH());
        ArrayPush(corpos, Text.ADREK_ROBO());
        ArrayPush(corpos, Text.AKAGI_SYS());
        ArrayPush(corpos, Text.BAKU_CHIPMASTERS());
        ArrayPush(corpos, Text.BIOTECHNICA());
        ArrayPush(corpos, Text.CYPHIRE());
        ArrayPush(corpos, Text.DAKAI());
        ArrayPush(corpos, Text.DYNALAR());
        ArrayPush(corpos, Text.KENJIRI());
        ArrayPush(corpos, Text.KIROSHI());
        ArrayPush(corpos, Text.TTI());
        ArrayPush(corpos, Text.MAF());
        ArrayPush(corpos, Text.TOYOTA());
        ArrayPush(corpos, Text.FUYUTSUKI());
        ArrayPush(corpos, Text.ORBITAL_AIR());
        ArrayPush(corpos, Text.WORLDSAT());
        ArrayPush(corpos, Text.EUROBANK());
        ArrayPush(corpos, Text.FUJIWARA());
        ArrayPush(corpos, Text.INFOCOMP());
        ArrayPush(corpos, Text.BAKENEKO());

        let corpoVal = RandRange(seed + 41948, 0, ArraySize(corpos)-1);

        return corpos[corpoVal];
    }
}