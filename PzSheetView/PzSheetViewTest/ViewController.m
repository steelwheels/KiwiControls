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
- (void) pressEnterButton: (UIButton *) button ;
- (void) moveLeftButton: (UIButton *) button ;
- (void) moveRightButton: (UIButton *) button ;

@end

@implementation ViewController
            
- (void)viewDidLoad {	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// Link input button event and pressInputButton method
	[inputButton addTarget: self action: @selector(pressInputButton:) forControlEvents: UIControlEventTouchUpInside] ;
	[enterReturnButton addTarget: self action: @selector(pressEnterButton:) forControlEvents: UIControlEventTouchUpInside] ;
	[moveLeftButton addTarget: self action: @selector(moveLeftButton:) forControlEvents: UIControlEventTouchUpInside] ;
	[moveRightButton addTarget: self action: @selector(moveRightButton:) forControlEvents: UIControlEventTouchUpInside] ;
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
	if(inputField == nil){
		NSLog(@"no input field") ;
		return ;
	}
	
	NSString * inputtext = inputField.text ;
	if([inputtext length] > 0){
		[sheetView insertStringToExpressionField: inputtext] ;
	}
}

- (void) pressEnterButton: (UIButton *) button
{
	[sheetView selectNextExpressionField] ;
}

- (void) moveLeftButton: (UIButton *) button
{
	[sheetView moveCursorBackwardInExpressionField] ;
}

- (void) moveRightButton: (UIButton *) button
{
	[sheetView moveCursorForwardInExpressionField] ;
}

@end
