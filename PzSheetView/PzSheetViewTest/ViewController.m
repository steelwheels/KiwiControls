/**
 * @file	ViewController.m
 * @brief	Definen ViewController class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "ViewController.h"

@interface ViewController (Private)
- (void) unitTest ;
- (void) pressInputButton: (UIButton *) button ;
@end

@implementation ViewController
            
- (void)viewDidLoad {	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// Link input button event and pressInputButton method
	[inputButton addTarget: self action: @selector(pressInputButton:) forControlEvents: UIControlEventTouchUpInside] ;
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

- (void) pressInputButton: (UIButton *) button
{
	((void) button) ;
	NSLog(@"pIB") ;
}

@end
