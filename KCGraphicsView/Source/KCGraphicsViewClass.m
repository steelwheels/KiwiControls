/**
 * @file	KCGraphicsView.m
 * @brief	Define KCGraphicsView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "KCGraphicsViewClass.h"

@implementation KCGraphicsView

- (instancetype) initWithCoder:(NSCoder *) decoder
{
	if((self = [super initWithCoder: decoder]) != nil){
		graphicsViews = [[NSMutableArray alloc] initWithCapacity: 4] ;
	}
	return self ;
}

#if TARGET_OS_IPHONE
- (instancetype) initWithFrame:(CGRect)frame
#else
- (instancetype) initWithFrame:(NSRect)frame
#endif
{
	if((self = [super initWithFrame: frame]) != nil){
		graphicsViews = [[NSMutableArray alloc] initWithCapacity: 4] ;
	}
	return self ;
}

- (void) addGraphicsDrawer: (id <KCGraphicsDrawing>) drawer withDelegate: (id <KCGraphicsDelegate>) delegate
{
	KCGraphicsLayerView * newlayer = [[KCGraphicsLayerView alloc] initWithFrame: self.bounds] ;
	[newlayer setGraphicsDrawer: drawer] ;
	if(delegate){
		[newlayer setGraphicsDelegate: delegate] ;
	}
	[graphicsViews addObject: newlayer] ;
	[self addSubview: newlayer] ;
	KCLayoutSubviewWithMargines(self, newlayer, 0.0, 0.0, 0.0, 0.0) ;
}

- (void) drawRect:(CGRect) dirtyRect
{
	[super drawRect:dirtyRect];
}

- (void) setAllNeedsDisplay
{
	NSArray * subviews = self.subviews ;
#if TARGET_OS_IPHONE
	for(UIView * subview in subviews){
		[subview setNeedsDisplay] ;
	}
	[self setNeedsDisplay] ;
#else
	for(NSView * subview in subviews){
		[subview setNeedsDisplay: YES] ;
	}
	[self setNeedsDisplay: YES] ;
#endif
}

#if TARGET_OS_IPHONE
- (void) touchesBegan: (NSSet *) touches withEvent:(UIEvent *)event
{
	(void) event ;

	NSUInteger	layernum = [graphicsViews count] ;
	NSUInteger	i ;
	for(i=layernum ; i>=1 ; i--){
		KCGraphicsLayerView * layerview = [graphicsViews objectAtIndex: i-1] ;
		if([layerview.graphicsDrawer isEditable]){
			[layerview touchesBegan: touches withEvent: event] ;
			break ;
		}
	}
}
#else
- (void) mouseDown: (NSEvent *) event
{	
	NSUInteger	layernum = [graphicsViews count] ;
	NSUInteger	i ;
	for(i=layernum ; i>=1 ; i--){
		KCGraphicsLayerView * layerview = [graphicsViews objectAtIndex: i-1] ;
		if([layerview.graphicsDrawer isEditable]){
			[layerview mouseDown: event] ;
			break ;
		}
	}
}
#endif

#if TARGET_OS_IPHONE
- (void) touchesMoved: (NSSet *) touches withEvent:(UIEvent *)event
{
	(void) event ;
	
	NSUInteger	layernum = [graphicsViews count] ;
	NSUInteger	i ;
	for(i=layernum ; i>=1 ; i--){
		KCGraphicsLayerView * layerview = [graphicsViews objectAtIndex: i-1] ;
		if([layerview.graphicsDrawer isEditable]){
			[layerview touchesMoved: touches withEvent: event] ;
			break ;
		}
	}
}

#else
- (void) mouseDragged: (NSEvent *) event
{
	NSUInteger	layernum = [graphicsViews count] ;
	NSUInteger	i ;
	for(i=layernum ; i>=1 ; i--){
		KCGraphicsLayerView * layerview = [graphicsViews objectAtIndex: i-1] ;
		if([layerview.graphicsDrawer isEditable]){
			[layerview mouseDragged: event] ;
			break ;
		}
	}
}
#endif

#if TARGET_OS_IPHONE
- (void) touchesEnded: (NSSet *) touches withEvent:(UIEvent *)event
{
	(void) touches ; (void) event ;
	
	NSUInteger	layernum = [graphicsViews count] ;
	NSUInteger	i ;
	for(i=layernum ; i>=1 ; i--){
		KCGraphicsLayerView * layerview = [graphicsViews objectAtIndex: i-1] ;
		if([layerview.graphicsDrawer isEditable]){
			[layerview touchesEnded: touches withEvent: event] ;
			break ;
		}
	}
}

- (void) touchesCancelled: (NSSet *) touches withEvent:(UIEvent *)event
{
	(void) touches ; (void) event ;
	
	NSUInteger	layernum = [graphicsViews count] ;
	NSUInteger	i ;
	for(i=layernum ; i>=1 ; i--){
		KCGraphicsLayerView * layerview = [graphicsViews objectAtIndex: i-1] ;
		if([layerview.graphicsDrawer isEditable]){
			[layerview touchesCancelled: touches withEvent: event] ;
			break ;
		}
	}
}

#else
- (void) mouseUp: (NSEvent *) event
{
	NSUInteger	layernum = [graphicsViews count] ;
	NSUInteger	i ;
	for(i=layernum ; i>=1 ; i--){
		KCGraphicsLayerView * layerview = [graphicsViews objectAtIndex: i-1] ;
		if([layerview.graphicsDrawer isEditable]){
			[layerview mouseUp: event] ;
			break ;
		}
	}
}
#endif

@end
