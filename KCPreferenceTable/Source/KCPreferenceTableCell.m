/**
 * @file	KCPreferenceTableCell.m
 * @brief	Define KCPreferenceTableCell class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCPreferenceTableCell.h"

@implementation KCPreferenceTableCell

@synthesize textView ;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
