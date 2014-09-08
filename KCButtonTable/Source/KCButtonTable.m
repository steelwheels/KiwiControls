/**
 * @file	KCButtonTable.m
 * @brief	Define KCButtonTable class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCButtonTable.h"

@implementation KCButtonTable

- (instancetype) init
{
	if((self = [super init]) != nil){
		buttonTableView	= nil ;
	}
	return self ;
}

- (KCButtonTableView *) buttonTableWithLabelNames: (NSArray *) names withDelegate: (id <KCButtonTableDelegate>) delegate withFrame: (CGRect) frame
{
	if(buttonTableView == nil){
		buttonTableView = [[KCButtonTableView alloc] initWithFrame: frame] ;
	}
	[buttonTableView setDelegate: delegate] ;
	[buttonTableView setLabelNames: names] ;
	[buttonTableView adjustSize] ;
	return buttonTableView ;
}

@end
