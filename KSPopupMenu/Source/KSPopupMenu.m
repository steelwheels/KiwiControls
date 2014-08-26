/**
 * @file	KSPopupMenu.m
 * @brief	Define KSPopupMenu class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KSPopupMenu.h"
#import "KSPopupMenuViewController.h"

@implementation KSPopupMenu

- (NSInteger) popupMenuInView: (UIView *) parent withLabelArray: (NSArray *) labelArray
{
	KSPopupMenuViewController * menucontroller ;
	menucontroller = [[KSPopupMenuViewController alloc] initWithStyle: UITableViewStylePlain] ;
	
	popoverController = [[UIPopoverController alloc] initWithContentViewController: menucontroller] ;
	popoverController.delegate = self ;
	
	[popoverController presentPopoverFromRect: parent.bounds
					   inView: parent
			 permittedArrowDirections: UIPopoverArrowDirectionAny
					 animated: YES] ;
	return 0 ;
}

@end
