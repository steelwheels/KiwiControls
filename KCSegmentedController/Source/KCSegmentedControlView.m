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
	
		UIFont *font = [UIFont systemFontOfSize: 18.0f];
		NSDictionary * fontattr = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
		[segmentedController setTitleTextAttributes: fontattr
						   forState: UIControlStateNormal];
	}
}

- (void) setSelectedSegmentIndex: (NSUInteger) index
{
	if(segmentedController){
		segmentedController.selectedSegmentIndex = index ;
	} else {
		NSLog(@"No controller") ;
	}
}

- (NSUInteger) selectedSegmentIndex
{
	if(segmentedController){
		return segmentedController.selectedSegmentIndex ;
	} else {
		NSLog(@"No controller") ;
		return 0 ;
	}
}

- (void) setTitle: (NSString *) title forSegmentAtIndex: (NSUInteger)segment
{
	if(segmentedController != nil){
		NSUInteger curnum = segmentedController.numberOfSegments ;
		if(segment < curnum){
			[segmentedController setTitle: title forSegmentAtIndex: segment] ;
		} else {
			[segmentedController insertSegmentWithTitle: title atIndex: segment animated: NO] ;
		}
	}
}

- (void) addTarget:(id) target action:(SEL) action forControlEvents:(UIControlEvents) controlEvents
{
	if(segmentedController){
		[segmentedController addTarget: target action: action forControlEvents: controlEvents] ;
	}
}

@end
