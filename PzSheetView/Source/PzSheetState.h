/**
 * @file	PzSheetState.h
 * @brief	Define PzSheetState class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PzSheetState : NSObject

@property (assign, nonatomic) BOOL		isScrolling ;
@property (assign, nonatomic) NSUInteger	currentSlot ;

+ (void) setSlotNum: (NSUInteger) tag toLabel: (UILabel *) label ;
+ (NSUInteger) slotNumOfLabel: (UILabel *) label ;
+ (void) setSlotNum: (NSUInteger) tag toTextField: (UITextField *) field ;
+ (NSUInteger) slotNumOfTextField: (UITextField *) field ;

- (instancetype) init ;

@end
