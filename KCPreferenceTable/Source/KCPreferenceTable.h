/**
 * @file	KCPreferenceTable.h
 * @brief	Define KCPreferenceTable class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import <KCTableView/KCTableView.h>

@class KCPreferenceTableSource ;
@class KCPreferenceTableDelegate ;

@interface KCPreferenceTable : KCTableView
{
	KCPreferenceTableSource *			tableSource ;
	KCPreferenceTableDelegate *			tableDelegate ;
}

@end
