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
	UIColor *	cellBackgroundColor ;
	UIColor *	cellLabelColor ;
}

- (instancetype) initWithId: (int) dummy ;

@end
