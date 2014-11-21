/**
 * @file	KCTextFieldCommand.m
 * @brief	Define KCTextFieldCommand class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCTextFieldCommand.h"

@implementation KCTextFieldCommand

+ (KCTextFieldCommand *) moveLeftCursorCommand
{
	return [[KCTextFieldCommand alloc] initWithOpcode: KCTextFieldMoveLeftCursorCommand
					    withParameter: nil] ;
}

+ (KCTextFieldCommand *) moveRightCursorCommand
{
	return [[KCTextFieldCommand alloc] initWithOpcode: KCTextFieldMoveRightCursorCommand
					    withParameter: nil] ;
}

+ (KCTextFieldCommand *) insertTextCommand: (NSString *) text
{
	return [[KCTextFieldCommand alloc] initWithOpcode: KCTextFieldInsertTextCommand
					    withParameter: text] ;
}

+ (KCTextFieldCommand *) deleteSelectionCommand
{
	return [[KCTextFieldCommand alloc] initWithOpcode: KCTextFieldDeleteSelectionCommand
					    withParameter: nil] ;
}

+ (KCTextFieldCommand *) clearCommand
{
	return [[KCTextFieldCommand alloc] initWithOpcode: KCTextFieldClearCommand
					    withParameter: nil] ;
}

- (instancetype) initWithOpcode: (KCTextFieldOpcode) code withParameter: (NSString *) str
{
	if((self = [super init]) != nil){
		opCode = code ;
		parameterString = str ;
	}
	return self ;
}

- (KCTextFieldOpcode) opcode
{
	return opCode ;
}

- (NSString *) parameter
{
	return parameterString ;
}

@end
