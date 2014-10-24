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
		didNibLoaded = NO ;
	}
	return self ;
}

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
	((void) tableView) ;
	return 1 ;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	((void) tableView) ; ((void) section) ;
	return [labelNames count] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	((void) tableView) ; ((void) indexPath) ;
	CGSize adjsize = [self adjustSize: [indexPath row]] ;
	return adjsize.height ;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(didNibLoaded == NO){
		UINib *nib = [UINib nibWithNibName: @"KCButtonTableCell" bundle:nil];
		[tableView registerNib:nib forCellReuseIdentifier: @"CustomCell"];
		didNibLoaded = YES ;
	}
	
	/* Set index */
	NSUInteger index = [indexPath row] ;
	KCButtonTableCell * newcell = [tableView dequeueReusableCellWithIdentifier: @"CustomCell"];
	newcell.tableButton.tag = index ;
	
	/* Set font */
	KCPreference * pref = [KCPreference sharedPreference] ;
	newcell.tableButton.titleLabel.font = [pref defaultFont] ;
	
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
	KCPreference *	pref = [KCPreference sharedPreference] ;
	NSDictionary *	attr = @{NSFontAttributeName: [pref defaultFont]};
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
