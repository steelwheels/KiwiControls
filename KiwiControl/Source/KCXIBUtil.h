/**
 * @file	KCXIBUtil.h
 * @brief	Define utility functions for XIB file
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

UIView *
KCLoadXib(UIView * parentview, NSString * nibname) ;

#endif /* TARGET_OS_IPHONE */
