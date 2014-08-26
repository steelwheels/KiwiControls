/**
 * @file	KSPopupMenuViewController.m
 * @brief	Define KSPopupMenuViewController class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KSPopupMenuViewController.h"
#import "KSPopupMenuCell.h"

#define DO_DEBUG	1

@interface KSPopupMenuViewController ()

@end

@implementation KSPopupMenuViewController

@synthesize labelNameArray ;

- (instancetype) initWithStyle: (UITableViewStyle) style
{
	if((self = [super initWithStyle: style]) != nil){
		labelNameArray = nil ;
	}
	return self ;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void) didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
	return 1 ;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
	return [labelNameArray count] ;
}

- (UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(DO_DEBUG){ NSLog(@"collectionView:cellForItemAtIndexPath\n") ; }
	
	static BOOL is1stcalling = true ;
	if(is1stcalling){
		UINib * nib = [UINib nibWithNibName: @"KSPopupMenuCell" bundle:nil];
		if(nib){
			[tableView registerNib: nib forCellReuseIdentifier: @"Key"];
		} else {
			NSLog(@"Failed to load nib\n") ;
		}
		is1stcalling = false ;
	}
	
	/* Allocate new cell with button */
	KSPopupMenuCell * newcell = [tableView dequeueReusableCellWithIdentifier: @"Key"];
	if(newcell == nil){
		NSLog(@"No Cell found\n") ;
	}
	
	/* Get index of this menu */
	NSInteger index = indexPath.row ;
	NSString * label = [labelNameArray objectAtIndex: index] ;
	newcell.menuButton.titleLabel.text = label ;
	
	// return the cell
	return newcell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	/* Override to support conditional editing of the table view. */
	return NO ;
}

@end
