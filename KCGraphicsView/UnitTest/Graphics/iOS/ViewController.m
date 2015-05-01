//
//  ViewController.m
//  Graphics
//
//  Created by Tomoo Hamada on 2015/02/28.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"
#import "UTGraphicsDrawer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.graphicsView.backgroundColor = [UIColor blackColor] ;
	
	UTGraphicsDrawer * drawer = [[UTGraphicsDrawer alloc] init]  ;
	[self.graphicsView addGraphicsDrawer: drawer withDelegate: nil] ;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
