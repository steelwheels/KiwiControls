//
//  ViewController.h
//  UnitTest
//
//  Created by Tomoo Hamada on 2015/05/30.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

#import <KCTableView/KCTableView.h>
#import "UTDataSource.h"

@interface ViewController : UIViewController
{
	UTDataSource *	dataSource ;
}

@property (weak, nonatomic) IBOutlet KCTableView *tableView ;

@end

