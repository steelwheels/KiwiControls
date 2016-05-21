/**
 * @file	SecondViewController.m
 * @brief	Define SecondViewController class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Do any additional setup after loading the view.
	[self.preferenceTable applyPreferenceColors] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender
{
	((void) sender) ;
	
	//NSLog(@"Backbutton pressed") ;
	[self dismissViewControllerAnimated:YES completion:nil] ;
}

@end