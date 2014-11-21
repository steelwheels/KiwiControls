/**
 * @file	KCTextFieldCommand.h
 * @brief	Define KCTextFieldCommand class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <Foundation/Foundation.h>

typedef enum {
	KCTextFieldMoveLeftCursorCommand,
	KCTextFieldMoveRightCursorCommand,
	KCTextFieldInsertTextCommand,
	KCTextFieldDeleteSelectionCommand,
	KCTextFieldClearCommand
} KCTextFieldOpcode ;

@interface KCTextFieldCommand : NSObject
{
	KCTextFieldOpcode		opCode ;
	NSString *			parameterString ;
}

+ (KCTextFieldCommand *) moveLeftCursorCommand ;
+ (KCTextFieldCommand *) moveRightCursorCommand ;
+ (KCTextFieldCommand *) insertTextCommand: (NSString *) text ;
+ (KCTextFieldCommand *) deleteSelectionCommand ;
+ (KCTextFieldCommand *) clearCommand ;

- (instancetype) initWithOpcode: (KCTextFieldOpcode) code withParameter: (NSString *) str ;

- (KCTextFieldOpcode) opcode ;
- (NSString *) parameter ;

@end
