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
- (void) setupTableView: (UITableView *) view withDataSource: (PzSheetDataSource *) datasource ;
@end

@implementation PzSheetView

+ (NSUInteger) maxRowNum
{
	return [PzSheetDataSource maxRowNum] ;
}

- (instancetype) initWithCoder:(NSCoder *) decoder
{
	if ((self = [super initWithCoder:decoder]) != nil){
		UIView * subview = KCLoadXib(self, NSStringFromClass(self.class)) ;
		if(subview){
			if(DO_DEBUG){ NSLog(@"allocate sub view") ; }
			tableView = [self getTableView: subview] ;
			dataSource = [[PzSheetDataSource alloc] init] ;
			[self setupTableView: tableView withDataSource: dataSource] ;
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
			[self setupTableView: tableView withDataSource: dataSource] ;
		}
	}
	return self ;
}

- (void) setTextFieldDelegate: (id <PzSheetViewTextFieldDelegate>) delegate
{
	[dataSource setTextFieldDelegate: delegate] ;
}

- (void) setTouchableLabelDelegate: (id <PzSheetViewTouchLabelDelegate>) delegate
{
	[dataSource setTouchableLabelDelegate: delegate] ;
}

- (void) moveCursorForwardInExpressionField
{
	[dataSource moveCursorForwardInExpressionFieldInTableView: tableView] ;
}

- (void) moveCursorBackwardInExpressionField
{
	[dataSource moveCursorBackwardInExpressionFieldInTableView: tableView] ;
}

- (void) clearCurrentField
{
	[dataSource clearCurrentFieldInTableView: tableView] ;
}

- (void) clearAllFields
{
	[dataSource clearAllFieldsInTableView: tableView] ;
}

- (void) selectNextExpressionField
{
	[dataSource selectNextExpressionFieldInTableView: tableView] ;
}

- (void) insertStringToExpressionField: (NSString *) str
{
	[dataSource insertStringToExpressionField: str inTableView: tableView] ;
}

- (void) deleteSelectedStringInExpressionField
{
	[dataSource deleteSelectedStringInExpressionFieldInTableView: tableView] ;
}

- (void) setLabelText:(NSString *) text forSlot:(NSInteger)index
{
	[dataSource setLabelText: text forSlot: index inTableView: tableView] ;
}

@end

@implementation PzSheetView (Private)

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

- (void) setupTableView: (UITableView *) tableview withDataSource: (PzSheetDataSource *) source
{
	[tableview setDataSource: source] ;
	tableView.allowsSelection = false ;
}

@end
