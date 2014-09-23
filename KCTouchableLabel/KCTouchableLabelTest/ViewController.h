//
//  ViewController.h
//  KCTouchableLabelTest
//
//  Created by Tomoo Hamada on 2014/09/23.
//  Copyright (c) 2014年 Steel Wheels Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KCTouchableLabel/KCTouchableLabel.h>

@interface TouchableDelegate : NSObject <KCTouchableLabelDelegate>
@end

@interface ViewController : UIViewController
{
	TouchableDelegate *			touchDelegate ;
	__weak IBOutlet KCTouchableLabel *	touchableLabel;
}

@end

