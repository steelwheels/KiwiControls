//
//  ViewController.m
//  UTSegmentedController
//
//  Created by Tomoo Hamada on 2015/07/27.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self.segmentedControl setTitle: @"Very Slow" forSegmentAtIndex: 0] ;
	[self.segmentedControl setTitle: @"Slow" forSegmentAtIndex: 1] ;
	[self.segmentedControl setTitle: @"Normal" forSegmentAtIndex: 2] ;
	
	[self.segmentedControl insertSegmentWithTitle: @"4th" atIndex: 3 animated: NO] ;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
