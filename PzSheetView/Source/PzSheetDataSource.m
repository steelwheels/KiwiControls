/**
 * @file	PzSheetDataSource.m
 * @brief	Define PzSheetDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzSheetDataSource.h"

#define MAX_ROW_NUM	16
#define DO_DEBUG	0

@implementation PzSheetDataSource

- (instancetype) init
{
	if((self = [super init]) != nil){
		
	}
	return self ;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
	((void) tableView) ;
	return 1 ;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
	((void) section) ;
	return MAX_ROW_NUM ;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(DO_DEBUG){ NSLog(@"collectionView:cellForItemAtIndexPath\n") ; }
	
	static BOOL is1stcalling = true ;
	if(is1stcalling){
		UINib * nib = [UINib nibWithNibName: @"PzSheetCell" bundle:nil];
		if(nib){
			[tableView registerNib: nib forCellReuseIdentifier: @"Key"];
		} else {
			NSLog(@"Failed to load nib\n") ;
		}
		is1stcalling = false ;
	}
	
	/* Allocate new cell with button */
	UITableViewCell * newcell = [tableView dequeueReusableCellWithIdentifier: @"Key"];
	if(newcell == nil){
		NSLog(@"NO CELL!!\n") ;
	}
#if 0
	/* Setup button in cell */
	UIButton *	button ;
	UIView *	background ;
	if(buttonInCell(&button, &background, newcell)){
		button.tag = [indexPath row] ;
		[button addTarget: self action: @selector(clickEvent:event:) forControlEvents: UIControlEventTouchUpInside] ;
		updateButtonLabel(tenKeyState, button, background) ;
	} else {
		NSLog(@"Failed to get button") ;
	}
#endif
	
	// return the cell
	return newcell;
}

@end
