/**
 * @file	KCBitmapDrawer.h
 * @brief	Define KCBitmapDrawer class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCGraphicsDrawer.h"
#import <CoconutGraphics/CoconutGraphics.h>

@interface KCBitmapDrawer : KCGraphicsDrawer <KCGraphicsDrawing>
@property (strong, readonly) CNBitmap *			bitmap ;
@property (strong, readonly) CNColorIndexTable *	colorIndexTable ;

- (instancetype) initWithBitmap: (CNBitmap *) bitmap withColorIndexTable: (CNColorIndexTable *) table ;

@end
