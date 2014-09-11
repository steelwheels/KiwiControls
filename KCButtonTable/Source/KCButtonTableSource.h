/**
 * @file	KCButtonTableSource.h
 * @brief	Define KCButtonTableSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@protocol KCButtonTableDelegate
- (void) buttonPressed: (NSUInteger) index ;
@end

@interface KCButtonTableSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *				labelNames ;
@property (strong, nonatomic) id <KCButtonTableDelegate>	buttonTableDelegate ;

- (instancetype) init ;

@end
