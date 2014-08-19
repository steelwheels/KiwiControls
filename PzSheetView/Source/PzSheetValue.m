/**
 * @file	PzSheetValue.h
 * @brief	Define PzSheetValue class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzSheetValue.h"

@implementation PzSheetValue

@synthesize valueType ;

- (instancetype) init
{
	if((self = [super init]) != nil){
		valueType = PzSheetBooleanValue ;
		scalarValue.booleanValue = false ;
		stringValue = nil ;
	}
	return self ;
}

- (void) setBooleanValue: (BOOL) value
{
	valueType = PzSheetBooleanValue ;
	scalarValue.booleanValue = value ;
}

- (void) setSignedIntegerValue: (NSInteger) value
{
	valueType = PzSheetSignedIntegerValue;
	scalarValue.signedIntegerValue = value ;
}

- (void) setUnsignedIntegerValue: (NSUInteger) value
{
	valueType = PzSheetUnsignedIntegerValue;
	scalarValue.unsignedIntegerValue = value ;
}

- (void) setFloatValue: (double) value
{
	valueType = PzSheetFloatValue ;
	scalarValue.floatValue = value ;
}

- (void) setStringValue: (NSString *) value
{
	valueType = PzSheetStringValue ;
	stringValue = value ;
}

- (BOOL) booleanValue
{
	assert(valueType == PzSheetBooleanValue) ;
	return scalarValue.booleanValue ;
}

- (NSInteger) signedIntegerValue
{
	assert(valueType == PzSheetSignedIntegerValue) ;
	return scalarValue.signedIntegerValue ;
}

- (NSUInteger) unsignedIntegerValue
{
	assert(valueType == PzSheetUnsignedIntegerValue) ;
	return scalarValue.unsignedIntegerValue ;
}

- (double) floatValue
{
	assert(valueType == PzSheetFloatValue) ;
	return scalarValue.floatValue ;
}

- (NSString *) stringValue
{
	assert(valueType == PzSheetStringValue) ;
	return stringValue ;
}

- (NSString *) toString
{
	NSString * result = nil ;
	switch(valueType){
		case PzSheetBooleanValue: {
			result = scalarValue.booleanValue ? @"true" : @"false" ;
		} break ;
		case PzSheetSignedIntegerValue: {
			result = [[NSString alloc] initWithFormat: @"%ld", (long int) scalarValue.signedIntegerValue] ;
		} break ;
		case PzSheetUnsignedIntegerValue: {
			result = [[NSString alloc] initWithFormat: @"%lu", (unsigned long int) scalarValue.unsignedIntegerValue] ;
		} break ;
		case PzSheetFloatValue: {
			result = [[NSString alloc] initWithFormat: @"%lf", scalarValue.floatValue] ;
		} break ;
		case PzSheetStringValue: {
			result = stringValue ;
		} break ;
	}
	return result ;
}

@end
