/**
 * @file	KCPreference.h
 * @brief	Define KCPreference class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCPreference.h"
#import "KCColorTable.h"

@implementation KCPreference

+ (KCPreference *) sharedPreference
{
	static KCPreference * sharedPreference = nil ;
	if(sharedPreference == nil){
		sharedPreference = [[KCPreference alloc] init] ;
	}
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
