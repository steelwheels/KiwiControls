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
	
	if(segmentedController){
		KCPreference * preference = [KCPreference sharedPreference] ;
		
		//UIColor * fontcol = [preference color: @"FontColor"] ;
		UIColor * forecol = [preference color: @"ForegroundColor"] ;
		UIColor * backcol = [preference color: @"BackgroundColor"] ;
		if(backcol){
			self.backgroundColor	= backcol ;
			segmentedController.backgroundColor = backcol ;
		}
		if(forecol){
			self.tintColor = forecol ;
		}
	}
}

- (void) setTitle: (NSString *) title forSegmentAtIndex: (NSUInteger)segment
{
	if(segmentedController){
		[segmentedController setTitle: title forSegmentAtIndex: segment] ;
	}
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated
{
	if(segmentedController){
		[segmentedController insertSegmentWithTitle: title atIndex: segment animated: animated] ;
	}
}

- (void) addTarget:(id) target action:(SEL) action forControlEvents:(UIControlEvents) controlEvents
{
	if(segmentedController){
		[segmentedController addTarget: target action: action forControlEvents: controlEvents] ;
	}
}

@end
