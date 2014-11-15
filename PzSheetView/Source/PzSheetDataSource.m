/**
 * @file	PzSheetDataSource.m
 * @brief	Define PzSheetDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzSheetDataSource.h"
#import "PzSheetDatabase.h"
#import "PzSheetDelegate.h"
#import "PzSheetState.h"
#import "PzSheetCell.h"
#import <KiwiControl/KiwiControl.h>
#import <KCTextFieldCell/KCTextFieldCell.h>

#define MAX_ROW_NUM	128
#define DO_DEBUG	0

@interface PzSheetDataSource (Private)
- (void) scrollTo: (NSUInteger) newslot inTableView: (UITableView *) tableview ;
@end

@implementation PzSheetDataSource

@synthesize sheetDelegate ;

+ (NSUInteger) maxRowNum
{
	return MAX_ROW_NUM ;
}

- (instancetype) initWithSheetState: (PzSheetState *) state withDatabase: (PzSheetDatabase *) database
{
	if((self = [super init]) != nil){
		didNibPrepared = NO ;
		sheetState = state ;
		sheetDatabase = database ;
		self.sheetDelegate = nil ;
	}
	return self ;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
	((void) tableView) ;
	return 1 ;
}

- (PzSheetCell *) searchSheetCellInTableView: (UITableView *) tableview atIndex: (NSUInteger) index
{
	NSIndexPath * path = [NSIndexPath indexPathForRow: index inSection: 0] ;
	PzSheetCell * cell = (PzSheetCell *) [tableview cellForRowAtIndexPath: path] ;
	return cell ;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
	((void) tableView) ; ((void) section) ;
	return MAX_ROW_NUM ;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(didNibPrepared == NO){
		UINib * nib = [UINib nibWithNibName: @"PzSheetCell" bundle:nil];
		if(nib){
			[tableView registerNib: nib forCellReuseIdentifier: @"Key"];
		} else {
			NSLog(@"Failed to load nib\n") ;
		}
		didNibPrepared = YES ;
	}

	PzSheetCell * newcell = [tableView dequeueReusableCellWithIdentifier: @"Key"];
	if(newcell == nil){
		newcell = [[PzSheetCell alloc] initWithStyle: UITableViewCellStyleDefault
					     reuseIdentifier: @"Key"];
	}
	
	/* To suppress display keyboard, give dummy view
	 * See http://stackoverflow.com/questions/5615806/disable-uitextfield-keyboard
	 */
	UIView * dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	newcell.expressionField.inputView = dummyView; // Hide keyboard, but show blinking cursor

	/* Setup text field */
	NSInteger row = indexPath.row ;
	if(row == 0){
		[newcell.expressionField becomeFirstResponder] ;
	}
	[PzSheetState setSlotNum: row toTextField: newcell.expressionField] ;
	newcell.expressionField.text = [sheetDatabase expressionStringAtIndex: row] ;
	[newcell.expressionField setDelegate: sheetDelegate] ;
	
	/* Setup label */
	[PzSheetState setSlotNum: row toLabel: newcell.touchableLabel] ;
	newcell.touchableLabel.text = [sheetDatabase labelStringAtIndex: row] ;
	newcell.touchableLabel.touchableLabelDelegate = sheetDelegate ;
	
	// return the cell
	return newcell;
}

- (void) moveCursorForwardInExpressionFieldInTableView: (UITableView *) tableview
{
	NSUInteger	currentslot = sheetState.currentSlot ;
	[self scrollTo: currentslot inTableView: tableview] ;
	
	PzSheetCell *	currentcell = [self searchSheetCellInTableView: tableview atIndex: currentslot] ;
	
	KCTextFieldCell *	currentfield = currentcell.expressionField ;
	UITextRange *		currentrange = currentfield.selectedTextRange;
	if([currentrange.start isEqual: currentfield.endOfDocument]){
		return;
	}
	
	/* Update text field view */
	UITextPosition * newpos = [currentfield positionFromPosition: currentrange.start offset:+1];
	UITextRange *newrange;
	if([currentrange isEmpty]){
		newrange = [currentfield textRangeFromPosition: newpos
						    toPosition: newpos];
	} else {
		newrange = [currentfield textRangeFromPosition: newpos
						    toPosition: currentrange.end];
	}
	currentfield.selectedTextRange = newrange;
}

- (void) moveCursorBackwardInExpressionFieldInTableView: (UITableView *) tableview
{
	NSUInteger	currentslot = sheetState.currentSlot ;
	[self scrollTo: currentslot inTableView: tableview] ;

	PzSheetCell *	currentcell = [self searchSheetCellInTableView: tableview atIndex: currentslot] ;
	
	KCTextFieldCell *	currentfield = currentcell.expressionField ;
	UITextRange *		currentrange = currentfield.selectedTextRange;
	if([currentrange.start isEqual: currentfield.beginningOfDocument]){
		return;
	}
	
	/* Update text field view */
	UITextPosition *newpos = [currentfield positionFromPosition: currentrange.start offset:-1];
	UITextRange * newrange;
	if([currentrange isEmpty]){
		newrange = [currentfield textRangeFromPosition: newpos
						    toPosition: newpos];
	} else {
		newrange = [currentfield textRangeFromPosition: newpos
						    toPosition: currentrange.end];
	}
	currentfield.selectedTextRange = newrange;
}

