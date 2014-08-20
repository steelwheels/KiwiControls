//
//  ViewController.m
//  PzSheetViewTest
//
//  Created by Tomoo Hamada on 2014/08/14.
//  Copyright (c) 2014年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (Private)
- (void) unitTest ;
@end

@implementation ViewController
            
- (void)viewDidLoad {	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear: animated] ;
	[self unitTest] ;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end

@implementation ViewController (Privare)

- (void) unitTest
{
	/* Modify the sheet */
	PzSheetValue * newval = [[PzSheetValue alloc] init] ;
	[newval setBooleanValue: true] ;
	[sheetView setResultValue: newval forSlot: 0] ;
	
	[sheetView insertStringToExpressionField: @"100"] ;
}

@end
