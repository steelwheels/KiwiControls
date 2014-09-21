/**
 * @file	PzSheetDataSource.m
 * @brief	Define PzSheetDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzSheetDataSource.h"
#import "PzSheetCell.h"

#define MAX_ROW_NUM	128
#define DO_DEBUG	0

static inline NSString *
resultKey(NSInteger keyid)
{
	return [[NSString alloc] initWithFormat: @"v%d", (int) keyid] ;
}

@interface PzSheetDataSource (PzSheetExpressionFieldDelegate)
@end

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

- (void) activateFirstResponder
{
	UITextField *	currentfield = [expressionTable objectAtIndex: currentSlot] ;
	[currentfield becomeFirstResponder] ;
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
	
	/* To suppress display keyboard, give dummy view
	 * See http://stackoverflow.com/questions/5615806/disable-uitextfield-keyboard
	 */
	UIView * dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	newcell.expressionField.inputView = dummyView; // Hide keyboard, but show blinking cursor

	/* Add text field */
	[expressionTable addObject: newcell.expressionField] ;
	if(indexPath.row == 0){
		[newcell.expressionField becomeFirstResponder] ;
	}
	
	/* Add delegate */
	[newcell.expressionField setDelegate: self] ;
	
	/* Add observer for result value */
	NSString * resultkey = resultKey(indexPath.row) ;
	[resultTable addObserver: newcell forKeyPath: resultkey options: NSKeyValueObservingOptionNew context: nil] ;
	
	// return the cell
	return newcell;
}

- (void) deleteSelectedStringInExpressionField
{
	UITextField *	currentfield = [expressionTable objectAtIndex: currentSlot] ;
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
}

- (void) clearExpressionField
{
	UITextField *	currentfield = [expressionTable objectAtIndex: currentSlot] ;
	currentfield.text = @"" ;
}

- (void) moveCursorForwardInExpressionField
{
	UITextField *	currentfield = [expressionTable objectAtIndex: currentSlot] ;
	UITextRange *	currentrange = currentfield.selectedTextRange;
	if([currentrange.start isEqual: currentfield.endOfDocument]){
		return;
	}
	
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

- (void) moveCursorBackwardInExpressionField
{
	UITextField *	currentfield = [expressionTable objectAtIndex: currentSlot] ;
	UITextRange *	currentrange = currentfield.selectedTextRange;
	if([currentrange.start isEqual: currentfield.beginningOfDocument]){
		return;
	}
	
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

- (void) selectNextExpressionField
{
	NSUInteger nextslot = currentSlot + 1 ;
	if(nextslot >= [expressionTable count]){
		nextslot = 0 ;
	}
	UITextField * nextfield = [expressionTable objectAtIndex: nextslot] ;
	[nextfield becomeFirstResponder] ;
	currentSlot = nextslot ;
}

- (void) insertStringToExpressionField: (NSString *) str
{
	//NSLog(@"%s : iSTEF %@ -> %u\n", __FILE__, str, (unsigned int) currentSlot) ;
	UITextField * textfield = [expressionTable objectAtIndex: currentSlot] ;
	[textfield insertText: str] ;
}

- (void) setResultValue: (PzSheetValue *) value forSlot: (NSInteger) index
{
	NSString * resultkey = resultKey(index) ;
	[resultTable setValue: value forKey: resultkey] ;
}

@end

@implementation PzSheetDataSource (PzSheetExpressionFieldDelegate)

- (BOOL) textFieldShouldBeginEditing: (UITextField *) textField
{
	NSUInteger i ;
	NSUInteger maxnum = [expressionTable count] ;
	for(i=0 ; i<maxnum ; i++){
		UITextField * expfield = [expressionTable objectAtIndex: i] ;
		if(expfield == textField){
			currentSlot = i ;
			return true ;
		}
	}
	return false ;
}

@end


