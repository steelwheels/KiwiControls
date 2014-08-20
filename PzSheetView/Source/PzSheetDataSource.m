/**
 * @file	PzSheetDataSource.m
 * @brief	Define PzSheetDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzSheetDataSource.h"
#import "PzSheetCell.h"

#define MAX_ROW_NUM	16
#define DO_DEBUG	0

static inline NSString *
resultKey(NSInteger keyid)
{
	return [[NSString alloc] initWithFormat: @"v%d", (int) keyid] ;
}

@implementation PzSheetDataSource

- (instancetype) init
{
	if((self = [super init]) != nil){
		expressionTable = [[NSMutableArray alloc] initWithCapacity: MAX_ROW_NUM] ;
		resultTable = [[NSMutableDictionary alloc] initWithCapacity: MAX_ROW_NUM] ;
		currentSlot = 0 ;
	}
	return self ;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
	((void) tableView) ;
	return 1 ;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
	((void) section) ;
	return MAX_ROW_NUM ;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(DO_DEBUG){ NSLog(@"collectionView:cellForItemAtIndexPath\n") ; }
	
	static BOOL is1stcalling = true ;
	if(is1stcalling){
		UINib * nib = [UINib nibWithNibName: @"PzSheetCell" bundle:nil];
		if(nib){
			[tableView registerNib: nib forCellReuseIdentifier: @"Key"];
		} else {
			NSLog(@"Failed to load nib\n") ;
		}
		is1stcalling = false ;
	}
	
	/* Allocate new cell with button */
	PzSheetCell * newcell = [tableView dequeueReusableCellWithIdentifier: @"Key"];
	if(newcell == nil){
		NSLog(@"No Cell found\n") ;
	}
	
	/* Add text field */
	[expressionTable addObject: newcell.expressionField] ;
	if(indexPath.row == 0){
		[newcell.expressionField becomeFirstResponder] ;
	}
	
	/* Add observer for result value */
	NSString * resultkey = resultKey(indexPath.row) ;
	[resultTable addObserver: newcell forKeyPath: resultkey options: NSKeyValueObservingOptionNew context: nil] ;
	
	// return the cell
	return newcell;
}

- (void) selectNextExpressionField
{
	NSUInteger nextslot = currentSlot + 1 ;
	if(nextslot >= MAX_ROW_NUM){
		nextslot = 0 ;
	}
	UITextField * nextfield = [expressionTable objectAtIndex: nextslot] ;
	[nextfield becomeFirstResponder] ;
	currentSlot = nextslot ;
}

- (void) insertStringToExpressionField: (NSString *) str
{
	UITextField * textfield = [expressionTable objectAtIndex: currentSlot] ;
	[textfield insertText: str] ;
}

- (void) setResultValue: (PzSheetValue *) value forSlot: (NSInteger) index
{
	NSString * resultkey = resultKey(index) ;
	[resultTable setValue: value forKey: resultkey] ;
}

@end
