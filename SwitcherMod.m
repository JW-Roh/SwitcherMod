#import <UIKit/UIKit.h>
#import <CaptainHook/CaptainHook.h>

#import <substrate.h>

@class SBAppSwitcherModel, SBNowPlayingBar, SBAppSwitcherBarView;


@interface SBIconLabel : UIControl 
@end
@interface SBIcon : UIView
@end
@interface SBApplicationIcon : SBIcon
- (id)initWithApplication:(id)fp8;
- (id)application;
- (UIImageView *)iconImageView;
- (void)setShadowsHidden:(BOOL)fp8;
@end
@interface SBDisplay : NSObject
- (void)kill;
@end
@interface SBApplication : SBDisplay
@end
@interface SBUIController
@end


@interface SBNowPlayingBarMediaControlsView {
    SBIconLabel *_trackLabel;
    SBIconLabel *_toggleLabel;
}
@end

@interface SBNowPlayingBarView {
    SBNowPlayingBarMediaControlsView *_mediaView;
}
- (id)mediaView;
@end

@interface SBNowPlayingBar {
    SBNowPlayingBarView *_barView;
}
@end

@interface SBAppSwitcherController : NSObject {
	SBAppSwitcherModel *_model;
	SBNowPlayingBar *_nowPlayingBar;
	SBAppSwitcherBarView *_bottomBar;
	SBApplicationIcon *_pushedIcon;
	BOOL _editing;
}
@property(nonatomic, readonly) SBAppSwitcherModel *model;
+ (id)sharedInstance;
- (void)viewWillAppear;
- (void)viewDidDisappear;
- (void)downloadRemoved:(id)fp8;
- (void)downloadChanged:(id)fp8;
- (void)downloadItemUpdatingStatusChanged:(id)fp8;
- (void)_quitButtonHit:(id)sender;
- (BOOL)_inEditMode;
- (void)_beginEditing;
- (void)_stopEditing;
//- (void)_removeApplicationFromRecents:(SBApplication *)application;
- (id)topAppDisplayID;							// 5.0
- (void)setTopAppDisplayID:(id)fp8;				// 5.0
@end

@interface SBAppSwitcherBarView : UIView {
}
+ (unsigned int)iconsPerPage:(int)page;
- (CGPoint)_firstPageOffset;
- (CGPoint)_firstPageOffset:(CGSize)size;
- (NSArray *)appIcons;							// 4.x
- (void)setEditing:(BOOL)editing;
- (CGRect)_frameForIndex:(NSUInteger)iconIndex withSize:(CGSize)size; // 4.0/4.1
- (CGRect)_iconFrameForIndex:(NSUInteger)iconIndex withSize:(CGSize)size; // 4.2
- (void)removeIcon:(SBApplicationIcon *)icon;
- (NSArray *)iconViews;							// 5.0
@end

@interface SBAppIconQuitButton : UIButton {
	SBApplicationIcon* _appIcon;
}
@property(retain, nonatomic) SBApplicationIcon *appIcon;
@end

@interface SBAppSwitcherModel : NSObject {
	NSMutableArray* _recentDisplayIdentifiers;
}
+ (id)sharedInstance;
- (void)_saveRecents;
- (id)_recentsFromPrefs;
- (void)addToFront:(SBApplication *)application;
- (void)remove:(SBApplication *)application;
- (SBApplication *)appAtIndex:(NSUInteger)index;
- (NSUInteger)count;
- (void)appsRemoved:(NSArray *)removedApplications added:(NSArray *)addedApplications;
@end

@interface SBIcon (OS40)
- (void)setCloseBox:(UIView *)view;
- (void)setShadowsHidden:(BOOL)hidden;
- (UIImageView *)iconImageView;
@end

@interface SBIcon (OS41)
- (void)setShowsCloseBox:(BOOL)shows;
- (void)closeBoxTapped;
@end

@interface SBProcess : NSObject {
}
- (BOOL)isRunning;
- (void)killWithSignal:(int)fp8;
@end

@interface SBApplication (OS40)
- (void)exitedNormally;
@property (nonatomic, readonly) SBProcess *process;
@end

@interface SBUIController (OS40)
- (void)_toggleSwitcher;
@end


