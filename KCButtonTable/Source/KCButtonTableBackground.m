/**
 * @file	KCButtonTableBackground.m
 * @brief	Define KCButtonTableBackground class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCButtonTableBackground.h"
#import <KiwiControl/KiwiControl.h>

@implementation KCButtonTableBackground

- (instancetype) initWithDelegate: (id <KCButtonTableBackgroundDelegate>) delegate
{
	KCPreference * preference = [KCPreference sharedPreference] ;
	if((self = [super initWithFrame: [preference applicationFrame]]) != nil){
		touchDelegate = delegate ;
		self.backgroundColor = [UIColor colorWithWhite:0 alpha: 0.0];
		self.userInteractionEnabled = true ;
	}
	return self ;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[touchDelegate touchBackground] ;
}

@end
