/**
 * @file	KCPreference.h
 * @brief	Define KCPreference class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@interface KCPreference : NSObject

+ (KCPreference *) sharedPreference ;

- (CGRect) applicationFrame ;

- (UIFont *) menuFont ;
- (CGFloat) margin ;

- (UIColor *) foregroundColor ;
- (UIColor *) backgroundColor ;

@end
