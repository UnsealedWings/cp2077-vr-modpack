@wrapMethod(NPCPuppet)
public const func CompileScannerChunks() -> Bool {
    let scannerBlackboard: wref<IBlackboard>;
    let backstoryChunk: ref<ScannerBackstory>;
    let characterRecord: ref<Character_Record> = TweakDBInterface.GetCharacterRecord(this.GetRecordID());

    scannerBlackboard = GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UI_ScannerModules);

    let hasReactionGroup = !Equals(
        this.GetStimReactionComponent().GetReactionPreset().EnumName(),
        n"None"
    );

    if (!characterRecord.IsChild() && this.IsCrowd() && hasReactionGroup) {
        let backstoryUI = BackstoryManager.GenerateBackstoryUI(this);
        backstoryChunk = new ScannerBackstory();
        backstoryChunk.Set(backstoryUI);
       // Log("Setting variant with backstory: " + backstoryChunk.GetBackstory().background);
        scannerBlackboard.SetVariant(GetAllBlackboardDefs().UI_ScannerModules.ScannerBackstory, ToVariant(backstoryChunk));
    }
    return wrappedMethod();
}
