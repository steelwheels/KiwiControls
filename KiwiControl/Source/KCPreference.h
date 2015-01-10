/**
 * @file	KCPreference.h
 * @brief	Define KCPreference class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#	import <UIKit/UIKit.h>
#else
#	import <AppKit/AppKit.h>
#endif

@interface KCPreference : NSObject
{
#if TARGET_OS_IPHONE
	UIFont *	defaultFont ;
	UIFont *	defaultBoldFont ;
#else
	NSFont *	defaultFont ;
	NSFont *	defaultBoldFont ;
#endif
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

#if TARGET_OS_IPHONE
- (CGRect) applicationFrame ;
#endif /* TARGET_OS_IPHONE */

- (CGFloat) margin ;

#if TARGET_OS_IPHONE
- (UIFont *) defaultFont ;
- (UIFont *) defaultBoldFont ;
#else /* TARGET_OS_IPHONE */
- (NSFont *) defaultFont ;
- (NSFont *) defaultBoldFont ;
#endif /* TARGET_OS_IPHONE */

#if TARGET_OS_IPHONE
- (UIColor *) foregroundColor ;
- (UIColor *) backgroundColor ;
#else /* TARGET_OS_IPHONE */
- (NSColor *) foregroundColor ;
- (NSColor *) backgroundColor ;
#endif /* TARGET_OS_IPHONE */
@end
