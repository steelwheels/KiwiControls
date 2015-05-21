/**
 * @file	KCNumberStepperView.h
 * @brief	Define KCNumberStepperView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCNumberStepperType.h"

@protocol  KCNumberStepperOperating <NSObject>
- (NSInteger) minStepperValue ;
- (NSInteger) maxStepperValue ;
- (void) updateStepperValue: (NSInteger) value ;
@end

@interface KCNumberStepperView : UIView
{
	UILabel *		labelView ;
	UIStepper *		stepperView ;
	
	id			eventTarget ;
	SEL			eventSelector ;
}

@property (strong, nonatomic) id <KCNumberStepperOperating>	delegate ;

- (void) setMaxIntValue: (NSInteger) maxval withMinIntValue: (NSInteger) minval withStepIntValue: (NSInteger) step ;
- (void) setValue: (NSInteger) val ;
- (NSInteger) value ;

- (void) setTarget: (id) target withSelector: (SEL) selector ;

@end
