/**
 * @file	KCButtonTable.h
 * @brief	Define KCButtonTable class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCButtonTableView.h"

@interface KCButtonTable : NSObject
{
	KCButtonTableView *		buttonTableView ;
}

- (instancetype) init ;

- (KCButtonTableView *) buttonTableWithLabelNames: (NSArray *) names withFrame: (CGRect) frame ;

@end
