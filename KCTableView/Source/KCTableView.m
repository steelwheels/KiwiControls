/**
 * @file	KCTableView.m
 * @brief	Define KCTableView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCTableView.h"
#import <KiwiControl/KiwiControl.h>

@implementation KCTableView

- (void) applyPreferenceColors
{
	KCPreference * pref = [KCPreference sharedPreference] ;
	
	/* Background color */
	UIColor * backcol = [pref color: @"BackgroundColor"] ;
	if(backcol != nil){
		self.backgroundColor = backcol ;
		self.backgroundView.backgroundColor = backcol ;
	}
}

@end
