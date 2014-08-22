/**
 * @file	ViewController.h
 * @brief	Definen ViewController class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import "PzSheetView/PzSheetView.h"

@interface ViewController : UIViewController
{
	__weak IBOutlet PzSheetView *sheetView;
	__weak IBOutlet UITextField *inputField;
	__weak IBOutlet UIButton *inputButton;
}

@end

