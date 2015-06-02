/**
 * @file	KCPreferenceTable.m
 * @brief	Define KCPreferenceTable class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCPreferenceTable.h"
#import "KCPreferenceTableSource.h"
#import "KCPreferenceTableDelegate.h"
#import <KiwiControl/KiwiControl.h>

@interface KCPreferenceTable ()
- (void) setupPreferenceTable ; ;
@end

@implementation KCPreferenceTable

- (instancetype) initWithCoder:(NSCoder *) decoder
{
	if ((self = [super initWithCoder:decoder]) != nil){
		[self setupPreferenceTable] ;
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil) {
		[self setupPreferenceTable] ;
	}
	return self ;
}

- (void) setupPreferenceTable
{
	tableSource = [[KCPreferenceTableSource alloc] initWithNibName: @"KCPreferenceTableCell"] ;
	self.dataSource = tableSource ;
	
	tableDelegate = [[KCPreferenceTableDelegate alloc] init] ;
	self.delegate = tableDelegate ;
}

@end
