module CrowdScanner.UI

import Codeware.UI.inkCustomController
import Codeware.UI.ThemeColors

public class NetWatchDBLoadingStatus extends inkCustomController {

    protected let m_connectionText: wref<inkText>;

    protected let m_fetchText: wref<inkText>;

    protected let m_foundText: wref<inkText>;

    protected let m_loadText: wref<inkText>;

    protected let m_completeText: wref<inkText>;

    protected cb func OnInitialize() -> Bool {
        let alphaFadeIn = new inkAnimDef();
        let alphaInterpolator = new inkAnimTransparency();
        alphaInterpolator.SetDuration(0.01);
        alphaInterpolator.SetStartTransparency(0.0);
        alphaInterpolator.SetEndTransparency(1.0);
        alphaInterpolator.SetType(inkanimInterpolationType.Linear);
        alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
        alphaFadeIn.AddInterpolator(alphaInterpolator);

        let connectionAnimOptions: inkAnimOptions;
        connectionAnimOptions.executionDelay = 0.0;

        let fetchAnimOptions: inkAnimOptions;
        fetchAnimOptions.executionDelay = 0.15;

        let foundAnimOptions: inkAnimOptions;
        foundAnimOptions.executionDelay = 0.3;

        let loadAnimOptions: inkAnimOptions;
        loadAnimOptions.executionDelay = 0.45;

        let completeAnimOptions: inkAnimOptions;
        completeAnimOptions.executionDelay = 0.6;

        this.m_connectionText.PlayAnimationWithOptions(alphaFadeIn, connectionAnimOptions);
        this.m_fetchText.PlayAnimationWithOptions(alphaFadeIn, fetchAnimOptions);
        this.m_foundText.PlayAnimationWithOptions(alphaFadeIn, foundAnimOptions);
        this.m_loadText.PlayAnimationWithOptions(alphaFadeIn, loadAnimOptions);
        this.m_completeText.PlayAnimationWithOptions(alphaFadeIn, completeAnimOptions);
    }

    protected cb func OnCreate() -> Void {
        this.CreateWidgets();
    }

    protected func CreateWidgets() -> Void {
        let netWatchDbLoadingStatus: ref<inkHorizontalPanel> = new inkHorizontalPanel();
        netWatchDbLoadingStatus.SetName(n"NetWatchDBLoadingStatus");
        netWatchDbLoadingStatus.SetFitToContent(true);
        this.SetRootWidget(netWatchDbLoadingStatus);

        let leftPanel: ref<inkVerticalPanel> = new inkVerticalPanel();
        leftPanel.SetName(n"LeftPanel");
        leftPanel.SetFitToContent(true);
        leftPanel.Reparent(netWatchDbLoadingStatus);
        
        let loadingSpinner = LoadingSpinner.Create();
        loadingSpinner.Reparent(leftPanel);

        let rightPanel: ref<inkVerticalPanel> = new inkVerticalPanel();
        rightPanel.SetMargin(new inkMargin(10.0, 0.0, 0.0, 0.0));
        rightPanel.SetFitToContent(true);
        rightPanel.Reparent(netWatchDbLoadingStatus);

        let connectionText: ref<inkText> = new inkText();
        connectionText.SetFontFamily("base\\gameplay\\gui\\fonts\\arame\\arame.inkfontfamily");
        connectionText.SetFontStyle(n"Regular");
        connectionText.SetFontSize(12);
        connectionText.SetTracking(1);
        connectionText.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
        connectionText.SetTintColor(ThemeColors.LightGreen());
        connectionText.SetText("CONNECTION NETWATCH 152.71.30...");
        this.m_connectionText = connectionText;
        this.m_connectionText.Reparent(rightPanel);

        let fetchText: ref<inkText> = new inkText();
        fetchText.SetFontFamily("base\\gameplay\\gui\\fonts\\arame\\arame.inkfontfamily");
        fetchText.SetFontStyle(n"Regular");
        fetchText.SetFontSize(12);
        fetchText.SetTracking(1);
        fetchText.SetMargin(new inkMargin(0.0, 5.0, 0.0, 0.0));
        fetchText.SetTintColor(ThemeColors.LightGreen());
        fetchText.SetText("FETCHING RECORDS FOR CITIZEN ID: (JNH-102-FA4CA)...");
        this.m_fetchText = fetchText;
        this.m_fetchText.Reparent(rightPanel);

        let foundText: ref<inkText> = new inkText();
        foundText.SetFontFamily("base\\gameplay\\gui\\fonts\\arame\\arame.inkfontfamily");
        foundText.SetFontStyle(n"Regular");
        foundText.SetFontSize(12);
        foundText.SetTracking(1);
        foundText.SetMargin(new inkMargin(0.0, 5.0, 0.0, 0.0));
        foundText.SetTintColor(ThemeColors.LightGreen());
        foundText.SetText("RECORD FOUND...");
        this.m_foundText = foundText;
        this.m_foundText.Reparent(rightPanel);

        let loadText: ref<inkText> = new inkText();
        loadText.SetFontFamily("base\\gameplay\\gui\\fonts\\arame\\arame.inkfontfamily");
        loadText.SetFontStyle(n"Regular");
        loadText.SetFontSize(12);
        loadText.SetTracking(1);
        loadText.SetMargin(new inkMargin(0.0, 5.0, 0.0, 0.0));
        loadText.SetTintColor(ThemeColors.LightGreen());
        loadText.SetText("LOAD ADDRESS x0FDA444155...");
        this.m_loadText = loadText;
        this.m_loadText.Reparent(rightPanel);

        let completeText: ref<inkText> = new inkText();
        completeText.SetFontFamily("base\\gameplay\\gui\\fonts\\arame\\arame.inkfontfamily");
        completeText.SetFontStyle(n"Regular");
        completeText.SetFontSize(12);
        completeText.SetTracking(1);
        completeText.SetMargin(new inkMargin(0.0, 5.0, 0.0, 0.0));
        completeText.SetTintColor(ThemeColors.LightGreen());
        completeText.SetText("COMPLETE");
        this.m_completeText = completeText;
        this.m_completeText.Reparent(rightPanel);
	}

    public func SetVisible(visible: Bool) {
        this.GetRootWidget().SetVisible(visible);
    }

    public static func Create() -> ref<NetWatchDBLoadingStatus> {
		let self: ref<NetWatchDBLoadingStatus> = new NetWatchDBLoadingStatus();
		self.CreateInstance();
		return self;
	}
}