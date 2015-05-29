//
//  ViewController.m
//  UnitTest
//
//  Created by Tomoo Hamada on 2015/05/30.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	dataSource = [[UTDataSource alloc] init] ;
	self.tableView.dataSource = dataSource ;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
