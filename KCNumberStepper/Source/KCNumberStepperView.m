/**
 * @file	KCNumberStepperView.m
 * @brief	Define KCNumberStepperView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCNumberStepperView.h"
#import <KiwiControl/KiwiControl.h>

@interface KCNumberStepperView ()
- (void) setupNumberStepper ;
@end

@implementation KCNumberStepperView

- (instancetype) initWithCoder:(NSCoder *) decoder
{
	if ((self = [super initWithCoder:decoder]) != nil){
		[self setupNumberStepper] ;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setupNumberStepper] ;
	}
	return self ;
}

- (void) setupNumberStepper
{
	self.delegate		= nil ;
	labelView		= nil ;
	stepperView		= nil ;

	UIView * xibview = KCLoadXib(self, NSStringFromClass(self.class)) ;
	if(xibview == nil){
		return ;
	}
	NSArray * subviews = [xibview subviews] ;
	for(UIView * subview in subviews){
		if([subview isKindOfClass: [UILabel class]]){
			//NSLog(@"*** subview : label") ;
			labelView   = (UILabel *) subview ;
		} else if([subview isKindOfClass: [UIStepper class]]){
			//NSLog(@"*** subview : stepper") ;
			stepperView = (UIStepper *) subview ;
		} else {
			NSLog(@"Unknown subview class") ;
		}
	}
	if(labelView == nil || stepperView == nil){
		NSLog(@"Nil view") ;
	}
	
	
}

- (void) setMaxValue: (NSInteger) maxval withMinValue: (NSInteger) minval
{
	
}

@end


