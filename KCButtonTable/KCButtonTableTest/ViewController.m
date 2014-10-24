//
//  ViewController.m
//  KCButtonTableTest
//
//  Created by Tomoo Hamada on 2014/09/04.
//  Copyright (c) 2014年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"
#import <KiwiControl/KiwiControl.h>

@implementation ViewController
            
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	KCButtonTable *	table = [[KCButtonTable alloc] init] ;
	NSArray * labels = @[@"item0", @"item1"] ;
	[table displayButtonTableWithLabelNames: labels
				   withDelegate: self
				     //withOrigin: CGPointMake(20, 20)
				     withOrigin: CGPointMake(120, 200)
				     //withOrigin: CGPointMake(320, 480)
			       atViewController: self] ;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) buttonPressed: (NSUInteger) index
{
	NSLog(@"Button pressed : %u", (unsigned int) index) ;
}

@end

