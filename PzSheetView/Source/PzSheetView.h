/**
 * @file	PzSheetView.h
 * @brief	Define PzSheetView class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "PzSheetDelegate.h"
#import "PzSheetForwarders.h"

@interface PzSheetView : UIView
{
	UITableView *			tableView ;
	PzSheetState *			sheetState ;
	PzSheetDatabase *		sheetDatabase ;
	PzSheetDataSource *		dataSource ;
	PzSheetDelegate *		sheetDelegate ;
}

+ (NSUInteger) maxRowNum ;

- (void) setTextFieldDelegate: (id <PzSheetTextFieldDelegate>) delegate ;
- (void) setTouchableLabelDelegate: (id <PzSheetTouchLabelDelegate>) delegate ;

- (void) moveCursorForwardInExpressionField ;
- (void) moveCursorBackwardInExpressionField ;
- (void) selectNextExpressionField ;
- (void) clearCurrentField ;
- (void) clearAllFields ;

- (void) insertStringToExpressionField: (NSString *) str ;
- (void) deleteSelectedStringInExpressionField ;
- (void) setLabelText: (NSString *) text forSlot: (NSInteger) index ;

@end
