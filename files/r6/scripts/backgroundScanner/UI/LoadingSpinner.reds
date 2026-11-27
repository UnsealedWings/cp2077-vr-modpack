module CrowdScanner.UI

import Codeware.UI.inkCustomController
import Codeware.UI.ThemeColors

public class LoadingSpinner extends inkCustomController {

    protected let m_progressSpinner: wref<inkImage>;

    protected let rotationAnimationProxy: ref<inkAnimProxy>;

    protected let rotationAnimation: ref<inkAnimDef>;

    protected let rotationInterpolator: ref<inkAnimRotation>;

    protected cb func OnInitialize() -> Bool {
        let animOptions: inkAnimOptions;
        animOptions.loopType = inkanimLoopType.Cycle;
        animOptions.loopInfinite = true;
        this.rotationAnimation = new inkAnimDef();
        this.rotationInterpolator = new inkAnimRotation();
        this.rotationInterpolator.SetDuration(1.00);
        this.rotationInterpolator.SetDirection(inkanimInterpolationDirection.To);
        this.rotationInterpolator.SetType(inkanimInterpolationType.Linear);
        this.rotationInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
        this.rotationInterpolator.SetEndRotation(180.00);
        this.rotationAnimation.AddInterpolator(this.rotationInterpolator);
        this.m_progressSpinner.SetVisible(true);
        this.m_progressSpinner.PlayAnimationWithOptions(this.rotationAnimation, animOptions);
    }

    protected cb func OnCreate() -> Void {
        this.CreateWidgets();
    }

    protected func CreateWidgets() -> Void {
        let loadingProgress: ref<inkCanvas> = new inkCanvas();
        loadingProgress.SetName(n"LoadingProgress");
        loadingProgress.SetMargin(new inkMargin(0.0, 0, 0, 0.0));
        loadingProgress.SetAnchor(inkEAnchor.TopLeft);
        loadingProgress.SetSize(new Vector2(100.0, 100.0));

        let progressSpinner: ref<inkImage> = new inkImage();
        progressSpinner.SetName(n"Spinner");
        progressSpinner.SetAtlasResource(r"base\\gameplay\\gui\\widgets\\notifications\\notification_game_saved.inkatlas");
        progressSpinner.SetTexturePart(n"spinner");
        progressSpinner.SetFitToContent(true);
        progressSpinner.SetMargin(new inkMargin(82.0, 0.0, 0.0, 0.0));
        progressSpinner.SetHAlign(inkEHorizontalAlign.Center);
        progressSpinner.SetVAlign(inkEVerticalAlign.Center);
        progressSpinner.SetAnchor(inkEAnchor.CenterLeft);
        progressSpinner.SetAnchorPoint(new Vector2(1.0, 0.5));
        progressSpinner.SetSize(new Vector2(100.0, 100.0));
        progressSpinner.SetScale(new Vector2(0.95, 0.95));

        progressSpinner.SetTintColor(ThemeColors.LightGreen());
        progressSpinner.SetRotation(0.0);
        this.m_progressSpinner = progressSpinner;
        this.m_progressSpinner.Reparent(loadingProgress);

        let framefluff: ref<inkCanvas> = new inkCanvas();
        framefluff.SetName(n"framefluff");
        framefluff.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
        framefluff.SetHAlign(inkEHorizontalAlign.Center);
        framefluff.SetVAlign(inkEVerticalAlign.Center);
        framefluff.SetAnchor(inkEAnchor.TopLeft);
        framefluff.SetSize(new Vector2(100.0, 100.0));
        framefluff.Reparent(loadingProgress);

        let progressSpinnerFrame: ref<inkImage> = new inkImage();
        progressSpinnerFrame.SetName(n"progressSpinnerFrame");
        progressSpinnerFrame.SetState(n"frame");
        progressSpinnerFrame.SetAtlasResource(r"base\\gameplay\\gui\\fullscreen\\inventory\\inventory4_atlas.inkatlas");
        progressSpinnerFrame.SetTexturePart(n"itemGridFrame3Big");
        progressSpinnerFrame.SetFitToContent(true);
        progressSpinnerFrame.SetHAlign(inkEHorizontalAlign.Center);
        progressSpinnerFrame.SetVAlign(inkEVerticalAlign.Center);
        progressSpinnerFrame.SetAnchor(inkEAnchor.Fill);
        progressSpinnerFrame.SetAnchorPoint(new Vector2(0.5, 0.5));
        progressSpinnerFrame.SetTintColor(ThemeColors.LightGreen());
        progressSpinnerFrame.SetSize(new Vector2(32.0, 32.0));
        progressSpinnerFrame.Reparent(framefluff);

        let progressSpinnerCircle: ref<inkImage> = new inkImage();
        progressSpinnerCircle.SetName(n"progressSpinnerCircle");
        progressSpinnerCircle.SetAtlasResource(r"base\\gameplay\\gui\\quests\\assets\\personal_link.inkatlas");
        progressSpinnerCircle.SetTexturePart(n"Circle");
        progressSpinnerCircle.SetFitToContent(true);
        progressSpinnerCircle.SetHAlign(inkEHorizontalAlign.Center);
        progressSpinnerCircle.SetVAlign(inkEVerticalAlign.Center);
        progressSpinnerCircle.SetAnchor(inkEAnchor.Fill);
        progressSpinnerCircle.SetAnchorPoint(new Vector2(0.5, 0.5));
        progressSpinnerCircle.SetOpacity(0.3);
        progressSpinnerCircle.SetTintColor(ThemeColors.LightGreen());
        progressSpinnerCircle.SetSize(new Vector2(32.0, 32.0));
        progressSpinnerCircle.SetScale(new Vector2(0.88, 0.88));
        progressSpinnerCircle.Reparent(framefluff);

        this.SetRootWidget(loadingProgress);
	}

    public static func Create() -> ref<LoadingSpinner> {
		let self: ref<LoadingSpinner> = new LoadingSpinner();
		self.CreateInstance();
		return self;
	}
}