@interface SBIconView : UIView //(OS50)
- (id)initWithDefaultSize;
- (void)setIcon:(id)fp8;
- (id)icon;
- (int)location;
- (void)setLocation:(int)fp8;
- (UIImageView *)iconImageView;
- (void)setIsHidden:(BOOL)fp8 animate:(BOOL)fp12;
- (BOOL)isHidden;
- (void)setIconImageAlpha:(float)fp8;
- (void)setIconLabelAlpha:(float)fp8;
- (void)setLabelHidden:(BOOL)fp8;
- (BOOL)isHighlighted;
- (void)setHighlighted:(BOOL)fp8;
- (void)setHighlighted:(BOOL)fp8 delayUnhighlight:(BOOL)fp12;
- (void)setShadowsHidden:(BOOL)fp8;
- (void)setShowsCloseBox:(BOOL)fp8;
- (void)setShowsCloseBox:(BOOL)fp8 animated:(BOOL)fp12;
- (id)locker;
- (void)setLocker:(id)fp8;
- (id)delegate;
- (void)setDelegate:(id)fp8;
@end

@interface SBFolderIcon : SBIcon
@end

@interface SBNewsstandIcon : SBFolderIcon
@end

@interface SBIconModel : NSObject
+ (id)sharedInstance;
- (id)applicationIconForDisplayIdentifier:(id)fp8;
@end

/*@interface SBIconViewMap
+ (id)homescreenMap;
+ (Class)iconViewClassForIcon:(id)fp8 location:(int)fp12;
@end*/


CHDeclareClass(SBAppSwitcherController);
CHDeclareClass(SBAppIconQuitButton);
CHDeclareClass(SBApplicationIcon);
CHDeclareClass(SBAppSwitcherBarView);
CHDeclareClass(SBUIController);

static BOOL SMShowActiveApp = NO;
static BOOL SMWiggleModeOff = YES;
static BOOL SMIconLabelsOff = NO;
static BOOL SMMIconEditingOn = NO;
static BOOL SMMCloseButtonShowAlways = NO;
static float SMExitedIconAlpha = 50.0f;
static NSInteger SMCloseButtonStyle = 0;
static NSInteger SMExitedAppStyle = 2;
static NSInteger SMMIconCount = 5;
static NSInteger SMMCloseButtonBehavior = 0;

static BOOL isFirmware5x = NO;


enum {
	SMCloseButtonStyleBlackClose = 0,
	SMCloseButtonStyleRedMinus = 1,
	SMCloseButtonStyleNone = 2
};

enum {
	SMExitedAppStyleTransparent = 0,
	SMExitedAppStyleHidden = 1,
	SMExitedAppStyleOpaque = 2
};

enum {
	SMMCloseButtonBehaviorDefault = 0,
	SMMCloseButtonBehaviorExitFirst = 1,
	SMMCloseButtonBehaviorExitOnly = 2,
	SMMCloseButtonBehaviorRemoveOnly = 3
};

static void LoadSettings()
{
	CHAutoreleasePoolForScope();
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/me.devbug.switchermodmini.plist"];
	SMMIconCount = [[dict objectForKey:@"SMMIconCount"] integerValue];
	SMShowActiveApp = [[dict objectForKey:@"SMShowActiveApp"] boolValue];
	SMExitedIconAlpha = [[dict objectForKey:@"SMExitedIconAlpha"] floatValue];
	if(!SMExitedIconAlpha) SMExitedIconAlpha = 50.0f;
	SMMCloseButtonShowAlways = [[dict objectForKey:@"SMMCloseButtonShowAlways"] boolValue];
	SMCloseButtonStyle = [[dict objectForKey:@"SMCloseButtonStyle"] integerValue];
	SMMCloseButtonBehavior = [[dict objectForKey:@"SMMCloseButtonBehavior"] integerValue];
	SMExitedAppStyle = [[dict objectForKey:@"SMExitedAppStyle"] integerValue];
	if(SMExitedAppStyle == 0) SMExitedAppStyle = SMExitedAppStyleOpaque;
	if([dict objectForKey:@"SMWiggleModeOff"] != nil) SMWiggleModeOff = [[dict objectForKey:@"SMWiggleModeOff"] boolValue];
	if([dict objectForKey:@"SMIconLabelsOff"] != nil) SMIconLabelsOff = [[dict objectForKey:@"SMIconLabelsOff"] boolValue];
	
	[dict release];
}

static SBApplication *activeApplication;


// To do : when updated app, icon should be transparent.

CHOptimizedMethod(1, self, void, SBAppSwitcherController, applicationLaunched, SBApplication *, application)
{
	CHSuper(1, SBAppSwitcherController, applicationLaunched, application);
	
	[self viewWillAppear];
}

