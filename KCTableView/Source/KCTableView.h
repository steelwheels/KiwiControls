/**
 * @file	KCTableView.h
 * @brief	Define KCTableView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import <KiwiControl/KiwiControl.h>
#import "KCTableViewType.h"
#import "KCTableDataSource.h"

@interface KCTableView : UITableView

  /**
   * @brief This method must be called after ViewDidLoad.
   */
- (void) applyPreferenceColors ;

@end
