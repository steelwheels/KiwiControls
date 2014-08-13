/**
 * @file	PzTenKeyDataSource.h
 * @brief	Define PzTenKeyDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@interface PzTenKeyDataSource : NSObject <UICollectionViewDataSource>

- (instancetype) init ;
- (IBAction) clickEvent:(id) sender event:(id) event ;

@end
