//
//  ViewController.h
//  UnitTest
//
//  Created by Tomoo Hamada on 2015/05/30.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

#import <KCTableView/KCTableView.h>
#import "UTDataSource.h"
#import "UTDelegate.h"

@interface ViewController : UIViewController
{
	UTDataSource *	dataSource ;
	UTDelegate *	tableDelegate ;
}

@property (weak, nonatomic) IBOutlet KCTableView *tableView ;

@end

