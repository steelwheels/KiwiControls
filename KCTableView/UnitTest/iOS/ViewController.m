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
	dataSource = [[UTDataSource alloc] initWithNibName: @"UTTableCell"] ;
	self.tableView.dataSource = dataSource ;
	
	tableDelegate = [[UTDelegate alloc] init] ;
	self.tableView.delegate = tableDelegate ;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
