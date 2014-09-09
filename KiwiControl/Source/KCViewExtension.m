/**
 * @file	KCViewExtension.m
 * @brief	Define KCViewExtension class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCViewExtension.h"
#import "KCViewUtil.h"
#import "KCPreference.h"

@implementation UILabel (KCViewSizeAdjuster)

- (CGRect) calcBoundRect
{
	KCPreference * preference = [KCPreference sharedPreference] ;
	
	CGRect		maxframe = [preference applicationFrame] ;
	NSString *	title = self.text ;
	CGRect textbounds = [title boundingRectWithSize: maxframe.size
						options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
					     attributes: @{NSFontAttributeName: self.font}
						context: nil] ;
	CGRect		totalrect = KCExpandRectByInsets(textbounds, [self alignmentRectInsets]) ;
	return totalrect ;
}

@end

@implementation UIButton (KCViewSizeAdjuster)

- (CGRect) calcBoundRect
{
	CGRect labelrect = [self.titleLabel calcBoundRect] ;
	CGRect titlerect = KCExpandRectByInsets(labelrect, self.titleEdgeInsets) ;
	return KCExpandRectByInsets(titlerect, self.contentEdgeInsets) ;
}

@end
