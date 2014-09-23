/**
 * @file	PzSheetCell.m
 * @brief	Define PzSheetCell class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzSheetCell.h"
#import "PzSheetValue.h"

@implementation PzSheetCell

@synthesize touchableLabel ;
@synthesize expressionField ;

- (void) observeValueForKeyPath:(NSString *) keyPath ofObject:(id) object change: (NSDictionary *)change context: (void *) context
{
	//NSLog(@"oVFKP") ;
	PzSheetValue * value = [change objectForKey:NSKeyValueChangeNewKey] ;
	touchableLabel.text = [value toString] ;
}

@end
