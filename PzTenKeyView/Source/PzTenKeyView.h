/**
 * @file	PzTenKeyView.h
 * @brief	Define PzTenKeyView class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "PzTenKeyDataSource.h"
#import "PzTenKeyType.h"

@interface PzTenKeyView : UIView <PzTenKeyClicking>
{
	__weak UICollectionView *	tenKeyCollectionView ;
	PzTenKeyDataSource *		tenKeyDataSource ;
}

@property (strong, nonatomic) id <PzTenKeyClicking> delegate ;

@end
