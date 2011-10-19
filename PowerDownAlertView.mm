/*
 *
 * PowerDownAlertView.mm
 * Written by EvilPenguin|
 *
 *
 */

#import "PowerDownAlertView.h"

@implementation PowerDownAlertView 
@synthesize delegate;

// NoAlertView LifeCycle

- (id) init {
	self = [super init];
	if (self) {
        defaultPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:NOPOWERDOWN_PLIST];
        if (defaultPlist == nil) { defaultPlist = [[NSMutableDictionary alloc] init]; }
        
        setPasswordAlert    = nil;
        passwordSetField    = nil;
        enterPasswordAlert  = nil;
        passwordEnterField  = nil;
    }
	return self;
}

// Public Methods

- (void) showSetPasswordAlert {
    setPasswordAlert = [[UIAlertView alloc] initWithTitle:@"NoPowerDown Password"
                                                  message:@"Please enter a password for shutting down. You can change this password from Settings"
                                                 delegate:self 
                                        cancelButtonTitle:@"Cancel"  
                                        otherButtonTitles:@"Submit", nil];
    
	[setPasswordAlert addTextFieldWithValue:@"" label:@"Password"];
    setPasswordAlert.tag = 44;
	passwordSetField = [setPasswordAlert textFieldAtIndex:0];
	passwordEnterField.keyboardType = UIKeyboardTypeAlphabet;
	passwordEnterField.keyboardAppearance = UIKeyboardAppearanceAlert;
	passwordEnterField.autocorrectionType = UITextAutocorrectionTypeNo;
	passwordEnterField.secureTextEntry = YES;
	[setPasswordAlert show];
}

- (void) showEnterPasswordAlert {
    enterPasswordAlert = [[UIAlertView alloc] initWithTitle:@"NoPowerDown Warning"
                                                    message:@"Password needed to shutdown."
                                                   delegate:self 
                                          cancelButtonTitle:@"Cancel"  
                                          otherButtonTitles:nil, nil];
    enterPasswordAlert.tag = 45;
    
	if ([defaultPlist objectForKey:@"NoPowerDownPasswordEnabled"] ? [[defaultPlist objectForKey:@"NoPowerDownPasswordEnabled"] boolValue] : YES) {
		[enterPasswordAlert addButtonWithTitle:@"Submit"];
		[enterPasswordAlert addTextFieldWithValue:@"" label:@"Password"];
		passwordEnterField = [enterPasswordAlert textFieldAtIndex:0];
		passwordEnterField.secureTextEntry = YES;
		passwordEnterField.keyboardType = UIKeyboardTypeAlphabet;
		passwordEnterField.keyboardAppearance = UIKeyboardAppearanceAlert;
		passwordEnterField.autocorrectionType = UITextAutocorrectionTypeNo;
	}
	else { 
		[enterPasswordAlert addButtonWithTitle:@"Contine"];
		enterPasswordAlert.message = @"Would you like to continue shutting down?";
	}
	[enterPasswordAlert showWithAnimationType:1];
	[enterPasswordAlert show];
}

// AlertView Delegates

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (actionSheet.tag) {
        case 44:
            if (buttonIndex == 1) {
                [defaultPlist setObject:passwordSetField.text forKey:@"NoPowerDownPassword"];
            }
            [defaultPlist setObject:@"YES" forKey:@"NoPowerDownHasPassword"];
            [defaultPlist writeToFile:NOPOWERDOWN_PLIST atomically:YES];
            
            [self.delegate performSelector:@selector(releaseAlert) withObject:nil];
            break;
        case 45:
            if (buttonIndex == 1) {
                if ([defaultPlist objectForKey:@"NoPowerDownPasswordEnabled"] ? [[defaultPlist objectForKey:@"NoPowerDownPasswordEnabled"] boolValue] : NO) {
                    NSString *password = [defaultPlist objectForKey:@"NoPowerDownPassword"];
                    if ([passwordEnterField.text isEqualToString:password]) [self.delegate performSelector:@selector(powerDown) withObject:nil];
                    else [self.delegate performSelector:@selector(shouldNotPowerDown) withObject:nil]; 
                }
                else  [self.delegate performSelector:@selector(powerDown) withObject:nil];
            }
            else [self.delegate performSelector:@selector(shouldNotPowerDown) withObject:nil];
            break;
        default:
            break;
    }
}

// Memory

- (void) dealloc {
    if (setPasswordAlert != nil) [setPasswordAlert release];
    if (enterPasswordAlert!= nil) [enterPasswordAlert release];
	[defaultPlist release];
	[super dealloc];
}

@end