/**
 * @file	KCNumberStepperView.m
 * @brief	Define KCNumberStepperView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCNumberStepperView.h"
#import <KiwiControl/KiwiControl.h>

static inline NSInteger
clipValue(NSInteger maxval, NSInteger minval, NSInteger curval)
{
	NSInteger newval ;
	if(curval > maxval){
		newval = maxval ;
	} else if(curval < minval){
		newval = minval ;
	} else {
		newval = curval ;
	}
	return newval ;
}

@interface KCNumberStepperView ()
- (void) setupNumberStepper ;
- (void) setLabelTitle: (NSInteger) value ;
- (void) buttonPressed: (KCNumberStepperView *) view ;
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
	eventTarget		= nil ;
	eventSelector		= nil ;

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
	[self setLabelTitle: stepperView.value] ;
	[stepperView addTarget: self action: @selector(buttonPressed:) forControlEvents: UIControlEventValueChanged] ;
}

- (void) setMaxIntValue: (NSInteger) maxval withMinIntValue: (NSInteger) minval withStepIntValue: (NSInteger) step
{
	/**
	 * The current value must be kept before setting min/max value
	 * Because the value will be updated by setting min/max value
	 */
	NSInteger curval = stepperView.value ;
	
	stepperView.minimumValue = minval ;
	stepperView.maximumValue = maxval ;
	stepperView.stepValue	 = step ;

	NSInteger newval = clipValue(maxval, minval, curval) ;
	if(newval != curval){
		stepperView.value = newval ;
		[self setLabelTitle: newval] ;
	}
}

- (void) setValue: (NSInteger) val
{
	NSInteger newval = clipValue(stepperView.maximumValue, stepperView.minimumValue, val) ;
	if(stepperView.value != newval){
		stepperView.value = newval ;
		[self setLabelTitle: newval] ;
	}
}

- (NSInteger) value
{
	return (NSInteger) stepperView.value ;
}

- (void) setLabelTitle: (NSInteger) value
{
	NSString * title = [[NSString alloc] initWithFormat: @"%zd", value] ;
#	if TARGET_OS_IPHONE
	[labelView performSelectorOnMainThread: @selector(setText:)
				    withObject: title
				 waitUntilDone: YES] ;
#	else
	[labelView performSelectorOnMainThread: @selector(setStringValue:)
			       withObject: title
			    waitUntilDone: YES] ;
#	endif
}

- (void) setTarget: (id) target withSelector: (SEL) selector
{
	eventTarget	= target ;
	eventSelector	= selector ;
}

- (void) buttonPressed: (KCNumberStepperView *) view
{
	[self setLabelTitle: stepperView.value] ;
	if(eventTarget){
#		pragma clang diagnostic push
#		pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		[eventTarget performSelector: eventSelector withObject: view] ;
#		pragma clang diagnostic pop
	}
}

@end


