/**
 * @file	PzSheetView.h
 * @brief	Define PzSheetView class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "PzSheetDataSource.h"

@interface PzSheetView : UIView
{
	UITableView *		tableView ;
	PzSheetDataSource *	dataSource ;
}

- (void) setResultValue: (PzSheetValue *) value forIndex: (NSInteger) index ;

@end
