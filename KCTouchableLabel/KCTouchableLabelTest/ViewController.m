//
//  ViewController.m
//  KCTouchableLabelTest
//
//  Created by Tomoo Hamada on 2014/09/23.
//  Copyright (c) 2014年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"

@implementation TouchableDelegate

- (void)label:(KCTouchableLabel *)label touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	((void) label) ; ((void) touches) ; ((void) event) ;
	NSLog(@"touchedBegan") ;
}

- (void)label:(KCTouchableLabel *)label touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	((void) label) ; ((void) touches) ; ((void) event) ;
	NSLog(@"touchesEnded") ;
}

- (void)label:(KCTouchableLabel *)label touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	((void) label) ; ((void) touches) ; ((void) event) ;
	NSLog(@"TouchesCancelled") ;
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	touchDelegate = [[TouchableDelegate alloc] init] ;
	touchableLabel.touchableLabelDelegate = touchDelegate ;
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
