/**
 * @file	KSPopupMenu.h
 * @brief	Define KSPopupMenu class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import <UIKit/UIKit.h>

@interface KSPopupMenu : NSObject <UIPopoverControllerDelegate>
{
	UIPopoverController *	popoverController ;
}

- (NSInteger) popupMenuInView: (UIView *) parent withLabelArray: (NSArray *) labelArray ;

@end
