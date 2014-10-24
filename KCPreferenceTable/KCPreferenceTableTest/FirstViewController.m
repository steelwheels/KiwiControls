/**
 * @file	FirstViewController.m
 * @brief	Define FirstViewController class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondScene"];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction) moveToSecondScene:(UIBarButtonItem *)sender
{
	((void) sender) ;
	[self presentViewController:secondViewController animated:YES completion:nil];
}

@end
