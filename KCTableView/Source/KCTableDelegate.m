/**
 * @file	KCTableDelegate.m
 * @brief	Define KCTableDelegate class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCTableDelegate.h"
#import <KiwiControl/KiwiControl.h>

@implementation KCTableDelegate

- (instancetype) init
{
	if((self = [super init]) != nil){
		KCPreference * pref = [KCPreference sharedPreference] ;
		headerColor = [pref color: @"HeaderColor"] ;
	}
	return self ;
}

- (void) tableView: (UITableView *) tableview willDisplayHeaderView: (UIView *) headerview forSection: (NSInteger) section
{
	(void) tableview ; (void) section ;
	if(headerColor){
		[headerview setTintColor: headerColor] ;
	}
}

- (void) tableView: (UITableView *) tableview willDisplayFooterView: (UIView *) footerview forSection: (NSInteger) section
{
	(void) tableview ; (void) section ;
	if(headerColor){
		[footerview setTintColor: headerColor] ;
	}
}

@end