- (void) clearCurrentFieldInTableView: (UITableView *) tableview
{
	NSUInteger	currentslot = sheetState.currentSlot ;
	[self scrollTo: currentslot inTableView: tableview] ;
	PzSheetCell *	currentcell = [self searchSheetCellInTableView: tableview atIndex: currentslot] ;
	
	KCTextFieldCell * currentfield = currentcell.expressionField ;
	currentfield.text = @"" ;
	
	[sheetDelegate.textFieldDelegate clearTextAtIndex: currentslot] ;
	[sheetDatabase clearStringsAtIndex: currentslot] ;
}

- (void) clearAllFieldsInTableView: (UITableView *) tableview
{
	NSUInteger i ;
	for(i=0 ; i<MAX_ROW_NUM ; i++){
		PzSheetCell * cell = [self searchSheetCellInTableView: tableview atIndex: i] ;
		if(cell){
			cell.expressionField.text = @"" ;
			[sheetDelegate.textFieldDelegate clearTextAtIndex: i] ;
		}
		[sheetDatabase clearStringsAtIndex: i] ;
	}
	
	/* Return to top slot */
	[self scrollTo: 0 inTableView: tableview] ;
}

- (void) selectNextExpressionFieldInTableView: (UITableView *) tableview
{
	/* Make the slot as the 1st responder */
	NSUInteger currentslot = [sheetState currentSlot] ;
	NSUInteger nextslot = currentslot + 1 ;
	if(nextslot == MAX_ROW_NUM){
		nextslot = 0 ;
	}
	
	/* Scroll to the destination slot */
	[self scrollTo: nextslot inTableView: tableview] ;
}

- (void) insertStringToExpressionField: (NSString *) str inTableView: (UITableView *) tableview
{
	NSUInteger currentslot = [sheetState currentSlot] ;
	[self scrollTo: currentslot inTableView: tableview] ;
	
	PzSheetCell *		currentcell = [self searchSheetCellInTableView: tableview atIndex: currentslot] ;
	KCTextFieldCell *	currentfield = currentcell.expressionField ;
	
	[currentfield performSelectorOnMainThread:@selector(insertText:)
				withObject: str
			     waitUntilDone: YES];
	
	NSString * currenttext = currentfield.text ;
	[sheetDelegate.textFieldDelegate enterText: currenttext atIndex: currentslot] ;
	[sheetDatabase setExpressionString: currenttext atIndex: currentslot] ;
}

- (void) deleteSelectedStringInExpressionFieldInTableView: (UITableView *) tableview
{	
	NSUInteger currentslot = [sheetState currentSlot] ;
	[self scrollTo: currentslot inTableView: tableview] ;
	
	PzSheetCell *		currentcell = [self searchSheetCellInTableView: tableview atIndex: currentslot] ;
	KCTextFieldCell *	currentfield = currentcell.expressionField ;
	UITextRange *		selrange = currentfield.selectedTextRange ;
	if(selrange.empty){
		/* delete previous character */
		[currentfield deleteBackward] ;
	} else {
		/* change the  */
		UITextPosition * pos = selrange.start ;
		UITextRange * newrange = [currentfield textRangeFromPosition: pos toPosition: pos] ;
		[currentfield setSelectedTextRange: newrange] ;
	}
	NSString * currenttext = currentfield.text ;
	[sheetDelegate.textFieldDelegate enterText: currenttext atIndex: currentslot] ;
	[sheetDatabase setExpressionString: currenttext atIndex: currentslot] ;
}


- (void) setLabelText: (NSString *) text forSlot: (NSInteger) index inTableView: (UITableView *) tableview
{	
	PzSheetCell *	currentcell = [self searchSheetCellInTableView: tableview atIndex: index] ;
	if(currentcell){
		[sheetDatabase setLabelString: text atIndex: index] ;
		UILabel * label = currentcell.touchableLabel ;
		[label performSelectorOnMainThread:@selector(setText:)
					withObject:text
					waitUntilDone:NO];
		
	}
}

@end

@implementation PzSheetDataSource (Private)

- (void) scrollTo: (NSUInteger) newslot inTableView: (UITableView *) tableview
{
	/* Scroll to the destination slot */
	NSUInteger currentslot = sheetState.currentSlot ;
	NSIndexPath * currentpath = [NSIndexPath indexPathForRow: currentslot inSection: 0] ;
	PzSheetCell * currentcell = (PzSheetCell *) [tableview cellForRowAtIndexPath: currentpath] ;
	BOOL canresign ;
	if(currentcell){
		canresign = [currentcell.expressionField resignFirstResponder] ;
	} else {
		canresign = YES ;
	}
	
	//NSLog(@"scroll to %u", (unsigned int) currentslot) ;
	NSIndexPath * nextpath = [NSIndexPath indexPathForRow: newslot inSection: 0] ;
	[tableview scrollToRowAtIndexPath: nextpath
			 atScrollPosition: UITableViewScrollPositionNone
				 animated: NO] ;
	
	/* Activate the text field */
	PzSheetCell * nextcell = (PzSheetCell *) [tableview cellForRowAtIndexPath: nextpath] ;
	if(nextcell && canresign){
		[nextcell.expressionField becomeFirstResponder] ;
	}
	
	sheetState.currentSlot = newslot ;
}

@end



