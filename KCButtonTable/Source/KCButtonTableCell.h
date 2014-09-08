/**
 * @file	KCButtonTableCell.h
 * @brief	Define KCButtonTableCell class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@interface KCButtonTableCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *tableButton;

- (CGSize) maxSize ;

@end
