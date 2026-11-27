module CrowdScanner.UI

import Codeware.UI.inkCustomController
import Codeware.UI.ThemeColors

public class ScannerBackstorySystem extends inkCustomController {


    protected let m_scannerBackstorySystem: ref<inkVerticalPanel>;

    protected let m_scanCompleted: Bool;

    protected let m_netWatchDbReport: ref<NetWatchDBReport>;

    protected let m_netWatchDbLoadingStatus: ref<NetWatchDBLoadingStatus>;

    protected let m_fluffFooter: ref<inkVerticalPanel>;

    protected let m_backstory: BackstoryUI;

    protected cb func OnInitialize() -> Bool {
        this.m_netWatchDbLoadingStatus.SetVisible(true);
        this.m_netWatchDbReport.SetVisible(false);
    }

    protected cb func OnCreate() -> Void {
        this.CreateWidgets();
    }

    protected func CreateWidgets() -> Void {
        let scannerBackstorySystem: ref<inkVerticalPanel> = new inkVerticalPanel();
        scannerBackstorySystem.SetName(n"ScannerBackstorySystem");
        scannerBackstorySystem.SetHAlign(inkEHorizontalAlign.Left);
        scannerBackstorySystem.SetVAlign(inkEVerticalAlign.Top);
        scannerBackstorySystem.SetAnchor(inkEAnchor.TopLeft);
        scannerBackstorySystem.SetSizeRule(inkESizeRule.Stretch);
        scannerBackstorySystem.SetFitToContent(true);
        scannerBackstorySystem.SetVisible(false);
        this.m_scannerBackstorySystem = scannerBackstorySystem;
        this.SetRootWidget(scannerBackstorySystem);

        let netWatchHeader: ref<inkText> = new inkText();
        netWatchHeader.SetName(n"netwatch_header");
        netWatchHeader.SetFontFamily("base\\gameplay\\gui\\fonts\\orbitron\\orbitron.inkfontfamily");
        netWatchHeader.SetFontStyle(n"Medium");
        netWatchHeader.SetFontSize(20);
        netWatchHeader.SetLetterCase(textLetterCase.UpperCase);
        netWatchHeader.SetTracking(2);
        netWatchHeader.SetText("NetWatch Database");
        netWatchHeader.SetFitToContent(true);
        netWatchHeader.SetMargin(new inkMargin(0.0, 5.0, 0.0, 15.0));
        netWatchHeader.SetTintColor(new HDRColor(0.62625, 0.60375, 0.58875, 1.0));
        netWatchHeader.Reparent(scannerBackstorySystem);

        this.m_netWatchDbLoadingStatus = NetWatchDBLoadingStatus.Create();
        this.m_netWatchDbLoadingStatus.Reparent(scannerBackstorySystem);

        this.m_netWatchDbReport = NetWatchDBReport.Create();
        this.m_netWatchDbReport.Reparent(scannerBackstorySystem);

        let fluffFooter: ref<inkVerticalPanel> = new inkVerticalPanel();
        fluffFooter.SetName(n"fluffFooter");
        fluffFooter.SetAffectsLayoutWhenHidden(false);
        fluffFooter.SetFitToContent(true);
        fluffFooter.SetMargin(new inkMargin(10.0, 10.0, 10.0, 10.0));
        fluffFooter.SetHAlign(inkEHorizontalAlign.Right);
        fluffFooter.SetVAlign(inkEVerticalAlign.Bottom);
        fluffFooter.SetSizeRule(inkESizeRule.Stretch);
        fluffFooter.SetVisible(false);
        this.m_fluffFooter = fluffFooter;
        this.m_fluffFooter.Reparent(scannerBackstorySystem);

        let separator: ref<inkImage> = new inkImage();
        separator.SetName(n"Separator");
        separator.SetAtlasResource(r"base\\gameplay\\gui\\widgets\\scanning\\scanner_hud.inkatlas");
        separator.SetTexturePart(n"outerLine4");
        separator.SetContentHAlign(inkEHorizontalAlign.Right);
        separator.SetMargin(new inkMargin(0.0, 0.0, 15.0, 0.0));
        separator.SetHAlign(inkEHorizontalAlign.Right);
        separator.SetVAlign(inkEVerticalAlign.Top);
        separator.SetAnchorPoint(new Vector2(0.5, 0.5));
        separator.SetTintColor(ThemeColors.LightGreen());
        separator.SetNineSliceScale(true);
        separator.SetOpacity(0.2);
        separator.SetSize(new Vector2(700.0, 2.0));
        separator.Reparent(fluffFooter);
            
        let netwatchLogo: ref<inkImage> = new inkImage();
        netwatchLogo.SetName(n"NetWatchLogo");
        netwatchLogo.SetAtlasResource(r"base\\gameplay\\gui\\world\\internet\\browser_atlas.inkatlas");
        netwatchLogo.SetTexturePart(n"netwatch");
        netwatchLogo.SetContentHAlign(inkEHorizontalAlign.Right);
        netwatchLogo.SetMargin(new inkMargin(0.0, 10.0, 15.0, 0.0));
        netwatchLogo.SetHAlign(inkEHorizontalAlign.Right);
        netwatchLogo.SetVAlign(inkEVerticalAlign.Top);
        netwatchLogo.SetAnchorPoint(new Vector2(0.5, 0.5));
        netwatchLogo.SetTintColor(ThemeColors.LightGreen());
        netwatchLogo.SetNineSliceScale(true);
        //netwatchLogo.SetOpacity(0.5);
        netwatchLogo.SetSize(new Vector2(236.0, 17.0));
        netwatchLogo.Reparent(fluffFooter);

        let evaluationResult: ref<inkImage> = new inkImage();
        evaluationResult.SetName(n"EvaluationResult");
        evaluationResult.SetAtlasResource(r"base\\gameplay\\gui\\world\\internet\\browser_atlas.inkatlas");
        evaluationResult.SetTexturePart(n"evaluation");
        evaluationResult.SetContentHAlign(inkEHorizontalAlign.Right);
        evaluationResult.SetMargin(new inkMargin(0.0, 2.0, 15.0, 0.0));
        evaluationResult.SetHAlign(inkEHorizontalAlign.Right);
        evaluationResult.SetVAlign(inkEVerticalAlign.Top);
        evaluationResult.SetAnchorPoint(new Vector2(0.5, 0.5));
        evaluationResult.SetTintColor(ThemeColors.LightGreen());
        evaluationResult.SetNineSliceScale(true);
        //evaluationResult.SetOpacity(0.5);
        evaluationResult.SetSize(new Vector2(281.0, 9.0));
        evaluationResult.Reparent(fluffFooter);
            
	}

