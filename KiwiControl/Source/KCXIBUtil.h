/**
 * @file	KCXIBUtil.h
 * @brief	Define utility functions for XIB file
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCType.h"

#if TARGET_OS_IPHONE

UIView *
KCLoadXib(UIView * parentview, NSString * nibname) ;

#endif /* TARGET_OS_IPHONE */
