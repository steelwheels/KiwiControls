/**
 * @file	KCTouchableLabel.m
 * @brief	Define KCTouchableLabel class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCTouchableLabel.h"

@implementation KCTouchableLabel

- (instancetype) initWithFrame: (CGRect) frame
{
	if((self = [super initWithFrame: frame]) != nil){
		self.touchableLabelDelegate = nil ;
		self.userInteractionEnabled = YES ;
	}
	return self ;
}

- (instancetype) initWithCoder: (NSCoder *) decoder
{
	if((self = [super initWithCoder: decoder]) != nil){
		self.touchableLabelDelegate = nil ;
		self.userInteractionEnabled = YES ;
	}
	return self ;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	id thisDelegate = self.touchableLabelDelegate ;
	if (thisDelegate && [thisDelegate respondsToSelector:@selector(label:touchesBegan:withEvent:)])
	{
		[thisDelegate label:self touchesBegan:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	id thisDelegate = self.touchableLabelDelegate ;
	if (thisDelegate && [thisDelegate respondsToSelector:@selector(label:touchesEnded:withEvent:)])
	{
		[thisDelegate label:self touchesEnded:touches withEvent:event];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	id thisDelegate = self.touchableLabelDelegate ;
	if (thisDelegate && [thisDelegate respondsToSelector:@selector(label:touchesCancelled:withEvent:)])
	{
		[thisDelegate label:self touchesCancelled:touches withEvent:event];
	}
}

@end
