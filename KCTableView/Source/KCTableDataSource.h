/**
 * @file	KCTableDataSource.h
 * @brief	Define KCTableDataSource class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCTableViewType.h"

@interface KCTableDataSource : NSObject <UITableViewDataSource>
{
	BOOL		didNibPrepared ;
	UIColor *	backgroundColor ;
}

@property (strong, nonatomic) NSString *		nibName ;

- (instancetype) initWithNibName: (NSString *) name ;

@end
