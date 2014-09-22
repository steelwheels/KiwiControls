/**
 * @file	SecondViewController.h
 * @brief	Define SecondViewController class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <KCPreferenceTable/KCPreferenceTable.h>

@interface SecondViewController : UIViewController

@property (weak, nonatomic) IBOutlet KCPreferenceTable *preferenceTable;

- (IBAction) backButtonPressed:(UIBarButtonItem *) sender ;

@end
