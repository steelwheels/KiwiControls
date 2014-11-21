/**
 * @file	PzSheetDatabase.m
 * @brief	Define PzSheetDatabase class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "PzSheetDatabase.h"

@interface PzSheetData : NSObject

@property NSString *	expressionString ;
@property NSString *	labelString ;

- (instancetype) init ;

@end

@implementation PzSheetData

@synthesize expressionString ;
@synthesize labelString ;

- (instancetype) init
{
	if((self = [super init]) != nil){
		self.labelString = [[NSString alloc] initWithUTF8String: ""] ;
		self.expressionString = [[NSString alloc] initWithUTF8String: ""] ;
	}
	return self ;
}

@end

@implementation PzSheetDatabase

+ (NSUInteger) maxRowNum
{
	return 128 ;
}

- (instancetype) init
{
	if((self = [super init]) != nil){
		sheetDataArray = [[NSMutableArray alloc] initWithCapacity: 16] ;
		NSUInteger count = [PzSheetDatabase maxRowNum] ;
		for(NSUInteger i=0 ; i<count ; i++){
			PzSheetData * newdata = [[PzSheetData alloc] init] ;
			[sheetDataArray addObject: newdata] ;
		}
	}
	return self ;
}

- (NSString *) expressionStringAtIndex: (NSUInteger) index
{
	if(index < [sheetDataArray count]){
		PzSheetData * data = [sheetDataArray objectAtIndex: index] ;
		return data.expressionString ;
	} else {
		return @"" ;
	}
}

- (void) setExpressionString: (NSString *) str atIndex: (NSUInteger) index
{
	if(index < [sheetDataArray count]){
		PzSheetData * data = [sheetDataArray objectAtIndex: index] ;
		data.expressionString = str ;
	}
}

- (NSString *) labelStringAtIndex: (NSUInteger) index
{
	if(index < [sheetDataArray count]){
		PzSheetData * data = [sheetDataArray objectAtIndex: index] ;
		return data.labelString ;
	} else {
		return @"" ;
	}
}

- (void) setLabelString: (NSString *) str atIndex: (NSUInteger) index
{
	if(index < [sheetDataArray count]){
		PzSheetData * data = [sheetDataArray objectAtIndex: index] ;
		data.labelString = str ;
	}
}

- (void) clearStringsAtIndex: (NSUInteger) index
{
	if(index < [sheetDataArray count]){
		PzSheetData * data = [sheetDataArray objectAtIndex: index] ;
		data.expressionString = @"" ;
		data.labelString = @"" ;
	}
}

@end
