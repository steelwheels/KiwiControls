/**
 * @file	KCSegmentedControlView.m
 * @brief	Define KCSegmentedControllView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCSegmentedControlView.h"
#import <KiwiControl/KiwiControl.h>

@interface KCSegmentedControlView ()
- (void) setupSegmentedControlView ;
@end

@implementation KCSegmentedControlView

- (instancetype) initWithCoder:(NSCoder *) decoder
{
	if ((self = [super initWithCoder:decoder]) != nil){
		[self setupSegmentedControlView] ;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setupSegmentedControlView] ;
	}
	return self ;
}

- (void) setupSegmentedControlView
{
	UIView * xibview = KCLoadXib(self, NSStringFromClass(self.class)) ;
	if(xibview == nil){
		return ;
	}
	segmentedController = nil ;
	NSArray * subviews = [xibview subviews] ;
	for(UIView * subview in subviews){
		if([subview isKindOfClass: [KGSegmentedControl class]]){
			segmentedController = (KGSegmentedControl *) subview ;
			segmentedController.frame = self.bounds ;
			[self addSubview: segmentedController] ;
			KCLayoutSubviewWithMargines(self, segmentedController, 0.0, 0.0, 0.0, 0.0) ;
		} else {
			NSLog(@"Unknown subview class") ;
		}
	}
#if 0
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
		UIColor * backcol = [preference color: @"BackgroundColor"] ;
		if(backcol != nil){
			xibview.backgroundColor	    = backcol ;
			labelView.backgroundColor   = backcol ;
			stepperView.backgroundColor = backcol ;
		}
		
		/* Set font color */
		UIColor * fontcol = [preference color: @"FontColor"] ;
		if(fontcol){
			labelView.textColor = fontcol ;
		}
	}
#endif
}

- (void) addTarget:(id) target action:(SEL) action forControlEvents:(UIControlEvents) controlEvents
{
	if(segmentedController){
		[segmentedController addTarget: target action: action forControlEvents: controlEvents] ;
	}
}

@end
