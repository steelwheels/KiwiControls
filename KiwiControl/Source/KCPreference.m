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
