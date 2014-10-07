/**
 * @file	PzTenKeyDataSource.h
 * @brief	Define PzTenKeyDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "PzTenKeyType.h"

#define PzTenKeyRowNum			5
#define PzTenKeyColmunNum		5

@protocol PzTenKeyClicking
- (void) pressKey: (enum PzTenKeyCode) code ;
@end

@interface PzTenKeyDataSource : NSObject <UICollectionViewDataSource>
{
	BOOL			didNibPrepared ;
	id <PzTenKeyClicking>	clickDelegate ;
	enum PzTenKeyState	tenKeyState ;
}

- (instancetype) initWithDelegate: (id <PzTenKeyClicking>) delegate ;
- (IBAction) clickEvent:(id) sender event:(id) event ;
- (void) updateCells: (NSArray *) cells withState: (enum PzTenKeyState) newstate ;

@end
