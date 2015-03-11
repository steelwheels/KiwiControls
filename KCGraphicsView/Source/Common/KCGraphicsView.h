/**
 * @file	KCGraphicsView.h
 * @brief	Define KCGraphicsView class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <Foundation/Foundation.h>
#import <TargetConditionals.h>

//! Project version number for KCGraphicsView.
FOUNDATION_EXPORT double KCGraphicsViewVersionNumber;

//! Project version string for KCGraphicsView.
FOUNDATION_EXPORT const unsigned char KCGraphicsViewVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <KCGraphicsView/PublicHeader.h>

#if TARGET_OS_IPHONE
#	import "KCIGraphicsView.h"
#else
#	import "KCXGraphicsView.h"
#endif

#import "KCGraphicsFunc.h"
#import "KCGraphicsDrawer.h"
#import "KCGraphicsEditor.h"
#import "KCGraphicsDelegate.h"
#import "KCBitmapDrawer.h"
#import "KCGraphicsFunc.h"




