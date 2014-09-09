/**
 * @file	KCViewExtension.h
 * @brief	Define KCViewExtension class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@protocol KCViewSizeAdjusting
- (CGRect) calcBoundRect ;
@end

@interface UILabel (KCViewSizeAdjuster) <KCViewSizeAdjusting>
@end

@interface UIButton (KCViewSizeAdjuster) <KCViewSizeAdjusting>
@end


