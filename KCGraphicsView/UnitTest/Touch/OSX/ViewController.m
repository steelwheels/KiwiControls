//
//  ViewController.m
//  Touch
//
//  Created by Tomoo Hamada on 2015/03/06.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"
#import "UTLineEditor.h"

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	
	UTLineEditor * leditor = [[UTLineEditor alloc] init] ;
	[self.graphicsView setGraphicsDrawer: leditor] ;
	[self.graphicsView setGraphicsEditor: leditor] ;
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}

@end
