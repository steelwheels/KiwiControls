/**
 * @file	KCPreferenceTableDelegate.m
 * @brief	Define KCPreferenceTableDelegate class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCPreferenceTableDelegate.h"

@implementation KCPreferenceTableDelegate

- (instancetype) init
{
	if((self = [super initWithId: 0]) != nil){
	}
	return self ;
}

- (CGFloat)tableView: (UITableView *) tableView heightForHeaderInSection: (NSInteger)section
{
	((void) tableView) ; ((void) section) ;
	return 28.0 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	((void) tableView) ; ((void) section) ;
	return 0.1 ;
}

@end
