/**
 * @file	KCPreferenceTable.m
 * @brief	Define KCPreferenceTable class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCPreferenceTable.h"
#import "KCPreferenceTableSource.h"
#import <KiwiControl/KiwiControl.h>

@interface KCPreferenceTable (Private)
- (UITableView *) getTableView: (UIView *) subview ;
@end

@implementation KCPreferenceTable

- (instancetype) initWithCoder:(NSCoder *) decoder
{
	if ((self = [super initWithCoder:decoder]) != nil){
		UIView * subview = KCLoadXib(self, NSStringFromClass(self.class)) ;
		if(subview){
			preferenceTableView = [self getTableView: subview] ;
			preferenceTableSource = [[KCPreferenceTableSource alloc] init] ;
			
			preferenceTableView.dataSource = preferenceTableSource ;
			preferenceTableView.delegate = preferenceTableSource ;
		}
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil) {
		UIView * subview = KCLoadXib(self, NSStringFromClass(self.class)) ;
		if(subview){
			preferenceTableView = [self getTableView: subview] ;
			preferenceTableSource = [[KCPreferenceTableSource alloc] init] ;
			
			preferenceTableView.dataSource = preferenceTableSource ;
			preferenceTableView.delegate = preferenceTableSource ;
		}
	}
	return self ;
}

@end

@implementation KCPreferenceTable (Private)

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
		NSLog(@"%s: Failed to get collection view", __FILE__) ;
	}
	return nil ;
}

@end
