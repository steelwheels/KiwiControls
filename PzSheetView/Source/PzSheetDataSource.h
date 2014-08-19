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
	NSMutableDictionary *	resultTable ;
}

- (instancetype) init ;

- (void) setResultValue: (PzSheetValue *) value forIndex: (NSInteger) index ;

@end

