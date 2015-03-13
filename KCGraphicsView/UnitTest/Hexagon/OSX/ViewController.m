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

	UTHexagonDrawer * drawer = [[UTHexagonDrawer alloc] init] ;
	[self.graphicsView setGraphicsDrawer: drawer] ;
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}

@end
