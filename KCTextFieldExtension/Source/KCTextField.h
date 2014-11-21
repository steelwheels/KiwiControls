/**
 * @file	KCTextField.h
 * @brief	Define KCTextField class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "KCTextFieldForwarders.h"

@protocol KCTextFieldDelegate <UITextFieldDelegate>

- (BOOL) isScrollingNow ;

@end

@interface KCTextField : UITextField

- (void) setDelegate:(id <KCTextFieldDelegate>) delegate ;



- (void) executeCommand: (KCTextFieldCommand *) command ;

@end
