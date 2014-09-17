/**
 * @file	KCPreferenceTable.h
 * @brief	Define KCPreferenceTable class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@class KCPreferenceTableSource ;

@interface KCPreferenceTable : UIView
{
	__unsafe_unretained IBOutlet UITableView *	preferenceTableView;
	KCPreferenceTableSource *			preferenceTableSource ;
}

@end
