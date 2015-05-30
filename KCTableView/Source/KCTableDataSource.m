/**
 * @file	KCTableDataSource.m
 * @brief	Define KCTableDataSource class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCTableDataSource.h"

@implementation KCTableDataSource

- (instancetype) initWithNibName: (NSString *) name
{
	if((self = [super init]) != nil){
		didNibPrepared = NO ;
		self.nibName = name ;
	}
	return self ;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	(void) tableView ; (void) section ;
	NSLog(@"This method must be overriddent") ;
	return 1 ;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	(void) indexPath ;
	static NSString *	sCellIdentidier = @"KCTableViewCellIdentifier" ;
	
	if(didNibPrepared == NO){
		UINib *nib = [UINib nibWithNibName: self.nibName bundle:nil];
		[tableView registerNib:nib forCellReuseIdentifier: sCellIdentidier];
		didNibPrepared = YES ;
	}
	UITableViewCell * newcell = [tableView dequeueReusableCellWithIdentifier: sCellIdentidier] ;
	if(newcell == nil){
		NSLog(@"Table cell is NOT found") ;
	}
	return newcell ;
}

@end
