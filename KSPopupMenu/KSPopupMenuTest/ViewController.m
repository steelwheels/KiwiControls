/**
 * @file	ViewController.m
 * @brief	Define ViewController class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self.popupButton addTarget: self action: @selector(clickEvent:event:) forControlEvents: UIControlEventTouchUpInside] ;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction) clickEvent:(id) sender event:(id) event
{
	NSLog(@"click event") ;
}

@end
