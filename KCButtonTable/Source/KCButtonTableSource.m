/**
 * @file	KCButtonTableSource.m
 * @brief	Define KCButtonTableSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCButtonTableSource.h"
#import "KCButtonTableCell.h"

@implementation KCButtonTableSource

+ (void) registerNib: (UITableView *) view
{
	UINib *nib = [UINib nibWithNibName: @"KCButtonTableCell" bundle:nil];
	[view registerNib:nib forCellReuseIdentifier: @"Cell"];
}

- (instancetype) init
{
	if((self = [super init]) != nil){
		labelNames = @[@"item0"] ;
	}
	return self ;
}

- (void) setLabelNames: (NSArray *) names
{
	labelNames = names ;
}

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
	NSLog(@"sumberOfSectionsInTableView: 1") ;
	return 1 ;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"tableView:numberOfRowsInSection : %u", (unsigned int) [labelNames count]) ;
	return [labelNames count] ;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	KCButtonTableCell * newcell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
	
	NSInteger	index = [indexPath row] ;
	newcell.button.titleLabel.text = [labelNames objectAtIndex: index] ;
	
	return newcell ;
}


@end
