/**
 * @file	KCButtonTableBackground.h
 * @brief	Define KCButtonTableBackground class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@protocol KCButtonTableBackgroundDelegate
- (void) touchBackground ;
@end

@interface KCButtonTableBackground : UIView
{
	id <KCButtonTableBackgroundDelegate>	touchDelegate ;
}

- (instancetype) initWithDelegate: (id <KCButtonTableBackgroundDelegate>) delegate ;

@end
