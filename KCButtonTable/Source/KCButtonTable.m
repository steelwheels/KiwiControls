/**
 * @file	KCButtonTable.m
 * @brief	Define KCButtonTable class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCButtonTable.h"

static void
updateFrameSize(UIView * view, CGSize newsize)
{
	CGRect orgframe = view.bounds ;
	CGRect newframe = CGRectMake(orgframe.origin.x, orgframe.origin.y, newsize.width, newsize.height) ;
	view.frame = newframe ;
}

static void
updateBoundsSize(UIView * view, CGSize newsize)
{
	CGRect orgbounds = view.bounds ;
	CGRect newbounds = CGRectMake(orgbounds.origin.x, orgbounds.origin.y, newsize.width, newsize.height) ;
	view.bounds = newbounds ;
}

@implementation KCButtonTable

- (instancetype) init
{
	if((self = [super init]) != nil){
		buttonTableView	= nil ;
	}
	return self ;
}

- (KCButtonTableView *) buttonTableWithLabelNames: (NSArray *) names withDelegate: (id <KCButtonTableDelegate>) delegate withFrame: (CGRect) frame
{
	if(buttonTableView == nil){
		buttonTableView = [[KCButtonTableView alloc] initWithFrame: frame] ;
	}
	[buttonTableView setDelegate: delegate] ;
	[buttonTableView setLabelNames: names] ;
	
#if 0
	printf("buttonTableWithLabelNames") ;
	CGRect newbounds = [buttonTableView calcBoundRect] ;
	printf("\n") ;
	
	updateFrameSize(buttonTableView, newbounds.size) ;
	updateBoundsSize(buttonTableView, newbounds.size) ;
	
	[buttonTableView layoutSubviews] ;
#endif
	return buttonTableView ;
}

@end
