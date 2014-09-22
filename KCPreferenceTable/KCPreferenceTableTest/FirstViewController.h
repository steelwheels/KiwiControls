/**
 * @file	FirstViewController.h
 * @brief	Define FirstViewController class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@class SecondViewController ;

@interface FirstViewController : UIViewController
{
	SecondViewController *		secondViewController ;
}
- (IBAction)moveToSecondScene:(UIBarButtonItem *)sender;

@end

