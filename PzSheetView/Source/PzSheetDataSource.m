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

@interface PzSheetElement : NSObject
@property (strong, nonatomic) PzSheetCell *	cell ;
- (instancetype) init ;
@end

@implementation PzSheetElement
@synthesize cell ;
- (instancetype) init
{
	if((self = [super init]) != nil){
		self.cell = nil ;
	}
	return self ;
}
@end

static inline PzSheetCell *
getSheetCell(NSArray * array, NSUInteger index)
{
	PzSheetElement * elm = [array objectAtIndex: index] ;
	if(elm){
		return elm.cell ;
	} else {
		return nil ;
	}
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
		cellArray = [[NSMutableArray alloc] initWithCapacity: 32] ;
		
		NSUInteger i ;
		for(i=0 ; i<MAX_ROW_NUM ; i++){
			PzSheetElement * newelm = [[PzSheetElement alloc] init] ;
			[cellArray addObject: newelm] ;
		}
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
	((void) section) ;
	return MAX_ROW_NUM ;
}

- (void) activateFirstResponder
{
	PzSheetCell * cell = getSheetCell(cellArray, currentSlot) ;
	if(cell){
		UITextField * currentfield = cell.expressionField ;
		[currentfield becomeFirstResponder] ;
	}
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
	
	/* Allocate new cell with button */
	NSInteger row = indexPath.row ;
	PzSheetElement * element = [cellArray objectAtIndex: row] ;
	PzSheetCell * newcell = element.cell ;
	if((newcell = getSheetCell(cellArray, row)) == nil){
		newcell = [tableView dequeueReusableCellWithIdentifier: @"Key"];
		element.cell = newcell ;
	}
	
	/* To suppress display keyboard, give dummy view
	 * See http://stackoverflow.com/questions/5615806/disable-uitextfield-keyboard
	 */
	UIView * dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	newcell.expressionField.inputView = dummyView; // Hide keyboard, but show blinking cursor

	/* Setup text field */
	if(row == 0){
		[newcell.expressionField becomeFirstResponder] ;
	}
	newcell.expressionField.tag = row ;
	[newcell.expressionField setDelegate: self] ;
	
	/* Setup label */
	newcell.touchableLabel.tag = row ;
	newcell.touchableLabel.touchableLabelDelegate = self ;
	
	// return the cell
	return newcell;
}

- (void) moveCursorForwardInExpressionField
{
	PzSheetCell *	currentcell = getSheetCell(cellArray, currentSlot) ;
	UITextField *	currentfield = currentcell.expressionField ;
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
	PzSheetCell *	currentcell = getSheetCell(cellArray, currentSlot) ;
	UITextField *	currentfield = currentcell.expressionField ;
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
	if(nextslot >= [cellArray count]){
		nextslot = 0 ;
	}
	PzSheetCell * nextcell = getSheetCell(cellArray, nextslot) ;
	UITextField * nextfield = nextcell.expressionField ;
	[nextfield becomeFirstResponder] ;
	currentSlot = nextslot ;
}

- (void) insertStringToExpressionField: (NSString *) str
{
	PzSheetCell * currentcell = getSheetCell(cellArray, currentSlot) ;
	UITextField * currentfield = currentcell.expressionField ;
	[currentfield insertText: str] ;
	[sheetViewTextFieldDelegate enterText: currentfield.text atIndex: currentSlot] ;
}

- (void) deleteSelectedStringInExpressionField
{
	PzSheetCell *	currentcell = getSheetCell(cellArray, currentSlot) ;
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
}

- (void) clearExpressionField
{
	PzSheetCell *	currentcell = getSheetCell(cellArray, currentSlot) ;
	UITextField *	currentfield = currentcell.expressionField ;
	currentfield.text = @"" ;
	[sheetViewTextFieldDelegate enterText: currentfield.text atIndex: currentSlot] ;
}

- (void)label: (KCTouchableLabel *) label touchesBegan: (NSSet*) touches withEvent: (UIEvent*) event
{
	if(sheetViewTouchableLabelDelegate){
		CGSize labsize = label.bounds.size ;
		CGPoint labelcenter = CGPointMake(labsize.width/2, labsize.height/2) ;
		[sheetViewTouchableLabelDelegate touchLabelAtIndex: label.tag atAbsolutePoint: labelcenter] ;
	} else {
		NSLog(@"Label touched") ;
	}
}

- (void)label: (KCTouchableLabel *) label touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
	/* Do nothing */
}

- (void)label: (KCTouchableLabel *) label touchesCancelled: (NSSet *) touches withEvent: (UIEvent *) event
{
	/* Do nothing */
}

- (void) setLabelText: (NSString *) text forSlot: (NSInteger) index
{
	PzSheetCell *	currentcell = getSheetCell(cellArray, index) ;
	if(currentcell){
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
	currentSlot = textField.tag ;
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


