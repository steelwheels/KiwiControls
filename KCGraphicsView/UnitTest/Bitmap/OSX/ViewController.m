//
//  ViewController.m
//  UnitTest
//
//  Created by Tomoo Hamada on 2014/11/26.
//  Copyright (c) 2014年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"
#import "UTCheckerBitmap.h"

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// Do any additional setup after loading the view.
	CNBitmap * bitmap = UTAllocateCheckerBitmap(10, 10) ;
	CNColorIndexTable * colortable = UTAllocateCheckerColorIndexTable() ;
	KCBitmapDrawer * bitmapdrawer = [[KCBitmapDrawer alloc] initWithBitmap: bitmap
							   withColorIndexTable: colortable] ;
	[graphicsView setGraphicsDrawer: bitmapdrawer] ;
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}

@end
