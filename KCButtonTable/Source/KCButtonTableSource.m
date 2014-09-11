/**
 * @file	KCButtonTableSource.m
 * @brief	Define KCButtonTableSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCButtonTableSource.h"
#import "KCButtonTableCell.h"

@interface KCButtonTableSource (Private)
- (CGSize) adjustSize: (NSUInteger) index ;
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
	return 1 ;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [labelNames count] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize adjsize = [self adjustSize: [indexPath row]] ;
	return adjsize.height ;
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
	
	/* Resize */
	CGSize newsize = [self adjustSize: [indexPath row]] ;
	KCUpdateViewSize(newcell.tableButton, newsize) ;
	[newcell.contentView sizeToFit] ;
	
	return newcell ;
}

@end

@implementation KCButtonTableSource (Private)

- (CGSize) adjustSize: (NSUInteger) index
{
	NSString *	title = [labelNames objectAtIndex: index] ;
	CGSize		maxSize = CGSizeMake(200, CGFLOAT_MAX);
	NSDictionary *	attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize: 15.0]};
	CGRect newbounds = [title boundingRectWithSize:maxSize
					       options:NSStringDrawingUsesLineFragmentOrigin
					    attributes:attr
					       context:nil] ;
	CGSize result = CGSizeMake(ceilf(newbounds.size.width) + 8.0,
				   ceilf(newbounds.size.height) + 8.0) ;
	return result  ;
}

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
