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
	
	// add interactivity
	
	// return the cell
	return newcell;
}

@end
