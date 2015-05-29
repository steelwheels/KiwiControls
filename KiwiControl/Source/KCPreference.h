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
	NSUserDefaults *	applicationDefaults ;
	KCFont *		defaultFont ;
	KCFont *		boldFont ;
	KCColor *		fontColor ;
	KCColor *		foregroundColor ;
	KCColor *		backgroundColor ;
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

- (KCFont *) defaultFont ;
- (KCFont *) boldFont ;

- (KCColor *) fontColor ;
- (KCColor *) foregroundColor ;
- (KCColor *) backgroundColor ;

- (void) dumpToFile: (FILE *) outfp ;

@end

#undef KCColor
#undef KCFont

