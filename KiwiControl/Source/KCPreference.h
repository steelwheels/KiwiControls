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
	
	/**
	 * @brief Dictionary of the color. The key is "NSString"
	 *   And the value is UIColor
	 */
	NSMutableDictionary *	colorDictionary ;
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

- (KCColor *) applicationColor: (NSString *) name ;

- (void) dumpToFile: (FILE *) outfp ;

@end

#undef KCColor
#undef KCFont

