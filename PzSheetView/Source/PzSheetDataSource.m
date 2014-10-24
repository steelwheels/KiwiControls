/**
 * @file	PzSheetDataSource.m
 * @brief	Define PzSheetDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzSheetDataSource.h"
#import "PzSheetCell.h"
#import <KiwiControl/KiwiControl.h>

#define MAX_ROW_NUM	128
#define DO_DEBUG	0

static inline NSInteger
indexToTag(NSInteger index)
{
	return index + 1 ;
}

static inline NSInteger
tagToIndex(NSInteger tag)
{
	return tag - 1 ;
}

static inline PzSheetCell *
searchSheetCellInTableView(UITableView * table, NSInteger index)
{
	NSIndexPath * path = [NSIndexPath indexPathForRow: index inSection: 0] ;
	return (PzSheetCell *) [table cellForRowAtIndexPath: path] ;
}

@interface PzSheetDataSource (PzSheetExpressionFieldDelegate)
@end

@implementation PzSheetDataSource

+ (NSUInteger) maxRowNum
{
	return MAX_ROW_NUM ;
}

- (instancetype) init
{
	if((self = [super init]) != nil){
		didNibPrepared = NO ;
		sheetViewTextFieldDelegate = nil ;
		sheetDatabase = [[PzSheetDatabase alloc] initWithCountOfSheetData: MAX_ROW_NUM] ;
		currentSlot = 0 ;
	}
	return self ;
}

- (void) setTextFieldDelegate: (id <PzSheetViewTextFieldDelegate>) delegate
{
	sheetViewTextFieldDelegate = delegate ;
}

- (void) setTouchableLabelDelegate: (id <PzSheetViewTouchLabelDelegate>) delegate
{
	sheetViewTouchableLabelDelegate = delegate ;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
	((void) tableView) ;
	return 1 ;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
	((void) tableView) ; ((void) section) ;
	return MAX_ROW_NUM ;
}

- (void) scrollToRow: (NSInteger) slot inTableView: (UITableView *) tableview
{
	NSIndexPath * targetpath = [NSIndexPath indexPathForRow: slot inSection: 0] ;
	[tableview scrollToRowAtIndexPath: targetpath
			 atScrollPosition: UITableViewScrollPositionNone
				 animated: YES] ;
}

- (void) activateResponderAtSlot: (NSUInteger) newslot inTableView: (UITableView *) tableview
{
	if(currentSlot == newslot){
		return ;
	}
	/* Get current slot */
	PzSheetCell * nextcell = searchSheetCellInTableView(tableview, newslot) ;
	if(nextcell == nil){
		return ;
	}
	/* Check current responder can be switched to new */
	PzSheetCell * curcell  = searchSheetCellInTableView(tableview, currentSlot) ;
	if(curcell){
		if(![curcell.expressionField resignFirstResponder]){
			return ;
		}
	}
	/* scroll to current slot */
	[self scrollToRow: newslot inTableView: tableview] ;
	/* activate responder */	
	[nextcell.expressionField becomeFirstResponder] ;
	currentSlot = newslot ;
}

- (void) activateResponderAtCurrentSlotInTableView: (UITableView *) tableview
{
	PzSheetCell *	currentcell = searchSheetCellInTableView(tableview, currentSlot) ;
	UITextField *	currentfield = currentcell.expressionField ;
	[currentfield becomeFirstResponder] ;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(DO_DEBUG){ NSLog(@"collectionView:cellForItemAtIndexPath\n") ; }
	
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
	newcell.expressionField.tag = indexToTag(row) ;
	newcell.expressionField.text = [sheetDatabase expressionStringAtIndex: row] ;
	[newcell.expressionField setDelegate: self] ;
	
	/* Setup label */
	newcell.touchableLabel.tag = indexToTag(row) ;
	newcell.touchableLabel.text = [sheetDatabase labelStringAtIndex: row] ;
	newcell.touchableLabel.touchableLabelDelegate = self ;
	
	// return the cell
	return newcell;
}

- (void) moveCursorForwardInExpressionFieldInTableView: (UITableView *) tableview
{
	PzSheetCell *	currentcell = searchSheetCellInTableView(tableview, currentSlot) ;
	UITextField *	currentfield = currentcell.expressionField ;
	UITextRange *	currentrange = currentfield.selectedTextRange;
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
	PzSheetCell *	currentcell = searchSheetCellInTableView(tableview, currentSlot) ;
	UITextField *	currentfield = currentcell.expressionField ;
	UITextRange *	currentrange = currentfield.selectedTextRange;
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
	[self scrollToRow: currentSlot inTableView: tableview] ;
	
	PzSheetCell *	currentcell = searchSheetCellInTableView(tableview, currentSlot) ;
	UITextField *	currentfield = currentcell.expressionField ;
	currentfield.text = @"" ;
	[sheetViewTextFieldDelegate enterText: currentfield.text atIndex: currentSlot] ;
	[sheetDatabase clearStringsAtIndex: currentSlot] ;
}

