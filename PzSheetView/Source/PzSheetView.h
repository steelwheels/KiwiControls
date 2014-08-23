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

- (void) activateFirstResponder ;

- (void) moveCursorForwardInExpressionField ;
- (void) moveCursorBackwardInExpressionField ;
- (void) selectNextExpressionField ;

- (void) insertStringToExpressionField: (NSString *) str ;
- (void) setResultValue: (PzSheetValue *) value forSlot: (NSInteger) index ;

@end
