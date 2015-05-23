//
//  ViewController.m
//  UnitTest
//
//  Created by Tomoo Hamada on 2015/05/20.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self.numberStepperView setMaxIntValue: 5 withMinIntValue: 1 withStepIntValue: 1] ;
	self.numberStepperView.delegate = self ;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) updateNumberStepper: (KCNumberStepperView *) view
{
	NSInteger val = [view value] ;
	printf("input value : %td\n", val) ;
}

@end
