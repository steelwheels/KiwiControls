/**
 * @file	PzSheetDataSource.h
 * @brief	Define PzSheetDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "PzSheetValue.h"

@protocol PzSheetViewDelegate
- (void) enterText: (NSString *) text atIndex: (NSUInteger) index ;
@end

@interface PzSheetDataSource : NSObject <UITableViewDataSource, UITextFieldDelegate>
{
	id <PzSheetViewDelegate>	sheetViewDelegate ;
	/** Array of UITextField objects */
	NSMutableArray *		expressionTable ;
	NSMutableDictionary *		resultTable ;
	
	NSUInteger			currentSlot ;
}

- (instancetype) init ;

- (void) setDelegate: (id <PzSheetViewDelegate>) delegate ;

- (void) activateFirstResponder ;

- (void) moveCursorForwardInExpressionField ;
- (void) moveCursorBackwardInExpressionField ;
- (void) selectNextExpressionField ;

- (void) insertStringToExpressionField: (NSString *) str ;
- (void) deleteSelectedStringInExpressionField ;
- (void) clearExpressionField ;

- (void) setResultValue: (PzSheetValue *) value forSlot: (NSInteger) index ;

@end