- (void) clearAllFieldsInTableView: (UITableView *) tableview
{
	NSUInteger i ;
	for(i=0 ; i<MAX_ROW_NUM ; i++){
		PzSheetCell * cell = searchSheetCellInTableView(tableview, i) ;
		if(cell){
			cell.expressionField.text = @"" ;
			[sheetViewTextFieldDelegate enterText: cell.expressionField.text atIndex: i] ;
		}
		[sheetDatabase clearStringsAtIndex: i] ;
	}
}

- (void) selectNextExpressionFieldInTableView: (UITableView *) tableview
{
	[self scrollToRow: currentSlot inTableView: tableview] ;
	NSUInteger nextslot = currentSlot + 1 ;
	if(nextslot == MAX_ROW_NUM){
		nextslot = 0 ;
	}
	[self activateResponderAtSlot: nextslot inTableView: tableview] ;
}

- (void) insertStringToExpressionField: (NSString *) str inTableView: (UITableView *) tableview
{
	[self scrollToRow: currentSlot inTableView: tableview] ;
	
	PzSheetCell * currentcell = searchSheetCellInTableView(tableview, currentSlot) ;
	UITextField * currentfield = currentcell.expressionField ;
	[currentfield insertText: str] ;
	[sheetViewTextFieldDelegate enterText: currentfield.text atIndex: currentSlot] ;
	[sheetDatabase setExpressionString: currentfield.text atIndex: currentSlot] ;
}

- (void) deleteSelectedStringInExpressionFieldInTableView: (UITableView *) tableview
{
	[self scrollToRow: currentSlot inTableView: tableview] ;
	
	PzSheetCell *	currentcell = searchSheetCellInTableView(tableview, currentSlot) ;
	UITextField *	currentfield = currentcell.expressionField ;
	UITextRange *	selrange = currentfield.selectedTextRange ;
	if(selrange.empty){
		/* delete previous character */
		[currentfield deleteBackward] ;
	} else {
		/* change the  */
		UITextPosition * pos = selrange.start ;
		UITextRange * newrange = [currentfield textRangeFromPosition: pos toPosition: pos] ;
		[currentfield setSelectedTextRange: newrange] ;
	}
	[sheetViewTextFieldDelegate enterText: currentfield.text atIndex: currentSlot] ;
	[sheetDatabase setExpressionString: currentfield.text atIndex: currentSlot] ;
}

- (void)label: (KCTouchableLabel *) label touchesBegan: (NSSet*) touches withEvent: (UIEvent*) event
{
	((void) touches) ; ((void) event) ;
	if(sheetViewTouchableLabelDelegate){
		CGSize labsize = label.bounds.size ;
		CGPoint labelcenter = CGPointMake(labsize.width/2, labsize.height/2) ;
		[sheetViewTouchableLabelDelegate touchLabelAtIndex: tagToIndex(label.tag) atAbsolutePoint: labelcenter] ;
	} else {
		NSLog(@"Label touched") ;
	}
}

- (void) label: (KCTouchableLabel *) label touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
	/* Do nothing */
	((void) label) ; ((void) touches) ; ((void) event) ;
}

- (void) label: (KCTouchableLabel *) label touchesCancelled: (NSSet *) touches withEvent: (UIEvent *) event
{
	/* Do nothing */
	((void) label) ; ((void) touches) ; ((void) event) ;
}

- (void) setLabelText: (NSString *) text forSlot: (NSInteger) index inTableView: (UITableView *) tableview
{	
	PzSheetCell *	currentcell = searchSheetCellInTableView(tableview, index) ;
	if(currentcell){
		[sheetDatabase setLabelString: text atIndex: index] ;
		UILabel * label = currentcell.touchableLabel ;
		[label performSelectorOnMainThread:@selector(setText:)
					withObject:text
					waitUntilDone:NO];
		
	}
}

@end

@implementation PzSheetDataSource (PzSheetExpressionFieldDelegate)

- (BOOL) textFieldShouldBeginEditing: (UITextField *) textField
{
	currentSlot = tagToIndex(textField.tag) ;
	return YES ;
}

- (BOOL)textField: (UITextField *) textfield shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
	/* Get modified string */
	NSMutableString *newstr = [textfield.text mutableCopy];
	[newstr replaceCharactersInRange:range withString:string];
	if(sheetViewTextFieldDelegate){
		[sheetViewTextFieldDelegate enterText: newstr atIndex: currentSlot] ;
	} else {
		NSLog(@"Current string : %@ at %u\n", newstr, (unsigned int) currentSlot) ;
	}
	
	return YES ;
}

@end


