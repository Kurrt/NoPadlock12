@interface SBUIProudLockIconView : UIView
-(void)_configureAutolayoutFlagsNeedingLayout:(BOOL)arg1;
@end

static BOOL NPL_hide = YES;
static float NPL_x = 0.f;
static float NPL_y = 0.f;
static float NPL_origx;
static float NPL_origy;
static SBUIProudLockIconView *NPL_lock;

%hook SBUIProudLockIconView

-(void)layoutSubviews {
	%orig;
	NPL_lock = self;
	self.hidden = NPL_hide;
	if (!NPL_hide) {
		NPL_origx = (NPL_origx) ? NPL_origx : self.frame.origin.x;
		NPL_origy = (NPL_origy) ? NPL_origy : self.frame.origin.y;
		self.frame = CGRectMake(NPL_origx + NPL_x, NPL_origy + NPL_y, self.frame.size.width, self.frame.size.height);
		// Thanks to https://github.com/MDausch/LatchKey for the idea for this next part
		UIView *vw = self;
        while (vw) {
            for (NSLayoutConstraint *constraint in vw.constraints)
                if (constraint.firstItem == self || constraint.secondItem == self) [vw removeConstraint:constraint];
            vw = vw.superview;
        }
        self.translatesAutoresizingMaskIntoConstraints = YES;
        [self _configureAutolayoutFlagsNeedingLayout:NO];
    }
}

%end


static void loadPrefs() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.kurrt.nopadlock12prefs.plist"];
    if(prefs) {
        NPL_hide = ([prefs objectForKey:@"NPL_hide"] ? [[prefs objectForKey:@"NPL_hide"] boolValue] : NPL_hide);
        NPL_x = ([prefs objectForKey:@"NPL_x"] ? [[prefs objectForKey:@"NPL_x"] floatValue] : NPL_x);
        NPL_y = ([prefs objectForKey:@"NPL_y"] ? [[prefs objectForKey:@"NPL_y"] floatValue] : NPL_y);
	}
    [prefs release];
	if (NPL_lock) [NPL_lock layoutSubviews];
}

%ctor {
    	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.kurrt.nopadlock12prefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    	loadPrefs();
}