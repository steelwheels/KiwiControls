//
//  ViewController.m
//  Graphics
//
//  Created by Tomoo Hamada on 2015/02/28.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"
#import "UTGraphicsDrawer.h"

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	UTGraphicsDrawer * drawer = [[UTGraphicsDrawer alloc] init]  ;
	[self.graphicsView setDrawer: drawer] ;
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}

@end
