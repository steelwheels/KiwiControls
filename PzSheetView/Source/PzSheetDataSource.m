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

static inline void
setSlotNumToLabel(UILabel * label, NSUInteger tag)
{
	label.tag = 0x10000000 | tag ;
}

static inline NSUInteger
slotNumOfLabel(UILabel * label)
{
	NSUInteger tag = label.tag ;
	return tag & 0x0fffffff ;
}

static inline void
setSlotNumToTextField(UITextField * field, NSUInteger tag)
{
	field.tag = 0x20000000 | tag ;
}

static inline NSUInteger
slotNumOfTextField(UITextField * field)
{
	NSUInteger tag = field.tag ;
	return tag & 0x0fffffff ;
}

static inline PzSheetCell *
searchSheetCellInTableView(UITableView * tableview, NSInteger index)
{
	NSIndexPath * path = [NSIndexPath indexPathForRow: index inSection: 0] ;
	PzSheetCell * cell = (PzSheetCell *) [tableview cellForRowAtIndexPath: path] ;
	return cell ;
}

static inline void
scrollToCurrentSlot(UITableView * tableview, NSInteger slot)
{
	/* Scroll to the destination slot */
	NSIndexPath * targetpath = [NSIndexPath indexPathForRow: slot inSection: 0] ;
	[tableview scrollToRowAtIndexPath: targetpath
			 atScrollPosition: UITableViewScrollPositionNone
				 animated: YES] ;
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
	setSlotNumToTextField(newcell.expressionField, row) ;
	newcell.expressionField.text = [sheetDatabase expressionStringAtIndex: row] ;
	[newcell.expressionField setDelegate: self] ;
	
	/* Setup label */
	setSlotNumToLabel(newcell.touchableLabel, row) ;
	newcell.touchableLabel.text = [sheetDatabase labelStringAtIndex: row] ;
	newcell.touchableLabel.touchableLabelDelegate = self ;
	
	// return the cell
	return newcell;
}

- (void) moveCursorForwardInExpressionFieldInTableView: (UITableView *) tableview
{
	scrollToCurrentSlot(tableview, currentSlot) ;
	
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
	scrollToCurrentSlot(tableview, currentSlot) ;
	
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
	scrollToCurrentSlot(tableview, currentSlot) ;
	
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
	/* Make the slot as the 1st responder */
	NSIndexPath * orgpath = [NSIndexPath indexPathForRow: currentSlot inSection: 0] ;
	PzSheetCell * orgcell = (PzSheetCell *) [tableview cellForRowAtIndexPath: orgpath] ;
	if(orgcell == nil){
		NSLog(@"%s [Error] No org cell", __func__) ;
	}
	if(orgcell){
		[orgcell.expressionField resignFirstResponder] ;
	}

	NSUInteger nextslot = currentSlot + 1 ;
	if(nextslot == MAX_ROW_NUM){
		nextslot = 0 ;
	}
	scrollToCurrentSlot(tableview, nextslot) ;
	
	NSIndexPath * nextpath = [NSIndexPath indexPathForRow: nextslot inSection: 0] ;
	PzSheetCell * nextcell = (PzSheetCell *) [tableview cellForRowAtIndexPath: nextpath] ;
	if(nextcell == nil){
		NSLog(@"%s [Error] No next cell", __func__) ;
	}
	[nextcell.expressionField becomeFirstResponder] ;
	
	currentSlot = nextslot ;
}

- (void) insertStringToExpressionField: (NSString *) str inTableView: (UITableView *) tableview
{
	scrollToCurrentSlot(tableview, currentSlot) ;
	
	PzSheetCell * currentcell = searchSheetCellInTableView(tableview, currentSlot) ;
	UITextField * currentfield = currentcell.expressionField ;
	[currentfield insertText: str] ;
	
	NSString * currenttext = currentfield.text ;
	[sheetViewTextFieldDelegate enterText: currenttext atIndex: currentSlot] ;
	[sheetDatabase setExpressionString: currenttext atIndex: currentSlot] ;
}

- (void) deleteSelectedStringInExpressionFieldInTableView: (UITableView *) tableview
{
	scrollToCurrentSlot(tableview, currentSlot) ;
	
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
	NSString * currenttext = currentfield.text ;
	[sheetViewTextFieldDelegate enterText: currenttext atIndex: currentSlot] ;
	[sheetDatabase setExpressionString: currenttext atIndex: currentSlot] ;
}

- (void)label: (KCTouchableLabel *) label touchesBegan: (NSSet*) touches withEvent: (UIEvent*) event
{
	((void) touches) ; ((void) event) ;
	if(sheetViewTouchableLabelDelegate){
		CGSize labsize = label.bounds.size ;
		CGPoint labelcenter = CGPointMake(labsize.width/2, labsize.height/2) ;
		NSUInteger labeltag = slotNumOfLabel(label) ;
		[sheetViewTouchableLabelDelegate touchLabelAtIndex: labeltag atAbsolutePoint: labelcenter] ;
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
	currentSlot = slotNumOfTextField(textField) ;
	NSLog(@"text edit : %u", (unsigned int) currentSlot) ;
	return YES ;
}

- (BOOL) textField: (UITextField *) textfield shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
	/* Get modified string */
	NSMutableString *newstr = [textfield.text mutableCopy];
	[newstr replaceCharactersInRange:range withString:string];
	if(sheetViewTextFieldDelegate){
		[sheetViewTextFieldDelegate enterText: newstr atIndex: currentSlot] ;
		[sheetDatabase setExpressionString: newstr atIndex: currentSlot] ;
	} else {
		NSLog(@"Current string : %@ at %u\n", newstr, (unsigned int) currentSlot) ;
	}
	
	return YES ;
}

@end


