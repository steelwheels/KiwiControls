//
//  ViewController.m
//  KCButtonTableTest
//
//  Created by Tomoo Hamada on 2014/09/04.
//  Copyright (c) 2014年 Steel Wheels Project. All rights reserved.
//

#import "ViewController.h"
#import "KCButtonTable.h"
#import <KiwiControl/KiwiControl.h>

@interface ViewController (Private)

- (void) closeAddView: (id) sender ;

@end

@implementation ViewController
            
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
#if 0
	UIView *uiAdd = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 150, 250)];
	uiAdd.backgroundColor = [UIColor redColor];
#elif 0
	NSArray * labels = @[@"item0", @"item1"] ;
	UINib *nib = [UINib nibWithNibName:@"KCButtonTableView" bundle:nil];
	KCButtonTableView * uiAdd = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
	[uiAdd setLabelNames: labels] ;
	//uiAdd.backgroundColor = [UIColor redColor];
#else
	KCButtonTable *	table = [[KCButtonTable alloc] init] ;
	NSArray * labels = @[@"item0", @"item1"] ;
	KCButtonTableView * uiAdd = [table buttonTableWithLabelNames: labels withFrame: CGRectMake(0, 0, 150, 250)] ;
#endif
	KCPrintView(uiAdd) ;
	uiAdd.tag = 255;
	uiAdd.userInteractionEnabled = YES;
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAddView:)];
	[uiAdd addGestureRecognizer:tapGesture];
	[self.view addSubview:uiAdd] ;
	//[self.view bringSubviewToFront: uiAdd] ;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end

@implementation ViewController (Private)

- (void) closeAddView: (id) sender
{
	
}

@end
