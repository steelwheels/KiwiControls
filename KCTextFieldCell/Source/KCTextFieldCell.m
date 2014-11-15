/**
 * @file	KCTextFieldCell.h
 * @brief	Define KCTextFieldCell class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCTextFieldCell.h"

@implementation KCTextFieldCell

- (void) setDelegate:(id <KCTextFieldCellDelegate>)delegate
{
	[super setDelegate: delegate] ;
}

- (BOOL) resignFirstResponder
{
	if(self.delegate != nil){
		if([self.delegate respondsToSelector: @selector(isScrollingNow)]){
			id <KCTextFieldCellDelegate> adelegate = (id <KCTextFieldCellDelegate>) self.delegate ;
			if([adelegate isScrollingNow]){
				return NO ;
			}
		}
	}
	return [super resignFirstResponder] ;
}

@end
