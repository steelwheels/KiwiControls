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
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: sCellIdentidier];
	if(cell == nil) {
		NSArray* nibArray = [[NSBundle mainBundle] loadNibNamed: self.nibName owner:nil options:nil];
		for(id obj in nibArray) {
			if( [obj isMemberOfClass:[UITableViewCell class]] ) {
				cell = (UITableViewCell *) obj;
				break;
			}
		}
	}
	return cell ;
}

@end
