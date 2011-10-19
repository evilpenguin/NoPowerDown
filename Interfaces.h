/*
 *
 * PowerDownAlertView.h
 * Written by EvilPenguin|
 *
 *
 */


@interface SBUIController <PowerDownAlertViewDelegate>
- (void)finishedUnscattering;
@end

@interface SpringBoard : UIApplication 
- (void)showSpringBoardStatusBar;
- (void) _powerDownNow;
@end

@interface SBPowerDownController 
- (void)cancel;
@end

@interface SBPowerDownView <PowerDownAlertViewDelegate>
- (void)notifyDelegateOfPowerDown;
@end

@interface TPBottomLockBar
- (void)relock;
@end
