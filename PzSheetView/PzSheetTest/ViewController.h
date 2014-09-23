//
//  ViewController.h
//  PzSheetTest
//
//  Created by Tomoo Hamada on 2014/09/21.
//  Copyright (c) 2014年 Steel Wheels Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PzSheetView/PzSheetView.h"

@interface ViewController : UIViewController <PzSheetViewTextFieldDelegate>
{	
	__weak IBOutlet PzSheetView *sheetView;
	__weak IBOutlet UITextField *textField;
	__weak IBOutlet UIButton *leftButton;
	__weak IBOutlet UIButton *rightButton;
	__weak IBOutlet UIButton *enterButton;
	__weak IBOutlet UIButton *returnButton;
}

@end

