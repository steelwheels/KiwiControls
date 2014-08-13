/**
 * @file	PzTenKeyDataSource.m
 * @brief	Define PzTenKeyDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzTenKeyDataSource.h"


#define DO_DEBUG			0

struct PzTenKeyInfo {
	enum PzTenKeyCode	code ;
	const char *		label ;
} ;

#define S(T, S)	{ .code = PzTenKeyCode_ ## T, .label = (S) }

static const struct PzTenKeyInfo
s_tenkey_table[PzTenKeyMaxStateNum][PzTenKeyRowNum * PzTenKeyColmunNum] = {
 /* PzTenKeyDecState */
 {
  S(DecState, "Dec"),	S(HexState, "Hex"),	S(OpState, "Op"),	S(FuncState, "Func"),	S(Del, "⌫"),
  S(7, "7"),		S(8, "8"),		S(9, "9"),		S(LeftPar, "("),	S(RightPar, ")"),
  S(4, "4"),		S(5, "5"),		S(6, "6"),		S(Mul, "*"),		S(Div, "/"),
  S(1, "1"),		S(2, "2"),		S(3, "3"),		S(Add, "+"),		S(Sub, "-"),
  S(0, "0"),		S(Dot, "."),		S(Ret, "⏎"),		S(MoveLeft, "◀︎"),	S(MoveRight, "▶︎")
 },
 /* PzTenKeyHexState */
 {
  S(DecState, "Dec"),	S(HexState, "Hex"),	S(OpState, "Op"),	S(FuncState, "Func"),	S(Del, "⌫"),
  S(7, "7"),		S(8, "8"),		S(9, "9"),		S(E, "E"),		S(F, "F"),
  S(4, "4"),		S(5, "5"),		S(6, "6"),		S(C, "C"),		S(D, "D"),
  S(1, "1"),		S(2, "2"),		S(3, "3"),		S(A, "A"),		S(B, "B"),
  S(0, "0"),		S(0X, "0x"),		S(Ret, "⏎"),		S(MoveLeft, "◀︎"),	S(MoveRight, "▶︎")
 },
 /* PzTenKeyOpState */
 {
  S(DecState, "Dec"),	S(HexState, "Hex"),	S(OpState, "Op"),	S(FuncState, "Func"),	S(Del, "⌫"),
  S(7, "7"),		S(8, "8"),		S(9, "9"),		S(LeftPar, "("),	S(RightPar, ")"),
  S(4, "4"),		S(5, "5"),		S(6, "6"),		S(Mul, "*"),		S(Div, "/"),
  S(1, "1"),		S(2, "2"),		S(3, "3"),		S(Add, "+"),		S(Sub, "-"),
  S(0, "0"),		S(Dot, "."),		S(Ret, "⏎"),		S(MoveLeft, "◀︎"),	S(MoveRight, "▶︎")
 },
 /* PzTenKeyFuncState */
 {
  S(DecState, "Dec"),	S(HexState, "Hex"),	S(OpState, "Op"),	S(FuncState, "Func"),	S(Del, "⌫"),
  S(7, "7"),		S(8, "8"),		S(9, "9"),		S(LeftPar, "("),	S(RightPar, ")"),
  S(4, "4"),		S(5, "5"),		S(6, "6"),		S(Mul, "*"),		S(Div, "/"),
  S(1, "1"),		S(2, "2"),		S(3, "3"),		S(Add, "+"),		S(Sub, "-"),
  S(0, "0"),		S(Dot, "."),		S(Ret, "⏎"),		S(MoveLeft, "◀︎"),	S(MoveRight, "▶︎")
 }
} ;

static BOOL buttonInCell(UIView ** button, UIView ** background, UICollectionViewCell * cell) ;
static void updateButtonLabel(enum PzTenKeyState state, UIButton * button, UIView * background) ;
static UIColor * backgroundColor(const struct PzTenKeyInfo * info) ;

