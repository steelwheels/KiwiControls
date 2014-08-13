/**
 * @file	PzTenKeyDataSource.h
 * @brief	Define PzTenKeyDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "PzTenKeyCode.h"

#define PzTenKeyRowNum			5
#define PzTenKeyColmunNum		5

@interface PzTenKeyDataSource : NSObject <UICollectionViewDataSource>
{
	enum PzTenKeyState	tenKeyState ;
}

- (instancetype) init ;
- (IBAction) clickEvent:(id) sender event:(id) event ;

@end
