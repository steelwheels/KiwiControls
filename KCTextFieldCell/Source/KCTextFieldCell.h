/**
 * @file	KCTextFieldCell.h
 * @brief	Define KCTextFieldCell class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@protocol KCTextFieldCellDelegate <UITextFieldDelegate>

- (BOOL) isScrollingNow ;

@end

@interface KCTextFieldCell : UITextField

- (void) setDelegate:(id <KCTextFieldCellDelegate>) delegate ;

@end
