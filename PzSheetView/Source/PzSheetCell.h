/**
 * @file	PzSheetCell.h
 * @brief	Define PzSheetCell class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import <KCTouchableLabel/KCTouchableLabel.h>
#import <KCTextFieldCell/KCTextFieldCell.h>

@interface PzSheetCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet KCTouchableLabel *	touchableLabel;
@property (unsafe_unretained, nonatomic) IBOutlet KCTextFieldCell *	expressionField;

@end
