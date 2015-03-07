//
//  ViewController.m
//  UnitTest
//
//  Created by Tomoo Hamada on 2015/01/10.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"
#import <KCGraphicsView/KCGraphicsView.h>
#import <CoconutGraphics/CoconutGraphics.h>
#import "UTCheckerBitmap.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Do any additional setup after loading the view.
	CNBitmap * bitmap = UTAllocateCheckerBitmap(10, 10) ;
	CNColorIndexTable * colortable = UTAllocateCheckerColorIndexTable() ;
	KCBitmapDrawer * bitmapdrawer = [[KCBitmapDrawer alloc] initWithBitmap: bitmap
							   withColorIndexTable: colortable] ;
	[self.graphicsView setGraphicsDrawer: bitmapdrawer] ;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
