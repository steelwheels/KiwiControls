/**
 * @file	KCSegmentedControlView.h
 * @brief	Define KCSegmentedControllView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCSegmentedControllerType.h"

#if TARGET_OS_IPHONE
#	define KGSuperClassOfSegmentedControlView	UIView
#	define KGSegmentedControl			UISegmentedControl
#else
#	define KGSuperClassOfSegmentedControlView	NSView
#	define KGSegmentedControl			UISegmentedControl
#endif

@interface KCSegmentedControlView : KGSuperClassOfSegmentedControlView
{
	__weak KGSegmentedControl *		segmentedController ;
}

- (void) setTitle: (NSString *) title forSegmentAtIndex: (NSUInteger)segment ;
- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated ;
- (void) addTarget:(id) target action:(SEL) action forControlEvents: (UIControlEvents) controlEvents ;

@end

#undef KGSuperClassOfSegmentedControlView
