/**
 * @file	KCSwitchClass.m
 * @brief	Define KCSwitch class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCSwitchClass.h"

@interface KCSwitch ()
- (void) setSwitchAttribute ;
@end

@implementation KCSwitch

- (instancetype) initWithCoder:(NSCoder *) decoder
{
	if((self = [super initWithCoder: decoder]) != nil){
		[self setSwitchAttribute] ;
	}
	return self ;
}

#if TARGET_OS_IPHONE
- (instancetype) initWithFrame:(CGRect)frame
#else
- (instancetype) initWithFrame:(NSRect)frame
#endif
{
	if((self = [super initWithFrame: frame]) != nil){
		[self setSwitchAttribute] ;
	}
	return self ;
}

- (void) setSwitchAttribute
{
#if TARGET_OS_IPHONE
#else
	[self setButtonType: NSSwitchButton] ;
#endif
}

@end
