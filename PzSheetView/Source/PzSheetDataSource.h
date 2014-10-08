/**
 * @file	PzSheetDataSource.h
 * @brief	Define PzSheetDataSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>
#import <KCTouchableLabel/KCTouchableLabel.h>

@protocol PzSheetViewTextFieldDelegate
- (void) enterText: (NSString *) text atIndex: (NSUInteger) index ;
@end

@protocol PzSheetViewTouchLabelDelegate <NSObject>
- (void) touchLabelAtIndex: (NSUInteger) index atAbsolutePoint: (CGPoint) point ;
@end

@interface PzSheetDataSource : NSObject <UITableViewDataSource, UITextFieldDelegate, KCTouchableLabelDelegate>
{
	BOOL					didNibPrepared ;
	
	id <PzSheetViewTextFieldDelegate>	sheetViewTextFieldDelegate ;
	id <PzSheetViewTouchLabelDelegate>	sheetViewTouchableLabelDelegate ;
	
	/** Array of PzSheetElement */
	NSMutableArray *			cellArray ;
	
	NSUInteger				currentSlot ;
}

+ (NSUInteger) maxRowNum ;

- (instancetype) init ;

- (void) setTextFieldDelegate: (id <PzSheetViewTextFieldDelegate>) delegate ;
- (void) setTouchableLabelDelegate: (id <PzSheetViewTouchLabelDelegate>) delegate ;

- (void) activateFirstResponder ;

- (void) moveCursorForwardInExpressionField ;
- (void) moveCursorBackwardInExpressionField ;
- (void) clearCurrentField ;
- (void) clearAllFields ;
- (void) selectNextExpressionField ;

- (void) insertStringToExpressionField: (NSString *) str ;
- (void) deleteSelectedStringInExpressionField ;

- (void) setLabelText: (NSString *) text forSlot: (NSInteger) index ;

@end

