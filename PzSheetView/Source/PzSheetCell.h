/**
 * @file	PzSheetCell.h
 * @brief	Define PzSheetCell class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import <KCTouchableLabel/KCTouchableLabel.h>
#import <KCTextFieldExtension/KCTextFieldExtension.h>

@interface PzSheetCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet KCTouchableLabel *	touchableLabel;
@property (unsafe_unretained, nonatomic) IBOutlet KCTextField *		expressionField;

@end
