/**
 * @file	KCViewAdjuster.m
 * @brief	Define KCViewAdjuster class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCViewAdjuster.h"
#import "KCViewUtil.h"
#import "KCPreference.h"

@implementation UILabel (KCViewSizeAdjuster)

- (CGRect) boundingRectOfTitle
{
	KCPreference * preference = [KCPreference sharedPreference] ;
	
	CGRect		maxframe = [preference applicationFrame] ;
	NSString *	title = self.text ;
	CGRect textbounds = [title boundingRectWithSize: maxframe.size
						options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
					     attributes: @{NSFontAttributeName: self.font}
						context: nil] ;
	CGRect		totalrect = KSExpandRectByInsets(textbounds, [self alignmentRectInsets]) ;
	return totalrect ;
}

@end

@implementation UIButton (KCViewSizeAdjuster)

- (CGRect) boundingRectOfTitle
{
	CGRect labelrect = [self.titleLabel boundingRectOfTitle] ;
	CGRect titlerect = KSExpandRectByInsets(labelrect, self.titleEdgeInsets) ;
	return KSExpandRectByInsets(titlerect, self.contentEdgeInsets) ;
}

@end
