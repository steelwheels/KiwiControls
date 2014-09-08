/**
 * @file	KCViewAdjuster.h
 * @brief	Define KCViewAdjuster class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@protocol KCViewSizeAdjusting
- (CGRect) boundingRectOfTitle ;
@end

@interface UILabel (KCViewSizeAdjuster) <KCViewSizeAdjusting>
@end

@interface UIButton (KCViewSizeAdjuster) <KCViewSizeAdjusting>
@end


