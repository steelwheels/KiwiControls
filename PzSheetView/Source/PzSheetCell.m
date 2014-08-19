/**
 * @file	PzSheetCell.m
 * @brief	Define PzSheetCell class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzSheetCell.h"
#import "PzSheetValue.h"

@implementation PzSheetCell

@synthesize resultLabel ;
@synthesize expressionField ;

- (void) observeValueForKeyPath:(NSString *) keyPath ofObject:(id) object change: (NSDictionary *)change context: (void *) context
{
	PzSheetValue * value = [change objectForKey:NSKeyValueChangeNewKey] ;
	resultLabel.text = [value toString] ;
}

@end
