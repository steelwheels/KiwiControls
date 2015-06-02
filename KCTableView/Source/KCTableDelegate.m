/**
 * @file	KCTableDelegate.m
 * @brief	Define KCTableDelegate class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCTableDelegate.h"
#import <KiwiControl/KiwiControl.h>

@implementation KCTableDelegate

- (instancetype) initWithId: (int) dummy
{
	(void) dummy ;
	if((self = [super init]) != nil){
		KCPreference * pref = [KCPreference sharedPreference] ;
		headerColor		= [pref color: @"HeaderColor"] ;
		cellBackgroundColor	= [pref color: @"BackgroundColor"] ;
		cellLabelColor		= [pref color: @"FontColor"] ;
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

- (void) tableView: (UITableView *) tableview willDisplayCell: (UITableViewCell *) cell forRowAtIndexPath: (NSIndexPath *) indexpath
{
	(void) tableview ; (void) indexpath ;
	if(cell && cellBackgroundColor){
		cell.backgroundColor = [UIColor clearColor] ;
		cell.textLabel.backgroundColor = cellBackgroundColor ;
	}
	if(cell && cellLabelColor){
		cell.textLabel.textColor = cellLabelColor ;
	}
}

@end
