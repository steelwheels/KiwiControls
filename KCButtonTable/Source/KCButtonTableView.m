/**
 * @file	KCButtonTableView.m
 * @brief	Define KCButtonTableView class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCButtonTableView.h"
#import "KCButtonTableCell.h"
#import <KiwiControl/KiwiControl.h>

@implementation KCButtonTableView

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil) {
		buttonTableView = [[UITableView alloc] initWithFrame: self.bounds style: UITableViewStylePlain] ;
		dataSource = [[KCButtonTableSource alloc] init] ;
		buttonTableView.dataSource = dataSource ;
		[self addSubview: buttonTableView] ;
	}
	return self ;
}

- (void) setLabelNames: (NSArray *) names
{
	[dataSource setLabelNames: names] ;
	[buttonTableView reloadData] ;
	//[buttonTableView setNeedsDisplay] ;
}

@end

