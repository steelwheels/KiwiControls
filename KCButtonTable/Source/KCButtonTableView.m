/**
 * @file	KCButtonTableView.m
 * @brief	Define KCButtonTableView class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCButtonTableView.h"
#import "KCButtonTableCell.h"
#import <KiwiControl/KiwiControl.h>

@interface KCButtonTableView (Private)
- (UITableView *) getTableView: (UIView *) subview ;
@end

@implementation KCButtonTableView

- (instancetype) initWithCoder:(NSCoder *) decoder
{
	if ((self = [super initWithCoder:decoder]) != nil){
		UIView * subview = KCLoadXib(self, NSStringFromClass(self.class)) ;
		if(subview){
			tableView = [self getTableView: subview] ;
			dataSource = [[KCButtonTableSource alloc] init] ;
			[tableView setDataSource: dataSource] ;
			tableView.dataSource = dataSource ;
			tableView.delegate = dataSource ;
		}
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil) {
		UIView * subview = KCLoadXib(self, NSStringFromClass(self.class)) ;
		if(subview){
			tableView = [self getTableView: subview] ;
			dataSource = [[KCButtonTableSource alloc] init] ;
			[tableView setDataSource: dataSource] ;
			tableView.dataSource = dataSource ;
			tableView.delegate = dataSource ;
		}
	}
	return self ;
}

- (void) setDelegate: (id <KCButtonTableDelegate>) delegate
{
	dataSource.buttonTableDelegate = delegate ;
}

- (void) setLabelNames: (NSArray *) names
{
	dataSource.labelNames = names ;
	[tableView reloadData] ;
}

- (void) setBorder
{
	self.layer.borderWidth  = 2.0f;
	self.layer.borderColor  = [[UIColor grayColor] CGColor];
	self.layer.cornerRadius = 0.1f;
}

- (void) adjustSize
{
	CGFloat	maxwidth  = 0.0 ;
	CGFloat maxheight = 0.0 ;
	for(KCButtonTableCell * cell in [tableView visibleCells]){
		CGRect cellbounds = cell.tableButton.bounds ;
		maxwidth  =  MAX(maxwidth, cellbounds.size.width) ;
		maxheight += cellbounds.size.height ;
	}
	CGSize maxsize = CGSizeMake(maxwidth+14.0, maxheight+14.0) ;
	KCUpdateViewSize(self, maxsize) ;
}

@end

@implementation KCButtonTableView (Private)

- (UITableView *) getTableView: (UIView *) subview ;
{
	if(subview){
		NSArray * arr1 = [subview subviews] ;
		if([arr1 count] == 1){
			UIView * subview1 = [arr1 objectAtIndex: 0] ;
			if([subview1 isKindOfClass: [UITableView class]]){
				return (UITableView *) subview1 ;
			}
		}
		NSLog(@"%s: Failed to get collection view", __FILE__) ;
	}
	return nil ;
}

@end


