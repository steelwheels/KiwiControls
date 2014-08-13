/**
 * @file	KCColorTable.m
 * @brief	Define KCColorTable class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCColorTable.h"

static inline UIColor *
allocateColor(CGFloat red, CGFloat green, CGFloat blue)
{
	return [[UIColor alloc] initWithRed: red green: green blue: blue alpha: 1.0] ;
}

@implementation KCColorTable

@synthesize whiteSmokeColor ;

- init
{
	if((self = [super init]) != nil){
		self.whiteSmokeColor	= allocateColor(0.97, 0.97, 1.00) ;
	}
	return self ;
}

@end
