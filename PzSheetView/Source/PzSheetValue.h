/**
 * @file	PzSheetValue.h
 * @brief	Define PzSheetValue class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <Foundation/Foundation.h>

typedef enum {
	PzSheetBooleanValue,
	PzSheetSignedIntegerValue,
	PzSheetUnsignedIntegerValue,
	PzSheetFloatValue,
	PzSheetStringValue
} PzSheetValueType ;

@interface PzSheetValue : NSObject
{
	union {
		BOOL		booleanValue ;
		NSInteger	signedIntegerValue ;
		NSUInteger	unsignedIntegerValue ;
		double		floatValue ;
	} scalarValue ;
	
	NSString *	stringValue ;
}

@property (assign, nonatomic)	PzSheetValueType	valueType ;

- (instancetype) init ;

- (void) setBooleanValue: (BOOL) value ;
- (void) setSignedIntegerValue: (NSInteger) value ;
- (void) setUnsignedIntegerValue: (NSUInteger) value ;
- (void) setFloatValue: (double) value ;
- (void) setStringValue: (NSString *) value ;

- (BOOL) booleanValue ;
- (NSInteger) signedIntegerValue ;
- (NSUInteger) unsignedIntegerValue ;
- (double) floatValue ;
- (NSString *) stringValue ;

- (NSString *) toString ;

@end
