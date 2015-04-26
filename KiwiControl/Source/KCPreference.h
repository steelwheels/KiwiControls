/**
 * @file	KCPreference.h
 * @brief	Define KCPreference class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCType.h"

#if TARGET_OS_IPHONE
#	define	KCColor		UIColor
#	define	KCFont		UIFont
#else
#	define	KCColor		NSColor
#	define	KCFont		NSFont
#endif

@interface KCPreference : NSObject
{
	KCFont *	defaultFont ;
	KCFont *	defaultBoldFont ;
	KCColor *	fontColor ;
	KCColor *	foregroundColor ;
	KCColor *	backgroundColor ;
	KCColor *	borderColor ;
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

- (KCFont *) defaultFont ;
- (KCFont *) defaultBoldFont ;
- (KCColor *) fontColor ;

- (KCColor *) foregroundColor ;
- (KCColor *) backgroundColor ;
- (KCColor *) borderColor ;
- (CGFloat) borderWidth ;

@end

#undef KCColor
#undef KCFont

