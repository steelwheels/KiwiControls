//
//  ViewController.h
//  UnitTest
//
//  Created by Tomoo Hamada on 2015/05/20.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KCNumberStepper/KCNumberStepper.h>

@interface ViewController : UIViewController <KCNumberStepperOperating>

@property (weak, nonatomic) IBOutlet KCNumberStepperView *numberStepperView ;


@end

