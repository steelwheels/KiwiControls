/**
 * @file	PzTenKeyView.m
 * @brief	Define PzTenKeyView class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzTenKeyView.h"

#define LOCAL_DEBUG 0

static void printView(unsigned int depth, unsigned int index, UIView * view) ;

@interface PzTenKeyView (Private)
- (UIView *) loadContentView ;
- (NSLayoutConstraint *)pin:(id)item attribute:(NSLayoutAttribute)attribute ;
- (UICollectionView *) getCollectionView: (UIView *) subview ;
- (void) setupCollectionView: (UICollectionView *) view ;
@end

@implementation PzTenKeyView

- (instancetype) initWithCoder:(NSCoder *) decoder
{
	if ((self = [super initWithCoder:decoder]) != nil){
		tenKeyDataSource = [[PzTenKeyDataSource alloc] init] ;
		UIView * subview = [self loadContentView] ;
		if(subview){
			collectionView = [self getCollectionView: subview] ;
			[self setupCollectionView: collectionView] ;
		}
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		tenKeyDataSource = [[PzTenKeyDataSource alloc] init] ;
		UIView * subview = [self loadContentView] ;
		if(subview){
			collectionView = [self getCollectionView: subview] ;
			[self setupCollectionView: collectionView] ;
		}
	}
	return self ;
}

@end

@implementation PzTenKeyView (Private)

- (UIView *) loadContentView
{
	if([[self subviews] count] == 0){
		NSString * nibname = NSStringFromClass(self.class) ;
		UINib *nib = [UINib nibWithNibName: nibname bundle:nil];
		UIView * loadedSubview = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
	
		[self addSubview:loadedSubview];
	
		loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
	
		[self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeTop]];
		[self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeLeft]];
		[self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeBottom]];
		[self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeRight]];
		
		if(LOCAL_DEBUG){
			printView(0, 0, loadedSubview) ;
		}
		return loadedSubview ;
	} else {
		return nil ;
	}
}

- (NSLayoutConstraint *)pin:(id)item attribute:(NSLayoutAttribute)attribute
{
	return [NSLayoutConstraint constraintWithItem:self
					    attribute:attribute
					    relatedBy:NSLayoutRelationEqual
					       toItem:item
					    attribute:attribute
					   multiplier:1.0
					     constant:0.0];
}

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

static void
printView(unsigned int depth, unsigned int index, UIView * view)
{
	NSString * name = NSStringFromClass([view class]) ;
	unsigned int i ;
	for(i=0 ; i<depth ; i++){
		putc(' ', stdout) ;
	}
	printf("%u: %s\n", index, [name UTF8String]) ;
	
	i = 0 ;
	NSArray * subviews = [view subviews] ;
	UIView * subview ;
	for(subview in subviews){
		printView(depth+1, i++, subview) ;
	}
}

