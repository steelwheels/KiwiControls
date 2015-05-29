//
//  AppDelegate.m
//  UnitTest
//
//  Created by Tomoo Hamada on 2015/05/27.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

#import "AppDelegate.h"
#import <KiwiControl/KiwiControl.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	KCPreference * apref = [KCPreference sharedPreference] ;
	[apref dumpToFile: stdout] ;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

@end
