/**
 * @file	KCViewUtil.h
 * @brief	Utility functions for UIView operation
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCType.h"

#if TARGET_OS_IPHONE
#	define	KCEdgeInsets		UIEdgeInsets
#	define	KCView			UIView
#else
#	define	KCEdgeInsets		NSEdgeInsets
#	define	KCView			NSView
#endif

static inline CGRect
KCUpdateRectSize(CGRect src, CGSize size)
{
	return CGRectMake(src.origin.x, src.origin.y, size.width, size.height) ;
}

static inline CGRect
KCExpandRectByInsets(CGRect rect, KCEdgeInsets insets)
{
	CGFloat	x = rect.origin.x - insets.left ;
	CGFloat y = rect.origin.y - insets.top ;
	CGFloat w = rect.size.width + insets.left + insets.right ;
	CGFloat h = rect.size.height + insets.top + insets.bottom ;
	return CGRectMake(x, y, w, h) ;
}

static inline void
KCUpdateViewOrigin(KCView * view, CGPoint origin)		   
{
	CGRect frame = view.frame ;
	frame.origin = origin ;
	view.frame = frame ;
}

static inline void
KCUpdateViewSize(KCView * view, CGSize newsize)
{
	view.frame  = KCUpdateRectSize(view.frame, newsize) ;
	view.bounds = KCUpdateRectSize(view.bounds, newsize) ;
#	if TARGET_OS_IPHONE
	CGFloat x = view.frame.origin.x + (newsize.width / 2) ;
	CGFloat y = view.frame.origin.y + (newsize.height / 2) ;
	view.center = CGPointMake(x, y) ;
#	endif
}

CGPoint
KCCenterPointInViewBounds(KCView * view) ;

CGPoint
KCAbsolutePointAtView(KCView * view, CGPoint centerpoint) ;

void
KCLayoutSubviewWithMargines(KCView * parentview, KCView * subview,
			    CGFloat topmargin, CGFloat bottommargin,
			    CGFloat leftmargin, CGFloat rightmargin) ;

#undef KCEdgeInsets
#undef KCView


