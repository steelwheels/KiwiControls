/**
 * @file	PzSheetDatabase.m
 * @brief	Define PzSheetDatabase class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <Foundation/Foundation.h>



@class PzSheetData ;

@interface PzSheetDatabase : NSObject
{
	NSMutableArray *	sheetDataArray ;
}

- (instancetype) initWithCountOfSheetData: (NSUInteger) count ;

- (NSString *) expressionStringAtIndex: (NSUInteger) index ;
- (void) setExpressionString: (NSString *) str atIndex: (NSUInteger) index ;

- (NSString *) labelStringAtIndex: (NSUInteger) index ;
- (void) setLabelString: (NSString *) str atIndex: (NSUInteger) index ;

- (void) clearStringsAtIndex: (NSUInteger) index ;

@end
