/**
 * @file	KCButtonTable.h
 * @brief	Define KCButtonTable class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCButtonTableView.h"
#import "KCButtonTableBackground.h"

@interface KCButtonTable : NSObject <KCButtonTableDelegate, KCButtonTableBackgroundDelegate>
{
	id <KCButtonTableDelegate>	buttonTableDelegate ;
	KCButtonTableView *		buttonTableView ;
	KCButtonTableBackground *	backgroundView ;
}

- (instancetype) init ;

- (void) displayButtonTableWithLabelNames: (NSArray *) names
			     withDelegate: (id <KCButtonTableDelegate>) delegate
			       withOrigin: (CGPoint) origin
			 atViewController: (UIViewController *) controller ;

- (CGSize) frameSize ;

@end
