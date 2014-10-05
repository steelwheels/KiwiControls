/**
 * @file	KCPreference.h
 * @brief	Define KCPreference class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCPreference.h"
#import "KCColorTable.h"

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

- (NSString *) copyrightName
{
	return getStringValueInStandardUserDefaults(@"CopyrightName") ;
}

- (NSString *) copyrightURL
{
	return getStringValueInStandardUserDefaults(@"CopyrightURL") ;
}

- (NSString *) sourceCodeURL
{
	return getStringValueInStandardUserDefaults(@"SourceCodeURL") ;
}

- (NSString *) manualURL
{
	return getStringValueInStandardUserDefaults(@"ManualURL") ;
}

- (CGRect) applicationFrame
{
	return [[UIScreen mainScreen] applicationFrame] ;
}

- (UIFont *) menuFont
{
	return [UIFont systemFontOfSize: 14.0] ;
}

- (CGFloat) margin
{
	return 4.0 ;
}

- (UIColor *) foregroundColor
{
	KCColorTable * ctable = [KCColorTable defaultColorTable] ;
	return ctable.black ;
}

- (UIColor *) backgroundColor
{
	KCColorTable * ctable = [KCColorTable defaultColorTable] ;
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

