/**
 * @file	KCButtonTable.m
 * @brief	Define KCButtonTable class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCButtonTable.h"

@implementation KCButtonTable

- (instancetype) init
{
	if((self = [super init]) != nil){
		backgroundView = [[KCButtonTableBackground alloc] initWithDelegate: self] ;
		buttonTableView = [[KCButtonTableView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)] ;
		[backgroundView addSubview: buttonTableView] ;
	}
	return self ;
}

- (void) buttonPressed: (NSUInteger) index
{
	[buttonTableDelegate buttonPressed: index] ;
	[backgroundView removeFromSuperview] ;
}

- (void) touchBackground
{
	[backgroundView removeFromSuperview] ;
}

- (void) displayButtonTableWithLabelNames: (NSArray *) names
			     withDelegate: (id <KCButtonTableDelegate>) delegate
			       withOrigin: (CGPoint) origin
			 atViewController: (UIViewController *) controller
{
	buttonTableDelegate = delegate ;
	
	/* Adjust size */
	[buttonTableView setDelegate: self] ;
	[buttonTableView setLabelNames: names] ;
	[buttonTableView setBorder] ;
	[buttonTableView adjustSize] ;
	
	/* Adjust origin */
	CGSize entiresize = controller.view.frame.size ;
	CGSize tablesize  = buttonTableView.frame.size ;
	CGFloat adjx, adjy ;
	if(origin.x + tablesize.width > entiresize.width){
		adjx = origin.x - (origin.x + tablesize.width - entiresize.width) ;
	} else {
		adjx = origin.x ;
	}
	if(origin.y + tablesize.height > entiresize.height){
		adjy = origin.y - (origin.y + tablesize.height - entiresize.height) ;
	} else {
		adjy = origin.y ;
	}
	CGPoint adjorigin = {.x=adjx, .y=adjy} ;
	
	/* Adjust origin */
	KCUpdateViewOrigin(buttonTableView, adjorigin) ;
	
	/* Add background into main window */
	[controller.view addSubview: backgroundView] ;
}

- (CGSize) frameSize
{
	return buttonTableView.frame.size ;
}

@end



