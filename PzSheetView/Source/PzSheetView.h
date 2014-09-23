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
	UITableView *			tableView ;
	PzSheetDataSource *		dataSource ;
}

- (void) setTextFieldDelegate: (id <PzSheetViewTextFieldDelegate>) delegate ;

- (void) activateFirstResponder ;

- (void) moveCursorForwardInExpressionField ;
- (void) moveCursorBackwardInExpressionField ;
- (void) selectNextExpressionField ;

- (void) insertStringToExpressionField: (NSString *) str ;
- (void) deleteSelectedStringInExpressionField ;
- (void) setResultValue: (PzSheetValue *) value forSlot: (NSInteger) index ;

@end
