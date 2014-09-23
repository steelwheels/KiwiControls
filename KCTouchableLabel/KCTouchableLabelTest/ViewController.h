//
//  ViewController.h
//  KCTouchableLabelTest
//
//  Created by Tomoo Hamada on 2014/09/23.
//  Copyright (c) 2014年 Steel Wheels Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KCTouchableLabel/KCTouchableLabel.h>

@interface TouchDelegate : NSObject <KCTouchLabelDelegate>
@end

@interface ViewController : UIViewController
{
	TouchDelegate *				touchDelegate ;
	__weak IBOutlet KCTouchableLabel *	touchableLabel;
}

@end

