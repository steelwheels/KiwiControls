/**
 * @file	PzTenKeyCode.h
 * @brief	Define key code
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

enum PzTenKeyState {
	PzTenKeyDecState,
	PzTenKeyHexState,
	PzTenKeyOpState,
	PzTenKeyFuncState
} ;

#define PzTenKeyMaxStateNum		4

#define PzTenKeyMask_State	0x00010000
#define	PzTenKeyMask_Normal	0x00020000
#define PzTenKeyMask_Edit	0x00030000
#define	PzTenKeyMask_Operator	0x00040000
#define	PzTenKeyMask_Function	0x00050000

enum PzTenKeyCode {
	PzTenKeyCode_DecState		= PzTenKeyMask_State	| 0x0000,
	PzTenKeyCode_HexState		= PzTenKeyMask_State	| 0x0001,
	PzTenKeyCode_OpState		= PzTenKeyMask_State	| 0x0002,
	PzTenKeyCode_FuncState		= PzTenKeyMask_State	| 0x0003,
	
	PzTenKeyCode_0			= PzTenKeyMask_Normal	| 0x0000,
	PzTenKeyCode_1			= PzTenKeyMask_Normal	| 0x0001,
	PzTenKeyCode_2			= PzTenKeyMask_Normal	| 0x0002,
	PzTenKeyCode_3			= PzTenKeyMask_Normal	| 0x0003,
	PzTenKeyCode_4			= PzTenKeyMask_Normal	| 0x0004,
	PzTenKeyCode_5			= PzTenKeyMask_Normal	| 0x0005,
	PzTenKeyCode_6			= PzTenKeyMask_Normal	| 0x0006,
	PzTenKeyCode_7			= PzTenKeyMask_Normal	| 0x0007,
	PzTenKeyCode_8			= PzTenKeyMask_Normal	| 0x0008,
	PzTenKeyCode_9			= PzTenKeyMask_Normal	| 0x0009,
	PzTenKeyCode_A			= PzTenKeyMask_Normal	| 0x000A,
	PzTenKeyCode_B			= PzTenKeyMask_Normal	| 0x000B,
	PzTenKeyCode_C			= PzTenKeyMask_Normal	| 0x000C,
	PzTenKeyCode_D			= PzTenKeyMask_Normal	| 0x000D,
	PzTenKeyCode_E			= PzTenKeyMask_Normal	| 0x000E,
	PzTenKeyCode_F			= PzTenKeyMask_Normal	| 0x000F,
	PzTenKeyCode_0X			= PzTenKeyMask_Normal	| 0x0010,
	PzTenKeyCode_Dot		= PzTenKeyMask_Normal	| 0x0011,
	
	PzTenKeyCode_Add		= PzTenKeyMask_Operator	| 0x0000,
	PzTenKeyCode_Sub		= PzTenKeyMask_Operator	| 0x0001,
	PzTenKeyCode_Mul		= PzTenKeyMask_Operator	| 0x0002,
	PzTenKeyCode_Div		= PzTenKeyMask_Operator	| 0x0003,
	PzTenKeyCode_Mod		= PzTenKeyMask_Operator	| 0x0004,
	PzTenKeyCode_LeftPar		= PzTenKeyMask_Operator	| 0x0005,
	PzTenKeyCode_RightPar		= PzTenKeyMask_Operator	| 0x0006,
	
	PzTenKeyCode_Ret		= PzTenKeyMask_Edit	| 0x0000,
	PzTenKeyCode_Del		= PzTenKeyMask_Edit	| 0x0001,
	PzTenKeyCode_MoveLeft		= PzTenKeyMask_Edit	| 0x0002,
	PzTenKeyCode_MoveRight		= PzTenKeyMask_Edit	| 0x0003,
} ;

