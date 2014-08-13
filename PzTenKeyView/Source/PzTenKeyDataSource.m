/**
 * @file	PzTenKeyDataSource.m
 * @brief	Define PzTenKeyDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzTenKeyDataSource.h"

#define DO_DEBUG			0

static const unsigned int		ROW_NUM		= 5 ;
static const unsigned int		COLMUN_NUM	= 5 ;

static UIButton * buttonInCell(UICollectionViewCell * cell) ;

@implementation PzTenKeyDataSource

- (instancetype) init
{
	if((self = [super init]) != nil){
		if(DO_DEBUG){ NSLog(@"init\n") ; }
	}
	return self ;
}

- (NSInteger) numberOfSectionsInCollectionView: (UICollectionView *) collectionView
{
	if(DO_DEBUG){ NSLog(@"numberOfSections") ; }
	return 1 ;
}

- (NSInteger) collectionView: (UICollectionView *) view numberOfItemsInSection: (NSInteger) section
{
	if(DO_DEBUG){ NSLog(@"numberOfItems\n") ; }
	((void) view) ; ((void) section) ;
	return ROW_NUM * COLMUN_NUM ;
}

- (UICollectionViewCell *) collectionView:  (UICollectionView *) view cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if(DO_DEBUG){ NSLog(@"collectionView:cellForItemAtIndexPath\n") ; }
	
	static BOOL is1stcalling = true ;
	if(is1stcalling){
		UINib * nib = [UINib nibWithNibName: @"PzTenKeyCell" bundle:nil];
		[view registerNib: nib forCellWithReuseIdentifier: @"Key"] ;
		is1stcalling = false ;
	}
	
	/* Allocate new cell with button */
	UICollectionViewCell * newcell = [view dequeueReusableCellWithReuseIdentifier: @"Key" forIndexPath: indexPath] ;
	
	/* Setup button in cell */
	UIButton *	button = buttonInCell(newcell) ;
	if(button){
		button.tag = [indexPath row] ;
		[button addTarget: self action: @selector(clickEvent:event:) forControlEvents: UIControlEventTouchUpInside] ;
	} else {
		NSLog(@"Failed to get button") ;
	}
	
	// return the cell
	return newcell;
}

- (IBAction) clickEvent:(id) sender event:(id) event
{
	UIButton * button = (UIButton *) sender ;
	int tag = (int) button.tag ;
	NSLog(@"click event: %d\n", tag) ;
}

@end

static UIButton *
buttonInCell(UICollectionViewCell * cell)
{
	UIButton * result = nil ;
	UIView * subview1 = [cell contentView] ;
	if(subview1){
		NSArray * subviews2 = [subview1 subviews] ;
		if([subviews2 count] == 1){
			UIView * subview2 = [subviews2 objectAtIndex: 0] ;
			if([subview2 isKindOfClass: [UIButton class]]){
				result = (UIButton *) subview2 ;
			}
		}
	}
	return result ;
}
