/**
 * @file	PzSheetDelegate.m
 * @brief	Define PzSheetDatabase class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzSheetDelegate.h"
#import "PzSheetState.h"
#import "PzSheetDatabase.h"

@implementation PzSheetDelegate

@synthesize dataSource ;
@synthesize touchLabelDelegate ;
@synthesize textFieldDelegate ;

- (instancetype) initWithSheetState: (PzSheetState *) state withDatabase: (PzSheetDatabase *) database
{
	if((self = [super init]) != nil){
		sheetState = state ;
		sheetDatabase = database ;		
		self.dataSource = nil ;
		self.touchLabelDelegate = nil ;
		self.textFieldDelegate = nil ;
	}
	return self ;
}

- (void) label: (KCTouchableLabel *) label touchesBegan: (NSSet*) touches withEvent: (UIEvent*) event
{
	((void) touches) ; ((void) event) ;
	if(self.touchLabelDelegate){
		CGSize labsize = label.bounds.size ;
		CGPoint labelcenter = CGPointMake(labsize.width/2, labsize.height/2) ;
		NSUInteger labeltag = [PzSheetState slotNumOfLabel: label] ;
		[self.touchLabelDelegate touchLabelAtIndex: labeltag atAbsolutePoint: labelcenter] ;
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

- (void) scrollViewWillBeginDragging: (UIScrollView *) scrollView
{
	((void) scrollView) ;
	sheetState.isScrolling = YES ;
}

- (void) scrollViewDidEndDragging: (UIScrollView *) scrollView willDecelerate:(BOOL)decelerate
{
	((void) scrollView) ;
	if(!decelerate){
		sheetState.isScrolling = NO ;
	}
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	((void) scrollView) ;
	sheetState.isScrolling = NO ;
}

- (BOOL) isScrollingNow
{
	return sheetState.isScrolling ;
}

- (BOOL) textFieldShouldBeginEditing: (UITextField *) textfield
{
	if(sheetState.isScrolling){
		return NO ;
	} else {
		sheetState.currentSlot = [PzSheetState slotNumOfTextField: textfield] ;
		//NSLog(@"%s: %u", __func__, (unsigned int) sheetState.currentSlot) ;
		return YES ;
	}
}

- (BOOL) textField: (UITextField *) textfield shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
	/* Get modified string */
	NSMutableString *newstr = [textfield.text mutableCopy];
	[newstr replaceCharactersInRange:range withString:string];
	NSUInteger currentslot = sheetState.currentSlot = [PzSheetState slotNumOfTextField: textfield] ;
	//NSLog(@"%s: %u", __func__, (unsigned int) currentslot) ;
	if(self.textFieldDelegate){
		[self.textFieldDelegate enterText: newstr atIndex: currentslot] ;
		[sheetDatabase setExpressionString: newstr atIndex: currentslot] ;
	} else {
		NSLog(@"Current string : %@ at %u\n", newstr, (unsigned int) currentslot) ;
	}
	
	return YES ;
}

@end


