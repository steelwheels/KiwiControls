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

@end
