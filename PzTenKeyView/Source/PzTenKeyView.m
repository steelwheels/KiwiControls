/**
 * @file	PzTenKeyView.m
 * @brief	Define PzTenKeyView class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzTenKeyView.h"
#import <KiwiControl/KiwiControl.h>

#define LOCAL_DEBUG 0

@interface PzTenKeyView (Private)
- (UICollectionView *) getCollectionView: (UIView *) subview ;
- (void) setupCollectionView: (UICollectionView *) view ;
@end

@implementation PzTenKeyView

@synthesize delegate ;

- (instancetype) initWithCoder:(NSCoder *) decoder
{
	if ((self = [super initWithCoder:decoder]) != nil){
		delegate = nil ;
		tenKeyDataSource = [[PzTenKeyDataSource alloc] initWithDelegate: self] ;
		UIView * subview = KCLoadXib(self, NSStringFromClass(self.class)) ;
		if(subview){
			tenKeyCollectionView = [self getCollectionView: subview] ;
			[self setupCollectionView: tenKeyCollectionView] ;
		}
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		delegate = nil ;
		tenKeyDataSource = [[PzTenKeyDataSource alloc] initWithDelegate: self] ;
		UIView * subview = KCLoadXib(self, NSStringFromClass(self.class)) ;
		if(subview){
			tenKeyCollectionView = [self getCollectionView: subview] ;
			[self setupCollectionView: tenKeyCollectionView] ;
		}
	}
	return self ;
}

- (void) pressKey: (enum PzTenKeyCode) code
{
	switch(code){
		case PzTenKeyCode_DecState: {
			NSArray * cells = [tenKeyCollectionView visibleCells] ;
			[tenKeyDataSource updateCells: cells withState: PzTenKeyDecState] ;
		} break ;
		case PzTenKeyCode_HexState: {
			NSArray * cells = [tenKeyCollectionView visibleCells] ;
			[tenKeyDataSource updateCells: cells withState: PzTenKeyHexState] ;
		} break ;
		case PzTenKeyCode_OpState: {
			NSArray * cells = [tenKeyCollectionView visibleCells] ;
			[tenKeyDataSource updateCells: cells withState: PzTenKeyOpState] ;
		} break ;
		default: {
			if(delegate){
				[delegate pressKey: code] ;
			} else {
				NSLog(@"PressKey: 0x%x\n", (unsigned int) code) ;
			}
		} break ;
	}
}

@end

@implementation PzTenKeyView (Private)

- (UICollectionView *) getCollectionView: (UIView *) subview
{
	if(subview){
		NSArray * arr1 = [subview subviews] ;
		if([arr1 count] == 1){
			UIView * subview1 = [arr1 objectAtIndex: 0] ;
			if([subview1 isKindOfClass: [UICollectionView class]]){
				return (UICollectionView *) subview1 ;
			}
		}
		NSLog(@"%s: Failed to get collection view", __FILE__) ;
	}
	return nil ;
}

- (void) setupCollectionView: (UICollectionView *) view
{
	[view setDataSource: tenKeyDataSource] ;
}

@end


