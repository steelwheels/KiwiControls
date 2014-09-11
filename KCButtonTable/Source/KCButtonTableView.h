/**
 * @file	KCButtonTableView.h
 * @brief	Define KCButtonTableView class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "KCButtonTableSource.h"
#import <KiwiControl/KiwiControl.h>

@interface KCButtonTableView : UIView
{
	KCButtonTableSource *		dataSource ;
	__unsafe_unretained IBOutlet UITableView *tableView;
}

- (void) setDelegate: (id <KCButtonTableDelegate>) delegate ;
  /** The class of this element : NSString */
- (void) setLabelNames: (NSArray *) names ;
- (void) setBorder ;
- (void) adjustSize ;
@end
