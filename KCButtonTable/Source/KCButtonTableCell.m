/**
 * @file	KCButtonTableCell.m
 * @brief	Define KCButtonTableCell class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCButtonTableCell.h"

@implementation KCButtonTableCell

@synthesize tableButton ;

- (void) awakeFromNib
{
	[super awakeFromNib] ;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void) setValue: (id)value forUndefinedKey:(NSString *)key
{
	NSLog(@"Undef key %@", key) ;
}

@end
