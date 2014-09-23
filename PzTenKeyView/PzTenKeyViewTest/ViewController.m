//
//  ViewController.m
//  PzTenKeyViewTest
//
//  Created by Tomoo Hamada on 2014/08/07.
//  Copyright (c) 2014年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (Private) <PzTenKeyClicking>

@end

@implementation ViewController

@synthesize tenKeyView ;

- (void)viewDidLoad {
	[super viewDidLoad];
	tenKeyView.delegate = self ;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end

@implementation ViewController (Private)

- (void) pressKey: (enum PzTenKeyCode) code
{
	NSString * msg = PzTenKeyTypeToString(code) ;
	NSLog(@"Delegate: 0x%x %@\n", (unsigned int) code, msg) ;
}

@end

