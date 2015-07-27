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

@end

#undef KGSuperClassOfSegmentedControlView