CHOptimizedMethod(1, self, void, SBAppSwitcherController, applicationDied, SBApplication *, application)
{
	CHSuper(1, SBAppSwitcherController, applicationDied, application);
	
	SBAppSwitcherBarView *_bottomBar = CHIvar(self, _bottomBar, SBAppSwitcherBarView *);
	
	if (isFirmware5x == NO) {
		for (SBApplicationIcon *icon in [_bottomBar appIcons]) {
			if ([icon application] == application) {
				[icon iconImageView].alpha = SMExitedIconAlpha / 100;
				[icon setShadowsHidden:YES];
				
				break;
			}
		}
	} else {
		for (SBIconView *iconView in [_bottomBar iconViews]) {
			if ([[iconView icon] application] == application) {
				[iconView iconImageView].alpha = SMExitedIconAlpha / 100;
				[iconView setShadowsHidden:YES];
				
				break;
			}
		}
	}
}

CHOptimizedMethod(0, self, void, SBAppSwitcherController, _beginEditing)
{
	if (!SMWiggleModeOff && !SMMCloseButtonShowAlways)
		CHSuper(0, SBAppSwitcherController, _beginEditing);

	if (!SMMCloseButtonShowAlways)
		SMMIconEditingOn = YES;

	[self viewWillAppear];
}

CHOptimizedMethod(0, self, void, SBAppSwitcherController, _stopEditing)
{
	//if (!SMWiggleModeOff)
		CHSuper(0, SBAppSwitcherController, _stopEditing);

	SMMIconEditingOn = NO;
	
	[self viewWillAppear];
}

CHOptimizedMethod(0, self, BOOL, SBAppSwitcherController, _inEditMode)
{
	if (!SMWiggleModeOff)
		return CHSuper(0, SBAppSwitcherController, _inEditMode);
	
	return SMMIconEditingOn;
}


CHOptimizedMethod(1, self, NSUInteger, SBAppSwitcherController, closeBoxTypeForIcon, SBApplicationIcon *, icon)
{
	switch (SMCloseButtonStyle) {
		case SMCloseButtonStyleNone:
			return 2;
			break;
		case SMCloseButtonStyleBlackClose:
			return 0;
			break;
		case SMCloseButtonStyleRedMinus:
			return 1;
			break;
		default:
			return 1;
			break;
	}
	
}


CHOptimizedMethod(0, self, void, SBAppSwitcherController, viewWillAppear)
{
	CHSuper(0, SBAppSwitcherController, viewWillAppear);
	UIImage *image;
	switch (SMCloseButtonStyle) {
		case SMCloseButtonStyleBlackClose:
			image = [UIImage imageNamed:@"closebox"];
			break;
		case SMCloseButtonStyleRedMinus:
			image = [UIImage imageNamed:@"SwitcherQuitBox"];
			break;
		default:
			image = nil;
			break;
	}
	
	SBAppSwitcherBarView *_bottomBar = CHIvar(self, _bottomBar, SBAppSwitcherBarView *);
	
	if (isFirmware5x == NO) {
		for (SBApplicationIcon *icon in [_bottomBar appIcons]) {
			if (CHIsClass(icon, SBApplicationIcon)) {
				SBApplication *application = [icon application];
				BOOL isRunning = [[application process] isRunning];
				[icon iconImageView].alpha = isRunning ?  1.0f : (SMExitedIconAlpha / 100);
				[icon setShadowsHidden:!isRunning];
			
				SBIconLabel *label = CHIvar(icon, _label, SBIconLabel *);
				[label setAlpha:(SMIconLabelsOff) ? 0.0f : 1.0f];
	//			[icon setDrawsLabel:(SMIconLabelsOff) ? NO : YES];
						
				if (((image == nil) && !SMMCloseButtonShowAlways) || (application == activeApplication))
				{
					if([icon respondsToSelector:@selector(setShowsCloseBox:)])
						[icon setShowsCloseBox:NO];
					else
						[icon setCloseBox:nil];
				}
				else
				{
					SBAppIconQuitButton *button = [CHClass(SBAppIconQuitButton) buttonWithType:UIButtonTypeCustom];
					[button setAppIcon:(SBApplicationIcon *)icon];
					[button setImage:image forState:0];
					[button addTarget:self action:@selector(_quitButtonHit:) forControlEvents:UIControlEventTouchUpInside];
					[button sizeToFit];
					CGRect frame = button.frame;
					frame.origin.x -= 10.0f;
					frame.origin.y -= 10.0f;
					button.frame = frame;
					if ((/*SMWiggleModeOff &&*/ SMMIconEditingOn) || SMMCloseButtonShowAlways) {
						if([icon respondsToSelector:@selector(setShowsCloseBox:)])
						{
	//						[icon setShowsCloseBox:NO];
							[icon setShowsCloseBox:YES];
						}
						else
							[icon setCloseBox:button];
					} else [icon setShowsCloseBox:NO];
				}
			}
		}
	} else {
		for (SBIconView *iconView in [_bottomBar iconViews]) {
			if (CHIsClass([iconView icon], SBApplicationIcon) || [NSStringFromClass([[iconView icon] class]) isEqualToString:@"SBNewsstandIcon"]) {
				SBApplication *application = nil;
				BOOL isRunning = YES;
				
				if (CHIsClass([iconView icon], SBApplicationIcon)) {
					application = [[iconView icon] application];
					isRunning = [[application process] isRunning];
				}
				[iconView iconImageView].alpha = isRunning ?  1.0f : (SMExitedIconAlpha / 100);
				[iconView setShadowsHidden:!isRunning];
				
				[iconView setLabelHidden:SMIconLabelsOff];
				
				if (((image == nil) && !SMMCloseButtonShowAlways) || (activeApplication != nil && application == activeApplication)) {
					[iconView setShowsCloseBox:NO];
				} else {
					if ((/*SMWiggleModeOff &&*/ SMMIconEditingOn) || SMMCloseButtonShowAlways) {
						[iconView setShowsCloseBox:YES];
					} else 
						[iconView setShowsCloseBox:NO];
				}
			}
		}
	}
}

