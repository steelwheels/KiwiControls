/**
 * @file	UTDataSource.m
 * @brief	Define UTDataSource class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "UTDataSource.h"

@implementation UTDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
	(void) tableView ;
	return 2 ;
}

- (NSInteger) tableView: (UITableView *) view numberOfRowsInSection:(NSInteger)section
{
	(void) view ; (void) section ;
	return 3 ;
}

- (NSString *) tableView: (UITableView *) view titleForHeaderInSection:(NSInteger)section
{
	(void) view ;
	return [[NSString alloc] initWithFormat: @"Header %td", section] ;
}

- (NSString *) tableView: (UITableView *) view titleForFooterInSection:(NSInteger)section
{
	(void) view ;
	return [[NSString alloc] initWithFormat: @"Footer %td", section] ;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	NSString *		cellIdentifier = @"Cell";
	UITableViewCell *	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
 
	if (cell == nil) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
 
	cell.textLabel.text = [[NSString alloc] initWithFormat: @"cell%td", indexPath.row] ;
 
	return cell;
}

@end
