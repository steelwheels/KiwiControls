/**
 * @file	KCButtonTableCell.h
 * @brief	Define KCButtonTableCell class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import <KiwiControl/KiwiControl.h>

@interface KCButtonTableCell : UITableViewCell <KCViewSizeAdjusting>

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *tableButton;

@end
