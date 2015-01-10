/**
 * @file	KCPreference.h
 * @brief	Define KCPreference class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCPreference.h"
#import <CoconutGraphics/CoconutGraphics.h>

#if TARGET_OS_IPHONE
#	define KCColor		UIColor
#	define KCFont		UIFont
#else /* TARGET_OS_IPHONE */
#	define KCColor		NSColor
#	define KCFont		NSFont
#endif /* TARGET_OS_IPHONE */

static NSString * getStringValueInStandardUserDefaults(NSString * key) ;

@implementation KCPreference

+ (KCPreference *) sharedPreference
{
	static KCPreference * sharedPreference = nil ;
	static dispatch_once_t once;
	dispatch_once( &once, ^{
		sharedPreference = [[KCPreference alloc] init] ;
	});
	return sharedPreference ;
}

- (instancetype) init
{
	if((self = [super init]) != nil){
		defaultFont = [KCFont systemFontOfSize: 22.0] ;
		defaultBoldFont = [KCFont boldSystemFontOfSize: 22.0];
	}
	return self ;
}

- (NSString *) applicationName
{
	NSString * apppath = [[NSBundle mainBundle] bundlePath] ;
	NSString * filename = [apppath lastPathComponent] ;
	return [filename stringByDeletingPathExtension] ;
}

- (NSString *) version
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *) buildId
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSString *) developerName
{
	return getStringValueInStandardUserDefaults(@"DeveloperName") ;
}

- (NSString *) developerURL
{
	return getStringValueInStandardUserDefaults(@"DeveloperURL") ;
}

- (NSString *) licenseName
{
	return getStringValueInStandardUserDefaults(@"LicenseName") ;
}

- (NSString *) licenseURL
{
	return getStringValueInStandardUserDefaults(@"LicenseURL") ;
}

- (NSString *) sourceCodeURL
{
	return getStringValueInStandardUserDefaults(@"SourceCodeURL") ;
}

- (NSString *) manualURL
{
	return getStringValueInStandardUserDefaults(@"ManualURL") ;
}

#if TARGET_OS_IPHONE
- (CGRect) applicationFrame
{
	return [[UIScreen mainScreen] applicationFrame] ;
}
#endif /* TARGET_OS_IPHONE */

- (CGFloat) margin
{
	return 4.0 ;
}

- (KCFont *) defaultFont
{
	return defaultFont ;
}

- (KCFont *) defaultBoldFont
{
	return defaultBoldFont ;
}

- (KCColor *) foregroundColor
{
	CNColorTable * ctable = [CNColorTable defaultColorTable] ;
	return ctable.black ;
}

- (KCColor *) backgroundColor
{
	CNColorTable * ctable = [CNColorTable defaultColorTable] ;
	return ctable.white ;
}

@end

static NSString * getStringValueInStandardUserDefaults(NSString * key)
{
	static BOOL	s_is_initialized = NO ;
	if(!s_is_initialized){
		NSBundle * mainbundle = [NSBundle mainBundle];
		NSString* filepath  = [mainbundle pathForResource:@"AppDefaults" ofType:@"plist"];
		NSDictionary * userdict = [NSDictionary dictionaryWithContentsOfFile: filepath];
		if(userdict){
			NSUserDefaults * userdef = [NSUserDefaults standardUserDefaults] ;
			[userdef registerDefaults: userdict];
			[userdef synchronize];
		}
		s_is_initialized = YES ;
	}
	NSUserDefaults * userdef = [NSUserDefaults standardUserDefaults] ;
	NSString * value = [userdef stringForKey: key] ;
	return value ? value : @"" ;
}

