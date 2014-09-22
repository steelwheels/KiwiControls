/**
 * @file	PzSheetView.m
 * @brief	Define PzSheetView class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzSheetView.h"
#import <KiwiControl/KiwiControl.h>

#define DO_DEBUG	0

@interface PzSheetView (Private)
- (UITableView *) getTableView: (UIView *) subview ;
@end

@implementation PzSheetView

- (instancetype) initWithCoder:(NSCoder *) decoder
{
	if ((self = [super initWithCoder:decoder]) != nil){
		UIView * subview = KCLoadXib(self, NSStringFromClass(self.class)) ;
		if(subview){
			if(DO_DEBUG){ NSLog(@"allocate sub view") ; }
			tableView = [self getTableView: subview] ;
			dataSource = [[PzSheetDataSource alloc] init] ;
			[tableView setDataSource: dataSource] ;
			if(DO_DEBUG){
				KCPrintView(tableView) ;
			}
		}
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		UIView * subview = KCLoadXib(self, NSStringFromClass(self.class)) ;
		if(subview){
			tableView = [self getTableView: subview] ;
			dataSource = [[PzSheetDataSource alloc] init] ;
			[tableView setDataSource: dataSource] ;
		}
	}
	return self ;
}

- (void) setDelegate: (id <PzSheetViewDelegate>) delegate
{
	[dataSource setDelegate: delegate] ;
}

- (void) activateFirstResponder
{
	[dataSource activateFirstResponder] ;
}

- (void) moveCursorForwardInExpressionField
{
	[dataSource moveCursorForwardInExpressionField] ;
}

- (void) moveCursorBackwardInExpressionField
{
	[dataSource moveCursorBackwardInExpressionField] ;
}

- (void) selectNextExpressionField
{
	[dataSource selectNextExpressionField] ;
}

- (void) insertStringToExpressionField: (NSString *) str
{
	[dataSource insertStringToExpressionField: str] ;
}

- (void) setResultValue: (PzSheetValue *) value forSlot: (NSInteger) index
{
	[dataSource setResultValue: value forSlot: index] ;
}

@end

@implementation PzSheetView (Private)

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
