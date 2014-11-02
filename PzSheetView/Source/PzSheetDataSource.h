/**
 * @file	PzSheetDataSource.h
 * @brief	Define PzSheetDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzSheetDatabase.h"
#import <UIKit/UIKit.h>
#import <KCTouchableLabel/KCTouchableLabel.h>

@protocol PzSheetViewTextFieldDelegate
- (void) enterText: (NSString *) text atIndex: (NSUInteger) index ;
- (void) clearTextAtIndex: (NSUInteger) index ;
@end

@protocol PzSheetViewTouchLabelDelegate <NSObject>
- (void) touchLabelAtIndex: (NSUInteger) index atAbsolutePoint: (CGPoint) point ;
@end

@interface PzSheetDataSource : NSObject <UITableViewDataSource, UITextFieldDelegate, KCTouchableLabelDelegate>
{
	BOOL					didNibPrepared ;
	
	id <PzSheetViewTextFieldDelegate>	sheetViewTextFieldDelegate ;
	id <PzSheetViewTouchLabelDelegate>	sheetViewTouchableLabelDelegate ;
	
	PzSheetDatabase *			sheetDatabase ;
	
	NSUInteger				currentSlot ;
}

+ (NSUInteger) maxRowNum ;

- (instancetype) init ;

- (void) setTextFieldDelegate: (id <PzSheetViewTextFieldDelegate>) delegate ;
- (void) setTouchableLabelDelegate: (id <PzSheetViewTouchLabelDelegate>) delegate ;

- (void) moveCursorForwardInExpressionFieldInTableView: (UITableView *) tableview ;
- (void) moveCursorBackwardInExpressionFieldInTableView: (UITableView *) tableview ;
- (void) clearCurrentFieldInTableView: (UITableView *) tableview ;
- (void) clearAllFieldsInTableView: (UITableView *) tableview ;
- (void) selectNextExpressionFieldInTableView: (UITableView *) tableview ;

- (void) insertStringToExpressionField: (NSString *) str inTableView: (UITableView *) tableview ;
- (void) deleteSelectedStringInExpressionFieldInTableView: (UITableView *) tableview ;

- (void) setLabelText: (NSString *) text forSlot: (NSInteger) index inTableView: (UITableView *) tableview ;

@end

