/**
 * @file	PzTenKeyView.h
 * @brief	Define PzTenKeyView class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "PzTenKeyDataSource.h"

@interface PzTenKeyView : UIView
{
	__weak UICollectionView *	collectionView ;
	PzTenKeyDataSource *		tenKeyDataSource ;
}

@end
