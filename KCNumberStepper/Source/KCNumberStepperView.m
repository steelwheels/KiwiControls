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
- (void) setLabelTitleOnMainThread: (NSString *) title ;
- (void) valueChanged: (KCNumberStepperView *) view ;
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
	if(xibview != nil){
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
			NSLog(@"Nil sub view") ;
		}
		[stepperView addTarget: self action: @selector(valueChanged:) forControlEvents: UIControlEventValueChanged] ;
		stepperView.value = 0 ;

		KCPreference * preference = [KCPreference sharedPreference] ;

		/* Set background color */
		UIColor * backcol = preference.backgroundColor ;
		xibview.backgroundColor	    = backcol ;
		labelView.backgroundColor   = backcol ;
		stepperView.backgroundColor = backcol ;

		/* Set font color */
		labelView.textColor = [preference fontColor] ;
	}
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
	}
}

- (void) setValue: (NSInteger) val
{
	NSInteger newval = clipValue(stepperView.maximumValue, stepperView.minimumValue, val) ;
	if(stepperView.value != newval){
		stepperView.value = newval ;
	}
}

- (NSInteger) value
{
	return (NSInteger) stepperView.value ;
}

- (void) setLabelTitle: (NSInteger) value
{
	NSString * title = [[NSString alloc] initWithFormat: @"%zd", value] ;
	[self performSelectorOnMainThread: @selector(setLabelTitleOnMainThread:)
			       withObject: title
			    waitUntilDone: YES] ;
}

- (void) setLabelTitleOnMainThread: (NSString *) title
{
#	if TARGET_OS_IPHONE
	[labelView setText: title] ;
#	else
	[labelView setStringValue: title] ;
#	endif
}

- (void) valueChanged: (UIView *) view
{
	if([view isKindOfClass: [UIStepper class]]){
		[self setLabelTitle: stepperView.value] ;
		if(self.delegate){
			[self.delegate updateNumberStepper: self] ;
		}
	} else {
		NSLog(@"Error Nil view") ;
	}
}

@end


