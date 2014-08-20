/**
 * @file	PzSheetDataSource.h
 * @brief	Define PzSheetDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "PzSheetValue.h"

@interface PzSheetDataSource : NSObject <UITableViewDataSource>
{
	/** Array of UITextField objects */
	NSMutableArray *	expressionTable ;
	NSMutableDictionary *	resultTable ;
	
	NSUInteger		currentSlot ;
}

- (instancetype) init ;

- (void) selectNextExpressionField ;
- (void) insertStringToExpressionField: (NSString *) str ;
- (void) setResultValue: (PzSheetValue *) value forSlot: (NSInteger) index ;

@end

