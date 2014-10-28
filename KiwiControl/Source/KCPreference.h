/**
 * @file	KCPreference.h
 * @brief	Define KCPreference class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@interface KCPreference : NSObject
{
	UIFont *	defaultFont ;
	UIFont *	defaultBoldFont ;
}

+ (KCPreference *) sharedPreference ;

- (instancetype) init ;

- (NSString *) applicationName ;
- (NSString *) version ;
- (NSString *) buildId ;

- (NSString *) developerName ;
- (NSString *) developerURL ;
- (NSString *) licenseName ;
- (NSString *) licenseURL ;
- (NSString *) sourceCodeURL ;
- (NSString *) manualURL ;

- (CGRect) applicationFrame ;

- (UIFont *) defaultFont ;
- (UIFont *) defaultBoldFont ;

- (CGFloat) margin ;

- (UIColor *) foregroundColor ;
- (UIColor *) backgroundColor ;

@end
