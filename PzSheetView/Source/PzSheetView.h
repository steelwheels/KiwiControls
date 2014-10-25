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

+ (NSUInteger) maxRowNum ;

- (void) setTextFieldDelegate: (id <PzSheetViewTextFieldDelegate>) delegate ;
- (void) setTouchableLabelDelegate: (id <PzSheetViewTouchLabelDelegate>) delegate ;

- (void) moveCursorForwardInExpressionField ;
- (void) moveCursorBackwardInExpressionField ;
- (void) selectNextExpressionField ;
- (void) clearCurrentField ;
- (void) clearAllFields ;

- (void) insertStringToExpressionField: (NSString *) str ;
- (void) deleteSelectedStringInExpressionField ;
- (void) setLabelText: (NSString *) text forSlot: (NSInteger) index ;

@end