    public func isScanCompleted() -> Bool {
        return this.m_scanCompleted;
    }

    public func SetScanCompleted(completed: Bool) {
        this.m_scanCompleted = completed;

        if (this.m_scanCompleted) {
            this.m_netWatchDbLoadingStatus.SetVisible(false);
            this.m_netWatchDbReport.SetVisible(true);
            this.m_fluffFooter.SetVisible(true);
            this.m_fluffFooter.SetMargin(new inkMargin(5.0, 20.0, 0.0, 20.0));
        }
    }

    public func IsBackstoryEmpty(backstoryUI: BackstoryUI) -> Bool {
       // Log("Null check: " + backstoryUI.background);
        if(Equals(backstoryUI.background, "")) {
            // Log("No background. Don't set!");
            return true;
        } else {
            return false;
        }
    }

    public func SetBackstory(backstoryUI: BackstoryUI) {
        this.m_backstory = backstoryUI;
        this.m_netWatchDbReport.SetBackstory(this.m_backstory);
        if !this.IsBackstoryEmpty(backstoryUI) {
            this.m_scannerBackstorySystem.SetVisible(true);
            // Log("Backstory set on system: " + this.m_backstory.background);
        }
    }

    public static func Create() -> ref<ScannerBackstorySystem> {
		let self: ref<ScannerBackstorySystem> = new ScannerBackstorySystem();
		self.CreateInstance();
		return self;
	}
}