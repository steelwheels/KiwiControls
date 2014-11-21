/**
 * @file	PzSheetDelegate.h
 * @brief	Define PzSheetDatabase class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <KCTouchableLabel/KCTouchableLabel.h>
#import <KCTextFieldExtension/KCTextFieldExtension.h>
#import "PzSheetForwarders.h"

@protocol PzSheetTouchLabelDelegate <NSObject>
- (void) touchLabelAtIndex: (NSUInteger) index atAbsolutePoint: (CGPoint) point ;
@end

@protocol PzSheetTextFieldDelegate
- (void) enterText: (NSString *) text atIndex: (NSUInteger) index ;
- (void) clearTextAtIndex: (NSUInteger) index ;
@end

@interface PzSheetDelegate : NSObject <UITableViewDelegate, KCTouchableLabelDelegate, KCTextFieldDelegate>
{
	PzSheetState *		sheetState ;
	PzSheetDatabase *	sheetDatabase ;
}

@property (weak, nonatomic)   PzSheetDataSource *		dataSource ;
@property (strong, nonatomic) id <PzSheetTouchLabelDelegate>	touchLabelDelegate ;
@property (strong, nonatomic) id <PzSheetTextFieldDelegate>	textFieldDelegate ;

- (instancetype) initWithSheetState: (PzSheetState *) state withDatabase:(PzSheetDatabase *)database ;

@end

