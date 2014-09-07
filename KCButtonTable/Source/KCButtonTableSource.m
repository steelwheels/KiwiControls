/**
 * @file	KCButtonTableSource.m
 * @brief	Define KCButtonTableSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCButtonTableSource.h"
#import "KCButtonTableCell.h"

@interface KCButtonTableSource (Private)
- (void) touchUpInsideEvent: (id) sender ;
@end

@implementation KCButtonTableSource

@synthesize buttonTableDelegate ;
@synthesize labelNames ;

- (instancetype) init
{
	if((self = [super init]) != nil){
		buttonTableDelegate = nil ;
		labelNames = @[@"item0"] ;
	}
	return self ;
}

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
	NSLog(@"sumberOfSectionsInTableView: 1") ;
	return 1 ;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"tableView:numberOfRowsInSection : %u", (unsigned int) [labelNames count]) ;
	return [labelNames count] ;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static BOOL s_is1st = YES ;
	if(s_is1st){
		UINib *nib = [UINib nibWithNibName: @"KCButtonTableCell" bundle:nil];
		[tableView registerNib:nib forCellReuseIdentifier: @"CustomCell"];
		s_is1st = NO ;
	}
	
	/* Set index */
	NSUInteger index = [indexPath row] ;
	KCButtonTableCell * newcell = [tableView dequeueReusableCellWithIdentifier: @"CustomCell"];
	newcell.tableButton.tag = index ;
	
	/* Set title */
	NSString * label = [labelNames objectAtIndex: index] ;
	[newcell.tableButton setTitle: label forState: UIControlStateNormal] ;
	
	/* Bind with the event handler */
	[newcell.tableButton addTarget:self action:@selector(touchUpInsideEvent:)
		forControlEvents:UIControlEventTouchUpInside];
	
	return newcell ;
}

@end

@implementation KCButtonTableSource (Private)
- (void) touchUpInsideEvent: (id) sender
{
	UIButton * button = (UIButton *) sender ;
	if(buttonTableDelegate){
		[buttonTableDelegate buttonPressed: button.tag] ;
	} else {
		NSLog(@"touchUpInsideEvent: %u", (unsigned int) button.tag) ;
	}
}

@end
