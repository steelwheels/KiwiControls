/**
 * @file	KCXIBUtil.m
 * @brief	Define utility functions for XIB file
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCXIBUtil.h"

static inline NSLayoutConstraint *
allocateLayout(UIView * parentview, UIView * subview, NSLayoutAttribute attribute)
{
	return [NSLayoutConstraint constraintWithItem: parentview
					    attribute: attribute
					    relatedBy: NSLayoutRelationEqual
					       toItem: subview
					    attribute: attribute
					   multiplier: 1.0
					     constant: 0.0];
}

UIView *
KCLoadXib(UIView * parentview, NSString * nibname)
{
	if([[parentview subviews] count] == 0){
		UINib *nib = [UINib nibWithNibName: nibname bundle:nil];
		UIView * loadedSubview = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
	
		[parentview addSubview:loadedSubview];
		
		loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
		
		[parentview addConstraint: allocateLayout(parentview, loadedSubview, NSLayoutAttributeTop)] ;
		[parentview addConstraint: allocateLayout(parentview, loadedSubview, NSLayoutAttributeLeft)] ;
		[parentview addConstraint: allocateLayout(parentview, loadedSubview, NSLayoutAttributeBottom)] ;
		[parentview addConstraint: allocateLayout(parentview, loadedSubview, NSLayoutAttributeRight)] ;
		
		return loadedSubview ;
	} else {
		return nil ;
	}
}