CHOptimizedMethod(1, self, void, SBAppSwitcherController, iconTapped, id, icon)
{
	if (isFirmware5x == NO) {
		if ([(SBApplicationIcon *)icon application] == activeApplication)
			[CHSharedInstance(SBUIController) _toggleSwitcher];
		else
			CHSuper(1, SBAppSwitcherController, iconTapped, icon);
	} else {
		if (activeApplication != nil && [[(SBIconView *)icon icon] application] == activeApplication)
			[CHSharedInstance(SBUIController) _toggleSwitcher];
		else
			CHSuper(1, SBAppSwitcherController, iconTapped, icon);
	}
}

// for iOS 4x
CHOptimizedMethod(2, self, NSArray *, SBAppSwitcherController, _applicationIconsExcept, SBApplication *, application, forOrientation, UIInterfaceOrientation, orientation)
{
	[activeApplication release];
	activeApplication = [application copy];
	if (SMShowActiveApp)
		application = nil;
	if (SMExitedAppStyle == SMExitedAppStyleHidden) {
		NSMutableArray *newResult = [NSMutableArray array];
		for (SBApplicationIcon *icon in CHSuper(2, SBAppSwitcherController, _applicationIconsExcept, application, forOrientation, orientation))
			if ([[[icon application] process] isRunning])
				[newResult addObject:icon];
		return newResult;
	} else {
		return CHSuper(2, SBAppSwitcherController, _applicationIconsExcept, application, forOrientation, orientation);
	}
}

// for iOS 5
CHOptimizedMethod(0, self, NSArray *, SBAppSwitcherController, _applicationIconsExceptTopApp)
{
	SBApplicationIcon *appIcon = [[NSClassFromString(@"SBIconModel") sharedInstance] applicationIconForDisplayIdentifier:[self topAppDisplayID]];
	SBApplication *application = [appIcon application];
	
	[activeApplication release];
	activeApplication = [application copy];
	
	NSMutableArray *newResult = [NSMutableArray array];
	
	if (SMShowActiveApp && appIcon != nil) {
		SBIconView *iconView = [[[NSClassFromString(@"SBIconView") alloc] initWithDefaultSize] autorelease];
		
		if (iconView != nil) {
			[iconView setLocation:2];
			[iconView setDelegate:self];
			[iconView setIcon:appIcon];
			[newResult addObject:iconView];
		}
	}
	
	NSArray *appIcons = CHSuper(0, SBAppSwitcherController, _applicationIconsExceptTopApp);
	
	if (SMExitedAppStyle == SMExitedAppStyleHidden) {
		for (SBIconView *iconView in appIcons)
			if ([[[[iconView icon] application] process] isRunning])
				[newResult addObject:iconView];
	} else {
		for (SBIconView *iconView in appIcons)
			[newResult addObject:iconView];
	}
	
	return newResult;
}


