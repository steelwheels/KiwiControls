/**
 * @file	KCNumberStepperView.h
 * @brief	Define KCNumberStepperView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCNumberStepperType.h"

@class KCNumberStepperView ;

@protocol  KCNumberStepperOperating <NSObject>
- (void) updateNumberStepper: (KCNumberStepperView *) view ;
@end

@interface KCNumberStepperView : UIView
{
	UILabel *			labelView ;
	UIStepper *			stepperView ;
}

@property (strong, nonatomic) id <KCNumberStepperOperating>	delegate ;

- (void) setMaxIntValue: (NSInteger) maxval withMinIntValue: (NSInteger) minval withStepIntValue: (NSInteger) step ;
- (void) setValue: (NSInteger) val ;
- (NSInteger) value ;

@end
