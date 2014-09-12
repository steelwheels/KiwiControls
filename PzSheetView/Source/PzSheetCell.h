/**
 * @file	PzSheetCell.h
 * @brief	Define PzSheetCell class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@interface PzSheetCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *resultLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *expressionField;

- (void) observeValueForKeyPath:(NSString *) keyPath ofObject:(id)object change:(NSDictionary *)change context: (void *)context ;

@end