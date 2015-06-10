//
//  ViewController.m
//  Touch
//
//  Created by Tomoo Hamada on 2015/03/07.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"
#import "UTLineEditor.h"

@interface ViewController () <KCGraphicsDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UTLineEditor * leditor = [[UTLineEditor alloc] init] ;
	[self.graphicsView addGraphicsDrawer: leditor withDelegate: self] ;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) editingGraphicsEndedWithData: (void *) data
{
	(void) data ;
}

- (void) editingGraphicsCancelled
{
	
}

@end
