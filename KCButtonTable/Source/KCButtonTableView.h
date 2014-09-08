/**
 * @file	KCButtonTableView.h
 * @brief	Define KCButtonTableView class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "KCButtonTableSource.h"

@interface KCButtonTableView : UIView 
{
	KCButtonTableSource *		dataSource ;
	UITableView *			buttonTableView;
}

- (void) setDelegate: (id <KCButtonTableDelegate>) delegate ;
  /** The class of this element : NSString */
- (void) setLabelNames: (NSArray *) names ;
- (void) adjustSize ;
@end
