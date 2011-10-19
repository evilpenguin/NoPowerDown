/*
 * Project: NoPowerDown
 * Creator: EvilPenguin|
 * Version: 
 */

#include "PowerDownAlertView.h"
#include "Interfaces.h"

#define NOPOWERDOWN_PLIST @"/var/mobile/Library/Preferences/us.nakedproductions.nopowerdown.plist" 
#define listenToNotification$withCallBack(notification, callback); CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)&callback, CFSTR(notification), NULL, CFNotificationSuspensionBehaviorHold);

static PowerDownAlertView *enterAlert = nil;
static NSMutableDictionary *plistDict = nil;
static void loadSettings(void) {
	if (plistDict) {
		[plistDict release];
		plistDict = nil;
	}
	plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:NOPOWERDOWN_PLIST];
}

%hook SBPowerDownView
- (void)notifyDelegateOfPowerDown {
	if ([plistDict objectForKey:@"NoPowerDownEnabled"] ? [[plistDict objectForKey:@"NoPowerDownEnabled"] boolValue] : NO) {
		enterAlert = [[PowerDownAlertView alloc] init];
		enterAlert.delegate = self;
		[enterAlert showEnterPasswordAlert];
		return;
	}
	%orig; 
}

%new
 - (void)powerDown {
	NSLog(@"NoPowerDown: Peace Out Megaman");
	[(SpringBoard *)[%c(SpringBoard) sharedApplication] _powerDownNow];
}

%new
- (void) shouldNotPowerDown {
	NSLog(@"NoPowerDown: Not shutting down. Making everything back to normal");
	
	SBPowerDownController *controller = MSHookIvar<SBPowerDownController *>(self, "_powerDownController");
	[controller cancel];
	
	TPBottomLockBar *lockBar = MSHookIvar<TPBottomLockBar *>(self, "_lockView");
	[lockBar relock];
	
	[(SpringBoard *)[%c(SpringBoard) sharedApplication] showSpringBoardStatusBar];
	
	if (enterAlert != nil) { 
		[enterAlert release]; 
		enterAlert = nil;
	}
}
%end

%ctor {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	listenToNotification$withCallBack("us.nakedproductions.nopowerdown.update", loadSettings);
	loadSettings();
	[pool drain];
}