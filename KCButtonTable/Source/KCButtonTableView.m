/**
 * @file	KCButtonTableView.m
 * @brief	Define KCButtonTableView class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCButtonTableView.h"
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
			buttonTableView = [self getTableView: subview] ;
			dataSource = [[KCButtonTableSource alloc] init] ;
			buttonTableView.dataSource = dataSource ;
			[KCButtonTableSource registerNib: buttonTableView] ;
			
			subview.frame = self.bounds ;
		}
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil) {
		UIView * subview = KCLoadXib(self, NSStringFromClass(self.class)) ;
		if(subview){
			buttonTableView = [self getTableView: subview] ;
			dataSource = [[KCButtonTableSource alloc] init] ;
			buttonTableView.dataSource = dataSource ;
			[KCButtonTableSource registerNib: buttonTableView] ;
			
			subview.frame = self.bounds ;
		}
	}
	return self ;
}

- (void) setLabelNames: (NSArray *) names
{
	[dataSource setLabelNames: names] ;
	[buttonTableView reloadData] ;
}

@end

@implementation KCButtonTableView (Private)

- (UITableView *) getTableView: (UIView *) subview
{
	if(subview){
		NSArray * arr1 = [subview subviews] ;
		if([arr1 count] == 1){
			UIView * subview1 = [arr1 objectAtIndex: 0] ;
			if([subview1 isKindOfClass: [UITableView class]]){
				return (UITableView *) subview1 ;
			}
		}
		NSLog(@"%s: Failed to get table view", __FILE__) ;
	}
	return nil ;
}

@end
