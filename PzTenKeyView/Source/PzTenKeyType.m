/**
 * @file	PzTenKeyType.m
 * @brief	Define data types
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzTenKeyType.h"

NSString *
PzTenKeyTypeToString(enum PzTenKeyCode code)
{
#	define CASE(OP, STR) \
	case OP: result = STR ;	break ;
	
	NSString *	result = nil ;
	switch(code){
		case PzTenKeyCode_DecState:
		case PzTenKeyCode_HexState:
		case PzTenKeyCode_OpState:
		case PzTenKeyCode_Ret:
		case PzTenKeyCode_Del:
		case PzTenKeyCode_MoveLeft:
		case PzTenKeyCode_MoveRight:
		case PzTenKeyCode_FuncSel:
		case PzTenKeyCode_Clear:
		case PzTenKeyCode_AllClear:
		case PzTenKeyCode_Nop: {
			/* Do nothing */
		} break ;
		case PzTenKeyCode_0: {
			result = @"0" ;
		} break ;
		case PzTenKeyCode_1: {
			result = @"1" ;
		} break ;
		case PzTenKeyCode_2: {
			result = @"2" ;
		} break ;
		case PzTenKeyCode_3: {
			result = @"3" ;
		} break ;
		case PzTenKeyCode_4: {
			result = @"4" ;
		} break ;
		case PzTenKeyCode_5: {
			result = @"5" ;
		} break ;
		case PzTenKeyCode_6: {
			result = @"6" ;
		} break ;
		case PzTenKeyCode_7: {
			result = @"7" ;
		} break ;
		case PzTenKeyCode_8: {
			result = @"8" ;
		} break ;
		case PzTenKeyCode_9: {
			result = @"9" ;
		} break ;
		case PzTenKeyCode_A: {
			result = @"a" ;
		} break ;
		case PzTenKeyCode_B: {
			result = @"b" ;
		} break ;
		case PzTenKeyCode_C: {
			result = @"c" ;
		} break ;
		case PzTenKeyCode_D: {
			result = @"d" ;
		} break ;
		case PzTenKeyCode_E: {
			result = @"e" ;
		} break ;
		case PzTenKeyCode_F: {
			result = @"f" ;
		} break ;
		case PzTenKeyCode_0X: {
			result = @"0x" ;
		} break ;
		case PzTenKeyCode_Dot: {
			result = @"." ;
		} break ;

		CASE(PzTenKeyCode_Add,		@"+")
		CASE(PzTenKeyCode_Sub,		@"-")
		CASE(PzTenKeyCode_Mul,		@"*")
		CASE(PzTenKeyCode_Div,		@"/")
		CASE(PzTenKeyCode_Mod,		@"%")
			
		CASE(PzTenKeyCode_BitAnd,	@"&")
		CASE(PzTenKeyCode_BitOr,	@"|")
		CASE(PzTenKeyCode_BitXor,	@"^")
		CASE(PzTenKeyCode_BitNot,	@"~")
		CASE(PzTenKeyCode_LogAnd,	@"&&")
		CASE(PzTenKeyCode_LogOr,	@"||")
		CASE(PzTenKeyCode_LogNot,	@"!")
			
		CASE(PzTenKeyCode_Equal,	@"==")
		CASE(PzTenKeyCode_NotEqu,	@"!=")
		CASE(PzTenKeyCode_LessThan,	@"<")
		CASE(PzTenKeyCode_GreaterThan,	@">")
		CASE(PzTenKeyCode_LessEqu,	@"<=")
		CASE(PzTenKeyCode_GreateEqu,	@">=")
			
		CASE(PzTenKeyCode_LeftPar,	@"(")
		CASE(PzTenKeyCode_RightPar,	@")")
		CASE(PzTenKeyCode_Comma,	@",")
	}
#	undef CASE
	return result ;
}
