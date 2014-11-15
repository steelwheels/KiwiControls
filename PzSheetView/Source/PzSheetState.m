/**
 * @file	PzSheetState.m
 * @brief	Define PzSheetState class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzSheetState.h"

static const NSUInteger		LabelTagMask	= 0x10000000 ;
static const NSUInteger		FieldTagMask	= 0x20000000 ;
static const NSUInteger		TagValueMask	= 0x0fffffff ;

@implementation PzSheetState

@synthesize isScrolling ;

+ (void) setSlotNum: (NSUInteger) tag toLabel: (UILabel *) label
{
	label.tag = LabelTagMask | (tag & TagValueMask) ;
}

+ (NSUInteger) slotNumOfLabel: (UILabel *) label
{
	return label.tag & TagValueMask ;
}

+ (void) setSlotNum: (NSUInteger) tag toTextField: (UITextField *) field
{
	field.tag = FieldTagMask | (tag & TagValueMask) ;
}

+ (NSUInteger) slotNumOfTextField: (UITextField *) field
{
	return field.tag & TagValueMask ;
}

- (instancetype) init
{
	if((self = [super init]) != nil){
		self.isScrolling = NO ;
		self.currentSlot = 0 ;
	}
	return self ;
}

@end

