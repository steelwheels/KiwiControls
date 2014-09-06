/**
 * @file	KCViewVisitor.h
 * @brief	Define KCViewVisitor class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@class KCViewVisitor ;

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
