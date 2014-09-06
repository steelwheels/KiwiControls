/**
 * @file	KCButtonTableSource.h
 * @brief	Define KCButtonTableSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@interface KCButtonTableSource : NSObject <UITableViewDataSource>
{
	NSArray *		labelNames ;
}

+ (void) registerNib: (UITableView *) view ;

- (instancetype) init ;
- (void) setLabelNames: (NSArray *) names ;

@end
