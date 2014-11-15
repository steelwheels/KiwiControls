/**
 * @file	PzSheetDataSource.h
 * @brief	Define PzSheetDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzSheetForwarders.h"
#import <UIKit/UIKit.h>
#import <KCTouchableLabel/KCTouchableLabel.h>

@interface PzSheetDataSource : NSObject <UITableViewDataSource>
{
	BOOL					didNibPrepared ;
	PzSheetState *				sheetState ;
	PzSheetDatabase *			sheetDatabase ;
}

@property (weak, nonatomic)	PzSheetDelegate *	sheetDelegate ;

+ (NSUInteger) maxRowNum ;

- (instancetype) initWithSheetState: (PzSheetState *) state withDatabase: (PzSheetDatabase *) database ;

- (PzSheetCell *) searchSheetCellInTableView: (UITableView *) tableview atIndex: (NSUInteger) index ;

- (void) moveCursorForwardInExpressionFieldInTableView: (UITableView *) tableview ;
- (void) moveCursorBackwardInExpressionFieldInTableView: (UITableView *) tableview ;
- (void) clearCurrentFieldInTableView: (UITableView *) tableview ;
- (void) clearAllFieldsInTableView: (UITableView *) tableview ;
- (void) selectNextExpressionFieldInTableView: (UITableView *) tableview ;

- (void) insertStringToExpressionField: (NSString *) str inTableView: (UITableView *) tableview ;
- (void) deleteSelectedStringInExpressionFieldInTableView: (UITableView *) tableview ;

- (void) setLabelText: (NSString *) text forSlot: (NSInteger) index inTableView: (UITableView *) tableview ;

@end

