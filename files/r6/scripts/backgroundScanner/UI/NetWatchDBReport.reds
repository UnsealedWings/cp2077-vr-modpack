module CrowdScanner.UI

import Codeware.UI.inkCustomController
import Codeware.UI.ThemeColors

public class NetWatchDBReport extends inkCustomController {

    private let m_backstoryUI: BackstoryUI;

    private let m_background: wref<inkText>;

    private let m_earlyLife: wref<inkText>;

    private let m_significantEvents: wref<inkText>;

    protected cb func OnCreate() -> Void {
        this.CreateWidgets();
    }

    protected func CreateWidgets() -> Void {
        let netWatchDbReport: ref<inkVerticalPanel> = new inkVerticalPanel();
        netWatchDbReport.SetName(n"NetWatchDBReport");
        netWatchDbReport.SetHAlign(inkEHorizontalAlign.Left);
        netWatchDbReport.SetVAlign(inkEVerticalAlign.Top);
        netWatchDbReport.SetAnchor(inkEAnchor.TopLeft);
        netWatchDbReport.SetSizeRule(inkESizeRule.Stretch);
        netWatchDbReport.SetMargin(new inkMargin(5.0, 0.0, 0.0, 0.0));
        netWatchDbReport.SetFitToContent(true);
        this.SetRootWidget(netWatchDbReport);

        let backgroundHeader: ref<inkText> = new inkText();
        backgroundHeader.SetName(n"background_header");
        backgroundHeader.SetFontFamily("base\\gameplay\\gui\\fonts\\orbitron\\orbitron.inkfontfamily");
        backgroundHeader.SetFontStyle(n"Medium");
        backgroundHeader.SetFontSize(17);
        backgroundHeader.SetLetterCase(textLetterCase.UpperCase);
        backgroundHeader.SetTracking(2);
        backgroundHeader.SetText(Text.SCANNER_BACKGROUND());
        backgroundHeader.SetFitToContent(true);
        backgroundHeader.SetMargin(new inkMargin(0.0, 10.0, 0.0, 0.0));
        backgroundHeader.SetTintColor(new HDRColor(1.0, 1.0, 1.0, 1.0));
        backgroundHeader.Reparent(netWatchDbReport);

        let background: ref<inkText> = new inkText();
        background.SetName(n"background");
        background.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        background.SetFontStyle(n"Medium");
        background.SetFontSize(25);
        background.SetTracking(1);
        background.SetMargin(new inkMargin(0.0, 5.0, 0.0, 0.0));
        background.SetTintColor(new HDRColor(0.1137255, 0.9294118, 0.5137255, 1.0));
        background.SetFitToContent(true);
        background.SetWrapping(false, 740.0, textWrappingPolicy.Default);
        background.Reparent(netWatchDbReport);

        let earlyLifeHeader: ref<inkText> = new inkText();
        earlyLifeHeader.SetName(n"early_life_header");
        earlyLifeHeader.SetFontFamily("base\\gameplay\\gui\\fonts\\orbitron\\orbitron.inkfontfamily");
        earlyLifeHeader.SetFontStyle(n"Medium");
        earlyLifeHeader.SetFontSize(17);
        earlyLifeHeader.SetLetterCase(textLetterCase.UpperCase);
        earlyLifeHeader.SetTracking(2);
        earlyLifeHeader.SetText(Text.SCANNER_CHILDHOOD());
        earlyLifeHeader.SetFitToContent(true);
        earlyLifeHeader.SetMargin(new inkMargin(0.0, 10.0, 0.0, 0.0));
        earlyLifeHeader.SetTintColor(new HDRColor(1.0, 1.0, 1.0, 1.0));
        earlyLifeHeader.Reparent(netWatchDbReport);
            
        let earlyLife: ref<inkText> = new inkText();
        earlyLife.SetName(n"early_life");
        earlyLife.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        earlyLife.SetFontStyle(n"Medium");
        earlyLife.SetFontSize(25);
        earlyLife.SetTracking(1);
        earlyLife.SetMargin(new inkMargin(0.0, 5.0, 0.0, 0.0));
        earlyLife.SetTintColor(new HDRColor(0.1137255, 0.9294118, 0.5137255, 1.0));
        earlyLife.SetFitToContent(true);
        earlyLife.SetWrapping(false, 740.0, textWrappingPolicy.Default);
        earlyLife.Reparent(netWatchDbReport);

        let significantEventsHeader: ref<inkText> = new inkText();
        significantEventsHeader.SetName(n"significant_events_header");
        significantEventsHeader.SetFontFamily("base\\gameplay\\gui\\fonts\\orbitron\\orbitron.inkfontfamily");
        significantEventsHeader.SetFontStyle(n"Medium");
        significantEventsHeader.SetFontSize(17);
        significantEventsHeader.SetLetterCase(textLetterCase.UpperCase);
        significantEventsHeader.SetTracking(2);
        significantEventsHeader.SetText(Text.SCANNER_SIG_EVENTS());
        significantEventsHeader.SetFitToContent(true);
        significantEventsHeader.SetMargin(new inkMargin(0.0, 10.0, 0.0, 0.0));
        significantEventsHeader.SetTintColor(new HDRColor(1.0, 1.0, 1.0, 1.0));
        significantEventsHeader.Reparent(netWatchDbReport);
            
        let significantEvents: ref<inkText> = new inkText();
        significantEvents.SetName(n"significant_events");
        significantEvents.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        significantEvents.SetFontStyle(n"Medium");
        significantEvents.SetFontSize(25);
        significantEvents.SetTracking(1);
        significantEvents.SetMargin(new inkMargin(0.0, 5.0, 0.0, 0.0));
        significantEvents.SetTintColor(new HDRColor(0.1137255, 0.9294118, 0.5137255, 1.0));
        significantEvents.SetWrapping(false, 740.0, textWrappingPolicy.Default);
        significantEvents.SetFitToContent(true);
        significantEvents.Reparent(netWatchDbReport);

        this.m_background = background;
        this.m_earlyLife = earlyLife;
        this.m_significantEvents = significantEvents;
	}

    public func SetBackstory(backstoryUI: BackstoryUI) {
        this.m_backstoryUI = backstoryUI;
        this.m_background.SetText(this.m_backstoryUI.background);
        this.m_earlyLife.SetText(this.m_backstoryUI.earlyLife);
        this.m_significantEvents.SetText(this.m_backstoryUI.significantEvents);
    }

    public func SetVisible(visible: Bool) {
        this.GetRootWidget().SetVisible(visible);
    }

    public static func Create() -> ref<NetWatchDBReport> {
		let self: ref<NetWatchDBReport> = new NetWatchDBReport();
		self.CreateInstance();
		return self;
	}
}