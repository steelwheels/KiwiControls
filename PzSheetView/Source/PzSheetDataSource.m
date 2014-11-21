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
#import <KCTextFieldExtension/KCTextFieldExtension.h>

#define DO_DEBUG	0

@interface PzSheetDataSource (Private)
- (BOOL) isVisibleCell: (UITableViewCell *) cell inTableView: (UITableView *) tableview ;
- (NSString *) executeTextFieldCommand: (KCTextFieldCommand *) command atSlot: (NSUInteger) slot inTableView: (UITableView *) tableview ;
- (void) scrollTo: (NSUInteger) newslot inTableView: (UITableView *) tableview ;
@end

@implementation PzSheetDataSource

@synthesize sheetDelegate ;

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
	return [PzSheetDatabase maxRowNum] ;
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
	KCTextFieldCommand * command = [KCTextFieldCommand moveRightCursorCommand] ;
	[self executeTextFieldCommand: command atSlot: sheetState.currentSlot inTableView: tableview] ;
}

- (void) moveCursorBackwardInExpressionFieldInTableView: (UITableView *) tableview
{
	KCTextFieldCommand * command = [KCTextFieldCommand moveLeftCursorCommand] ;
	[self executeTextFieldCommand: command atSlot: sheetState.currentSlot inTableView: tableview] ;
}

- (void) clearCurrentFieldInTableView: (UITableView *) tableview
{
	KCTextFieldCommand * command = [KCTextFieldCommand clearCommand] ;
	[self executeTextFieldCommand: command atSlot: sheetState.currentSlot inTableView: tableview] ;
	
	NSUInteger currentslot = [sheetState currentSlot] ;
	[sheetDelegate.textFieldDelegate clearTextAtIndex: currentslot] ;
	[sheetDatabase clearStringsAtIndex: currentslot] ;
}

- (void) clearAllFieldsInTableView: (UITableView *) tableview
{
	KCTextFieldCommand * command = [KCTextFieldCommand clearCommand] ;
	
	NSUInteger i, maxrownum = [PzSheetDatabase maxRowNum]  ;
	for(i=0 ; i<maxrownum ; i++){
		PzSheetCell * cell = [self searchSheetCellInTableView: tableview atIndex: i] ;
		if(cell){
			KCTextField * field = cell.expressionField ;
			[field executeCommand: command] ;
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
	if(nextslot == [PzSheetDatabase maxRowNum]){
		nextslot = 0 ;
	}
	
	/* Scroll to the destination slot */
	[self scrollTo: nextslot inTableView: tableview] ;
}

- (void) insertStringToExpressionField: (NSString *) str inTableView: (UITableView *) tableview
{
	KCTextFieldCommand * command = [KCTextFieldCommand insertTextCommand: str] ;
	NSString * result = [self executeTextFieldCommand: command atSlot: sheetState.currentSlot inTableView: tableview] ;
	
	NSUInteger currentslot = [sheetState currentSlot] ;
	[sheetDelegate.textFieldDelegate enterText: result atIndex: currentslot] ;
	[sheetDatabase setExpressionString: result atIndex: currentslot] ;
}

- (void) deleteSelectedStringInExpressionFieldInTableView: (UITableView *) tableview
{
	KCTextFieldCommand * command = [KCTextFieldCommand deleteSelectionCommand] ;
	NSString * result = [self executeTextFieldCommand: command atSlot: sheetState.currentSlot inTableView: tableview] ;
	
	NSUInteger currentslot = [sheetState currentSlot] ;
	[sheetDelegate.textFieldDelegate enterText: result atIndex: currentslot] ;
	[sheetDatabase setExpressionString: result atIndex: currentslot] ;
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

- (BOOL) isVisibleCell: (UITableViewCell *) target inTableView: (UITableView *) tableview
{
	NSArray * cells = [tableview visibleCells] ;
	for(UITableViewCell * cell in cells){
		if(cell == target){
			return YES ;
		}
	}
	return NO ;
}

- (NSString *) executeTextFieldCommand: (KCTextFieldCommand *) command atSlot: (NSUInteger) newslot inTableView: (UITableView *) tableview
{
	BOOL	didscrolled = NO ;
	PzSheetCell * newcell = [self searchSheetCellInTableView: tableview atIndex: newslot] ;
	if(newcell == nil || ![self isVisibleCell: newcell inTableView: tableview]){
		/* Scroll to the slot */
		NSIndexPath * nextpath = [NSIndexPath indexPathForRow: newslot inSection: 0] ;
		[tableview scrollToRowAtIndexPath: nextpath
				 atScrollPosition: UITableViewScrollPositionNone
					 animated: NO] ;
		newcell = [self searchSheetCellInTableView: tableview atIndex: newslot] ;
		assert(newcell != nil) ;
		didscrolled = YES ;
	}
	KCTextField * newfield = newcell.expressionField ;
	if(didscrolled || sheetState.currentSlot != newslot || ![newfield isFirstResponder]){
		/* become first responder */
		[newfield becomeFirstResponder] ;
		/* Update current slot */
		sheetState.currentSlot = newslot ;
	} else {
		[newfield executeCommand: command] ;
	}
	return newfield.text ;
}

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



