/**
 * @file	KCBitmapDrawer.h
 * @brief	Define KCBitmapDrawer class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCGraphicsDrawing.h"
#import "KCGraphicsType.h"

@interface KCBitmapDrawer : NSObject <KCGraphicsDrawing>
@property (strong, readonly) CNBitmap *			bitmap ;
@property (strong, readonly) CNColorIndexTable *	colorIndexTable ;

- (instancetype) initWithBitmap: (CNBitmap *) bitmap withColorIndexTable: (CNColorIndexTable *) table ;

@end
