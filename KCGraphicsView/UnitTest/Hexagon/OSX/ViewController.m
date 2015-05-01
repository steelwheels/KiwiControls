//
//  ViewController.m
//  UTHexagon
//
//  Created by Tomoo Hamada on 2015/03/13.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"
#import "UTHexagonDrawer.h"

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.graphicsView.layer.backgroundColor = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1.0) ;
							     	
	UTHexagonDrawer * drawer = [[UTHexagonDrawer alloc] init] ;
	[self.graphicsView addGraphicsDrawer: drawer withDelegate: nil] ;
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}

@end
