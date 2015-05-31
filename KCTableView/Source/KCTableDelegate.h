/**
 * @file	KCTableDelegate.h
 * @brief	Define KCTableDelegate class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCTableViewType.h"

@interface KCTableDelegate : NSObject <UITableViewDelegate>
{
	UIColor *	headerColor ;
}

- (instancetype) init ;

@end
