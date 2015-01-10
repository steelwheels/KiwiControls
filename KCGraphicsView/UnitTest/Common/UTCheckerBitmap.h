/**
 * @file	UTCheckerBitmap.h
 * @brief	Define functions to allocate checker-bitmap patterns
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import <KCGraphicsView/KCGraphicsView.h>
#import <CoconutGraphics/CoconutGraphics.h>

CNBitmap *
UTAllocateCheckerBitmap(NSUInteger width, NSUInteger height) ;

CNColorIndexTable *
UTAllocateCheckerColorIndexTable(void) ;
