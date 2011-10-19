/*
 *
 * PowerDownAlertView.h
 * Written by EvilPenguin|
 *
 *
 */

#define NOPOWERDOWN_PLIST @"/var/mobile/Library/Preferences/us.nakedproductions.nopowerdown.plist"

@protocol PowerDownAlertViewDelegate <NSObject>
	@required
	    - (void) releaseAlert;
	@optional
	    - (void)powerDown;
	    - (void)shouldNotPowerDown;
@end

@interface PowerDownAlertView : NSObject <UIAlertViewDelegate>  {
	NSMutableDictionary *defaultPlist;
	UIAlertView         *setPasswordAlert;
	UITextField         *passwordSetField;
    UIAlertView         *enterPasswordAlert;
	UITextField         *passwordEnterField;
	id                  delegate;
}
@property (nonatomic, assign) id <PowerDownAlertViewDelegate> delegate;

- (id) init;
- (void) showSetPasswordAlert;
- (void) showEnterPasswordAlert;
@end

/******************************************************************************************/

@interface UIAlertView ()
	- (id)addTextFieldWithValue:(id)value label:(id)label;
	- (id)textFieldAtIndex:(int)index;
	- (void)showWithAnimationType:(int)animationType;
@end