static inline const struct PzTenKeyInfo *
tenKeyInfo(enum PzTenKeyState state, NSInteger tag)
{
	return &(s_tenkey_table[state][tag]) ;
}

@implementation PzTenKeyDataSource

- (instancetype) init
{
	if((self = [super init]) != nil){
		if(DO_DEBUG){ NSLog(@"init\n") ; }
		tenKeyState = PzTenKeyDecState ;
	}
	return self ;
}

- (NSInteger) numberOfSectionsInCollectionView: (UICollectionView *) collectionView
{
	if(DO_DEBUG){ NSLog(@"numberOfSections") ; }
	return 1 ;
}

- (NSInteger) collectionView: (UICollectionView *) view numberOfItemsInSection: (NSInteger) section
{
	if(DO_DEBUG){ NSLog(@"numberOfItems\n") ; }
	((void) view) ; ((void) section) ;
	return PzTenKeyRowNum * PzTenKeyColmunNum ;
}

- (UICollectionViewCell *) collectionView:  (UICollectionView *) view cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if(DO_DEBUG){ NSLog(@"collectionView:cellForItemAtIndexPath\n") ; }
	
	static BOOL is1stcalling = true ;
	if(is1stcalling){
		UINib * nib = [UINib nibWithNibName: @"PzTenKeyCell" bundle:nil];
		[view registerNib: nib forCellWithReuseIdentifier: @"Key"] ;
		is1stcalling = false ;
	}
	
	/* Allocate new cell with button */
	UICollectionViewCell * newcell = [view dequeueReusableCellWithReuseIdentifier: @"Key" forIndexPath: indexPath] ;
	
	/* Setup button in cell */
	UIButton *	button ;
	UIView *	background ;
	if(buttonInCell(&button, &background, newcell)){
		button.tag = [indexPath row] ;
		[button addTarget: self action: @selector(clickEvent:event:) forControlEvents: UIControlEventTouchUpInside] ;
		updateButtonLabel(tenKeyState, button, background) ;
	} else {
		NSLog(@"Failed to get button") ;
	}

	// return the cell
	return newcell;
}

- (IBAction) clickEvent:(id) sender event:(id) event
{
	UIButton * button = (UIButton *) sender ;
	int tag = (int) button.tag ;
	NSLog(@"click event: %d\n", tag) ;
}

@end

static BOOL
buttonInCell(UIButton ** button, UIView ** background, UICollectionViewCell * cell)
{
	UIView * back ;
	if((back = [cell contentView]) != nil){
		NSArray * subviews = [back subviews] ;
		if([subviews count] == 1){
			UIView * subview = [subviews objectAtIndex: 0] ;
			if([subview isKindOfClass: [UIButton class]]){
				*button		= (UIButton *) subview ;
				*background	= back ;
				return true ;
			}
		}
	}
	return false ;
}

static void
updateButtonLabel(enum PzTenKeyState state, UIButton * button, UIView * background)
{
	NSInteger tag = button.tag ;
	const struct PzTenKeyInfo * info = tenKeyInfo(state, tag) ;
	
	/* Set label */
	NSString * label = [[NSString alloc] initWithUTF8String: info->label] ;
	[button setTitle: label forState: UIControlStateNormal] ;
	
	/* Set background */
	background.backgroundColor = backgroundColor(info) ;
}

static UIColor *
backgroundColor(const struct PzTenKeyInfo * info)
{
	UIColor * result ;
	switch(info->code & PzTenKeyMask_Mask){
		case PzTenKeyMask_State:	result = [UIColor darkGrayColor] ;	break ;
		case PzTenKeyMask_Normal:	result = [UIColor lightGrayColor] ;	break ;
		case PzTenKeyMask_Edit:		result = [UIColor orangeColor] ;	break ;
		case PzTenKeyMask_Operator:	result = [UIColor orangeColor] ;	break ;
		case PzTenKeyMask_Function:	result = [UIColor orangeColor] ;	break ;
		default:			result = [UIColor lightGrayColor] ;	break ;
	}
	return result ;
}
