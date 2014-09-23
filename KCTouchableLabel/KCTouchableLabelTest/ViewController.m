//
//  ViewController.m
//  KCTouchableLabelTest
//
//  Created by Tomoo Hamada on 2014/09/23.
//  Copyright (c) 2014年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"



@implementation TouchDelegate

- (void)label:(KCTouchableLabel *)label touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	NSLog(@"touchedBegan") ;
}

- (void)label:(KCTouchableLabel *)label touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touchesEnded") ;
}

- (void)label:(KCTouchableLabel *)label touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)even
{
	NSLog(@"TouchesCancelled") ;
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	touchDelegate = [[TouchDelegate alloc] init] ;
	touchableLabel.touchableLabelDelegate = touchDelegate ;
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
