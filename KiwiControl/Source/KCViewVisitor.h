/**
 * @file	KCViewVisitor.h
 * @brief	Define KCViewVisitor class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCType.h"

@class KCViewVisitor ;

#if TARGET_OS_IPHONE
@interface UIView (KCVisitorInterface)
- (void) acceptViewVisitor: (KCViewVisitor *) visitor withParameter: (id) parameter ;
@end

@interface UITableView (KCVisitorInterface)
- (void) acceptViewVisitor: (KCViewVisitor *) visitor withParameter: (id) parameter ;
@end

@interface UICollectionView (KCVisitorInterface)
- (void) acceptViewVisitor: (KCViewVisitor *) visitor withParameter: (id) parameter ;
@end

@interface KCViewVisitor : NSObject
- (void) visitView: (UIView *) view withParameter: (id) parameter ;
- (void) visitTableView: (UITableView *) view withParameter: (id) parameter ;
- (void) visitCollectionView: (UICollectionView *) view withParameter: (id) parameter ;
@end

#else /* TARGET_OS_IPHONE */

@interface NSView (KCVisitorInterface)
- (void) acceptViewVisitor: (KCViewVisitor *) visitor withParameter: (id) parameter ;
@end

@interface NSTextView (KCVisitorInterface)
- (void) acceptViewVisitor: (KCViewVisitor *) visitor withParameter: (id) parameter ;
@end

@interface KCViewVisitor : NSObject
- (void) visitView: (NSView *) view withParameter: (id) parameter ;
- (void) visitTextView: (NSTextView *) view withParameter: (id) parameter ;
@end

#endif /* TARGET_OS_IPHONE */