CHOptimizedMethod(1, self, void, SBAppSwitcherController, iconCloseBoxTapped, id, icon)
{
	if (SMMCloseButtonBehavior == SMMCloseButtonBehaviorDefault) {
		CHSuper(1, SBAppSwitcherController, iconCloseBoxTapped, icon);
		return;
	} else if (SMMCloseButtonBehavior == SMMCloseButtonBehaviorRemoveOnly) {
		SBAppSwitcherBarView *_bottomBar = CHIvar(self, _bottomBar, SBAppSwitcherBarView *);
		[_bottomBar removeIcon:icon];
		return;
	}

	SBApplication *application = nil;
	if (isFirmware5x == NO)
		application = [(SBApplicationIcon *)icon application];
	else 
		application = [[(SBIconView *)icon icon] application];
	
	BOOL isRunning = [[application process] isRunning];
	
	if (isRunning) {
		[application kill];
		//[[application process] killWithSignal:SIGTERM];
	} else {
		if (SMMCloseButtonBehavior != SMMCloseButtonBehaviorExitOnly)
			CHSuper(1, SBAppSwitcherController, iconCloseBoxTapped, icon);
	}
}


CGRect make_frame(SBAppSwitcherBarView *self, int index, CGSize size, CGRect orig) {
	CGRect r = orig;
	int iconsPerPage = [[self class] iconsPerPage:0];
	
	if (iconsPerPage < 1 || iconsPerPage > 10)
		iconsPerPage = SMMIconCount;
	
	if (iconsPerPage != SMMIconCount)
		iconsPerPage = SMMIconCount;
	
	int page = index / iconsPerPage;
	CGFloat gap = ([self frame].size.width - (r.size.width * iconsPerPage)) / (iconsPerPage + 1);
	r.origin.x = gap;

	if ([self respondsToSelector:@selector(_firstPageOffset)]) r.origin.x += [self _firstPageOffset].x;
	else r.origin.x += [self _firstPageOffset:[self frame].size].x;
	r.origin.x += (gap + size.width) * index;
	r.origin.x += (gap * page);
	r.origin.x = floorf(r.origin.x);

	return r;
}

CHOptimizedMethod(1, self, unsigned int, SBAppSwitcherBarView, iconsPerPage, int, page) {
	if (SMMIconCount < 1 || SMMIconCount > 10)
		SMMIconCount = 5;
	
	return SMMIconCount;
}

// 4.0 and 4.1
CHOptimizedMethod(2, self, CGRect, SBAppSwitcherBarView, _frameForIndex, NSUInteger, index, withSize, CGSize, size) {
    return make_frame(self, index, size, CHSuper(2, SBAppSwitcherBarView, _frameForIndex, index, withSize, size));
}

CHOptimizedMethod(1, self, CGPoint, SBAppSwitcherBarView, _firstPageOffset, CGSize, offset) {
    CHLog(@"_firstPageOffset");
    return CHSuper(1, SBAppSwitcherBarView, _firstPageOffset, offset);
}

// 4.2 and 5.0
CHOptimizedMethod(2, self, CGRect, SBAppSwitcherBarView, _iconFrameForIndex, NSUInteger, index, withSize, CGSize, size) {
    return make_frame(self, index, size, CHSuper(2, SBAppSwitcherBarView, _iconFrameForIndex, index, withSize, size));
}


CHConstructor {
	Class $SBAppSwitcherController = objc_getClass("SBAppSwitcherController");
	isFirmware5x = (class_getInstanceMethod($SBAppSwitcherController, @selector(_applicationIconsExcept:forOrientation:)) == NULL);
	
	CHLoadLateClass(SBAppSwitcherController);
	CHHook(1, SBAppSwitcherController, applicationLaunched);
	CHHook(1, SBAppSwitcherController, applicationDied);
	CHHook(0, SBAppSwitcherController, _beginEditing);
	CHHook(0, SBAppSwitcherController, _stopEditing);
	CHHook(0, SBAppSwitcherController, _inEditMode);
	CHHook(0, SBAppSwitcherController, viewWillAppear);
	CHHook(1, SBAppSwitcherController, closeBoxTypeForIcon);
	CHHook(1, SBAppSwitcherController, iconTapped);
	CHHook(1, SBAppSwitcherController, iconCloseBoxTapped);
	CHHook(2, SBAppSwitcherController, _applicationIconsExcept, forOrientation);
	CHHook(0, SBAppSwitcherController, _applicationIconsExceptTopApp);

	CHLoadLateClass(SBAppSwitcherBarView);
	CHHook(1, SBAppSwitcherBarView, iconsPerPage);
	CHHook(2, SBAppSwitcherBarView, _frameForIndex, withSize);
	CHHook(1, SBAppSwitcherBarView, _firstPageOffset);
	CHHook(2, SBAppSwitcherBarView, _iconFrameForIndex, withSize);
	
	CHLoadLateClass(SBAppIconQuitButton);
	CHLoadLateClass(SBApplicationIcon);

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (void *)LoadSettings, CFSTR("me.devbug.switchermodmini.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	LoadSettings();

	CHLoadLateClass(SBUIController);
}
