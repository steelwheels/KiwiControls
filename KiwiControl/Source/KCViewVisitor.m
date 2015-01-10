/**
 * @file	KCViewVisitor.m
 * @brief	Define KCViewVisitor class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCViewVisitor.h"


#if TARGET_OS_IPHONE

@implementation UIView (KCVisitorInterface)
- (void) acceptViewVisitor: (KCViewVisitor *) visitor withParameter: (id) parameter
{
	[visitor visitView: self withParameter: parameter] ;
}
@end

@implementation UITableView (KCVisitorInterface)
- (void) acceptViewVisitor: (KCViewVisitor *) visitor withParameter: (id) parameter
{
	[visitor visitTableView: self withParameter: parameter] ;
}
@end

@implementation UICollectionView (KCVisitorInterface)
- (void) acceptViewVisitor: (KCViewVisitor *) visitor withParameter: (id) parameter
{
	[visitor visitCollectionView: self withParameter: parameter] ;
}
@end

@implementation KCViewVisitor : NSObject

- (void) visitView: (UIView *) view withParameter: (id) parameter
{
	((void) view) ; ((void) parameter) ;
}

- (void) visitTableView: (UITableView *) view withParameter: (id) parameter
{
	((void) view) ; ((void) parameter) ;
}

- (void) visitCollectionView: (UICollectionView *) view withParameter: (id) parameter
{
	((void) view) ; ((void) parameter) ;
}

@end

#else /* TARGET_OS_IPHONE */

@implementation NSView (KCVisitorInterface)
- (void) acceptViewVisitor: (KCViewVisitor *) visitor withParameter: (id) parameter
{
	[visitor visitView: self withParameter: parameter] ;
}
@end

@implementation NSTextView (KCVisitorInterface)
- (void) acceptViewVisitor: (KCViewVisitor *) visitor withParameter: (id) parameter
{
	[visitor visitTextView: self withParameter: parameter] ;
}
@end

@implementation KCViewVisitor : NSObject
- (void) visitView: (NSView *) view withParameter: (id) parameter
{
	((void) view) ; ((void) parameter) ;
}
- (void) visitTextView: (NSTextView *) view withParameter: (id) parameter
{
	((void) view) ; ((void) parameter) ;
}
@end

#endif /* TARGET_OS_IPHONE */
