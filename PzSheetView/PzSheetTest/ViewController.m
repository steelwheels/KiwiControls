//
//  ViewController.m
//  PzSheetTest
//
//  Created by Tomoo Hamada on 2014/09/21.
//  Copyright (c) 2014年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@interface ViewController (Private)
- (void) pressLeftButton: (UIButton *) button ;
- (void) pressRightButton: (UIButton *) button ;
- (void) pressEnterButton: (UIButton *) button ;
- (void) pressReturnButton: (UIButton *) button ;
- (void) pressClearButton: (UIButton *) button ;
- (void) pressAllClearButton: (UIButton *) button ;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Link input button event and pressInputButton method
	[leftButton   addTarget: self action: @selector(pressLeftButton:)   forControlEvents: UIControlEventTouchUpInside] ;
	[rightButton  addTarget: self action: @selector(pressRightButton:)  forControlEvents: UIControlEventTouchUpInside] ;
	[enterButton  addTarget: self action: @selector(pressEnterButton:)  forControlEvents: UIControlEventTouchUpInside] ;
	[returnButton addTarget: self action: @selector(pressReturnButton:) forControlEvents: UIControlEventTouchUpInside] ;
	[clearButton addTarget: self action: @selector(pressClearButton:) forControlEvents: UIControlEventTouchUpInside] ;
	[allClearButton addTarget: self action: @selector(pressAllClearButton:) forControlEvents: UIControlEventTouchUpInside] ;
	
	[sheetView setTextFieldDelegate: self] ;
	[sheetView setTouchableLabelDelegate: self] ;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) enterText: (NSString *) text atIndex: (NSUInteger) index
{
	NSLog(@"ViewController: Enter \"%@\" at Index %u\n", text, (unsigned int) index) ;
}

- (void) touchLabelAtIndex:(NSUInteger) index atAbsolutePoint: (CGPoint) point
{
	NSLog(@"TouchLabel at %u (x:%lf, y:%lf)", (unsigned int) index, point.x, point.y) ;
}

@end

@implementation ViewController (Private)

- (void) pressLeftButton: (UIButton *) button
{
	//NSLog(@"pressLeftButton") ;
	[sheetView moveCursorBackwardInExpressionField] ;
}

- (void) pressRightButton: (UIButton *) button
{
	//NSLog(@"pressRightButton") ;
	[sheetView moveCursorForwardInExpressionField] ;
}

- (void) pressEnterButton: (UIButton *) button
{
	//NSLog(@"pressEnterButton") ;
	if(textField == nil){
		NSLog(@"no text field") ;
		return ;
	}
	
	NSString * inputtext = textField.text ;
	if([inputtext length] > 0){
		[sheetView activateFirstResponder] ;
		[sheetView insertStringToExpressionField: inputtext] ;
	}
}

- (void) pressReturnButton: (UIButton *) button
{
	//NSLog(@"pressReturnButton") ;
	[sheetView selectNextExpressionField] ;
}

- (void) pressClearButton: (UIButton *) button
{
	[sheetView clearCurrentField] ;
}

- (void) pressAllClearButton: (UIButton *) button
{
	[sheetView clearAllFields] ;
}

@end

