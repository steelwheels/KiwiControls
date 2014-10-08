/**
 * @file	PzTenKeyDataSource.m
 * @brief	Define PzTenKeyDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzTenKeyDataSource.h"
#import <KiwiControl/KiwiControl.h>

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
  S(DecState, "Dec"),	S(HexState, "Hex"),	S(OpState, "Op"),	S(FuncSel, "Func"),	S(Del, "⌫"),
  S(7, "7"),		S(8, "8"),		S(9, "9"),		S(LeftPar, "("),	S(RightPar, ")"),
  S(4, "4"),		S(5, "5"),		S(6, "6"),		S(Mul, "*"),		S(Div, "/"),
  S(1, "1"),		S(2, "2"),		S(3, "3"),		S(Add, "+"),		S(Sub, "-"),
  S(0, "0"),		S(Dot, "."),		S(Ret, "⏎"),		S(MoveLeft, "◀︎"),	S(MoveRight, "▶︎")
 },
 /* PzTenKeyHexState */
 {
  S(DecState, "Dec"),	S(HexState, "Hex"),	S(OpState, "Op"),	S(FuncSel, "Func"),	S(Del, "⌫"),
  S(7, "7"),		S(8, "8"),		S(9, "9"),		S(E, "E"),		S(F, "F"),
  S(4, "4"),		S(5, "5"),		S(6, "6"),		S(C, "C"),		S(D, "D"),
  S(1, "1"),		S(2, "2"),		S(3, "3"),		S(A, "A"),		S(B, "B"),
  S(0, "0"),		S(0X, "0x"),		S(Ret, "⏎"),		S(MoveLeft, "◀︎"),	S(MoveRight, "▶︎")
 },
 /* PzTenKeyOpState */
 {
  S(DecState, "Dec"),	S(HexState, "Hex"),	S(OpState, "Op"),	S(FuncSel, "Func"),	S(Del, "⌫"),
  S(LogNot, "!"),	S(BitNot, "~"),		S(BitXor, "^"),		S(AllClear, "AC"),	S(Clear, "C"),
  S(LogAnd, "&&"),	S(LogOr, "||"),		S(BitXor, "^"),		S(BitAnd, "&"),		S(BitOr, "|"),
  S(LessThan, "<"),	S(LessEqu, "<="),	S(Equal, "=="),		S(GreateEqu, "<="),	S(GreaterThan, "<"),
  S(NotEqu, "!="),	S(Comma, ","),		S(Ret, "⏎"),		S(MoveLeft, "◀︎"),	S(MoveRight, "▶︎")
 }
} ;

static BOOL buttonInCell(UIView ** button, UIView ** background, UICollectionViewCell * cell) ;
static void updateButtonLabel(enum PzTenKeyState state, UIButton * button, UIView * background) ;

static inline const struct PzTenKeyInfo *
tenKeyInfo(enum PzTenKeyState state, NSInteger tag)
{
	return &(s_tenkey_table[state][tag]) ;
}

@implementation PzTenKeyDataSource

- (instancetype) initWithDelegate: (id <PzTenKeyClicking>) delegate ;
{
	if((self = [super init]) != nil){
		didNibPrepared = NO ;
		if(DO_DEBUG){ NSLog(@"init\n") ; }
		clickDelegate = delegate ;
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
	
	if(didNibPrepared == NO){
		UINib * nib = [UINib nibWithNibName: @"PzTenKeyCell" bundle:nil];
		[view registerNib: nib forCellWithReuseIdentifier: @"Key"] ;
		didNibPrepared = YES ;
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
	if(clickDelegate){
		const struct PzTenKeyInfo * info = tenKeyInfo(tenKeyState, button.tag) ;
		[clickDelegate pressKey: info->code] ;
	} else {
		int tag = (int) button.tag ;
		NSLog(@"click event: %d\n", tag) ;
	}
}

- (void) updateCells: (NSArray *) cells withState: (enum PzTenKeyState) newstate
{
	tenKeyState = newstate ;
	
	UICollectionViewCell * cell ;
	for(cell in cells){
		UIButton *	button ;
		UIView *	background ;
		if(buttonInCell(&button, &background, cell)){
			updateButtonLabel(newstate, button, background) ;
		} else {
			NSLog(@"Failed to get button") ;
		}
	}
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
	
	/* Set label title */
	NSString * title = [[NSString alloc] initWithUTF8String: info->label] ;
	[button setTitle: title forState: UIControlStateNormal] ;
	
	/* Set label font */
	BOOL isbold ;
	switch(info->code){
		case PzTenKeyCode_DecState: {
			isbold = (state == PzTenKeyDecState) ;
		} break ;
		case PzTenKeyCode_HexState: {
			isbold = (state == PzTenKeyHexState) ;
		} break ;
		case PzTenKeyCode_OpState: {
			isbold = (state == PzTenKeyOpState) ;
		} break ;
		default: {
			isbold = false ;
		} break ;
	}
	if(isbold){
		button.titleLabel.font = [UIFont boldSystemFontOfSize: 20.0];
	} else {
		button.titleLabel.font = [UIFont systemFontOfSize: 18.0];
	}
	
	/* Set background */
	KCColorTable * ctable = [KCColorTable defaultColorTable] ;
	UIColor * backcol ;
	switch(info->code & PzTenKeyMask_Mask){
		case PzTenKeyMask_State:	backcol = ctable.darkGray ;	break ;
		case PzTenKeyMask_Normal:	backcol = ctable.gainsboro ;	break ;
		case PzTenKeyMask_Edit:		backcol = ctable.darkOrange1 ;	break ;
		case PzTenKeyMask_Operator:	backcol = ctable.darkOrange1 ;	break ;
		default:			backcol = ctable.gainsboro ;	break ;
	}
	background.opaque = NO ;
	background.backgroundColor = backcol ;
	
	/* Set round */
	[[button layer] setBorderColor: [ctable.darkGray CGColor]];
	[[button layer] setBorderWidth: 0.5];
}


