/**
 * @file	KCTextField.h
 * @brief	Define KCTextField class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCTextField.h"
#import "KCTextFieldCommand.h"

@interface KCTextField (Private)
- (void) moveCursorForward ;
- (void) moveCursorBackward ;
- (void) deleteBackwardText ;
- (void) clearText ;
@end

@implementation KCTextField

- (void) setDelegate:(id <KCTextFieldDelegate>)delegate
{
	[super setDelegate: delegate] ;
}

- (BOOL) resignFirstResponder
{
	if(self.delegate != nil){
		if([self.delegate respondsToSelector: @selector(isScrollingNow)]){
			id <KCTextFieldDelegate> adelegate = (id <KCTextFieldDelegate>) self.delegate ;
			if([adelegate isScrollingNow]){
				return NO ;
			}
		}
	}
	return [super resignFirstResponder] ;
}

- (void) executeCommandOnMainThread: (KCTextFieldCommand *) command
{
	switch([command opcode]){
		case KCTextFieldMoveLeftCursorCommand: {
			[self moveCursorBackward] ;
		} break ;
		case KCTextFieldMoveRightCursorCommand: {
			[self moveCursorForward] ;
		} break ;
		case KCTextFieldInsertTextCommand: {
			NSString * text = [command parameter] ;
			[self insertText: text] ;
		} break ;
		case KCTextFieldDeleteSelectionCommand: {
			[self deleteBackwardText] ;
		} break ;
		case KCTextFieldClearCommand: {
			[self clearText] ;
		} break ;
	}
}

- (void) executeCommand: (KCTextFieldCommand *) command
{	
	[self performSelectorOnMainThread: @selector(executeCommandOnMainThread:)
			       withObject: command
			    waitUntilDone: YES] ;
}

@end

@implementation KCTextField (Private)

- (void) moveCursorForward
{
	UITextRange * currentrange = self.selectedTextRange;
	if([currentrange.start isEqual: self.endOfDocument]){
		return;
	}
	
	/* Update text field view */
	UITextPosition * newpos = [self positionFromPosition: currentrange.start offset:+1];
	UITextRange *newrange;
	if([currentrange isEmpty]){
		newrange = [self textRangeFromPosition: newpos
					    toPosition: newpos];
	} else {
		newrange = [self textRangeFromPosition: newpos
					    toPosition: currentrange.end];
	}
	self.selectedTextRange = newrange;
}

- (void) moveCursorBackward
{
	UITextRange * currentrange = self.selectedTextRange;
	if([currentrange.start isEqual: self.beginningOfDocument]){
		return;
	}
	
	/* Update text field view */
	UITextPosition *newpos = [self positionFromPosition: currentrange.start offset:-1];
	UITextRange * newrange;
	if([currentrange isEmpty]){
		newrange = [self textRangeFromPosition: newpos
					    toPosition: newpos];
	} else {
		newrange = [self textRangeFromPosition: newpos
					    toPosition: currentrange.end];
	}
	self.selectedTextRange = newrange;
}

- (void) deleteBackwardText
{
	UITextRange * selrange = self.selectedTextRange ;
	if(selrange.empty){
		/* delete previous character */
		[self deleteBackward] ;
	} else {
		/* change the  */
		UITextPosition * pos = selrange.start ;
		UITextRange * newrange = [self textRangeFromPosition: pos toPosition: pos] ;
		[self setSelectedTextRange: newrange] ;
	}
}

- (void) clearText
{
	self.text = @"" ;
}

@end

