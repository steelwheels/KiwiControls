/**
 * @file	KCGraphicsLayerView.m
 * @brief	Define KCGraphicsLayerView class
 * @par Copyright
 *   Copyright (C) 2014,2015 Steel Wheels Project
 */

#import "KCGraphicsLayerView.h"

#define DO_DEBUG 0
#if DO_DEBUG
#	import <CoconutGraphics/CoconutGraphics.h>
#endif

static inline CGPoint
flipPoint(CGPoint srcpoint, CGRect boundsrect)
{
	CGFloat x    = srcpoint.x - boundsrect.origin.x ;
	CGFloat y    = srcpoint.y - boundsrect.origin.y ;
	CGFloat revy = boundsrect.size.height - y ;
	return CGPointMake(x, revy) ;
}

static inline CGRect
flipBounds(CGRect bounds)
{
	return CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height) ;
}

@interface KCGraphicsLayerView ()
- (void) setLayerAttribute ;
@end

@implementation KCGraphicsLayerView

@synthesize graphicsDrawer, graphicsDelegate ;

- (instancetype) initWithCoder:(NSCoder *) decoder
{
	if((self = [super initWithCoder: decoder]) != nil){
		[self setLayerAttribute] ;
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
		[self setLayerAttribute] ;
	}
	return self ;
}

- (void) setLayerAttribute
{
	graphicsDrawer   = nil ;
	graphicsDelegate = nil ;
#	if TARGET_OS_IPHONE
	self.opaque = NO ;
	self.backgroundColor = [UIColor colorWithWhite: 1.0 alpha: 0.0] ;
#	endif
	[self setTranslatesAutoresizingMaskIntoConstraints: NO] ;
}

- (void) setGraphicsDrawer: (id <KCGraphicsDrawing>) drawer
{
	graphicsDrawer = drawer ;
}

- (id <KCGraphicsDrawing>) graphicsDrawer
{
	return graphicsDrawer ;
}

- (void) setGraphicsDelegate: (id <KCGraphicsDelegate>) delegate
{
	graphicsDelegate = delegate ;
}

- (id <KCGraphicsDelegate>) graphicsDelegate
{
	return graphicsDelegate ;
}

- (void) drawRect:(CGRect) dirtyRect
{	
	[super drawRect:dirtyRect];
	
#	if TARGET_OS_IPHONE
	CGContextRef context = UIGraphicsGetCurrentContext();
#	else
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort] ;
#	endif
	
	CGContextSaveGState(context);
	{
		CGRect bounds = [self bounds] ;
		
		/* Setup as left-lower-origin */
		CGFloat height = self.bounds.size.height;
		CGContextTranslateCTM(context, 0.0, height);
		CGContextScaleCTM(context, 1.0, - 1.0);
		
		/* Call drawer body */
		[graphicsDrawer drawWithContext: context inBoundsRect: bounds] ;
		
#		if DO_DEBUG
		CNPrintRect(bounds) ;
#		endif
	}
	CGContextRestoreGState(context);
}

#if TARGET_OS_IPHONE
- (void) touchesBegan: (NSSet *) touches withEvent:(UIEvent *) event
{
	(void) event ;
	if([graphicsDrawer isEditable]){
		CGPoint touchedpoint = [[touches anyObject] locationInView:self];
		CGRect  bounds       = self.bounds ;
		CGPoint flppoint     = flipPoint(touchedpoint, bounds) ;
		CGRect  flprect      = flipBounds(bounds) ;
		[graphicsDrawer touchesBegan: flppoint inBoundsRect: flprect] ;
	}
}
#else
- (void) mouseDown: (NSEvent *) event
{
	if([graphicsDrawer isEditable]){
		NSPoint abspoint  = [event locationInWindow] ;
		NSPoint locpoint  = [self convertPoint: abspoint fromView: nil] ;
		NSRect  bounds    = self.bounds ;
		NSPoint flppoint  = flipPoint(locpoint, bounds) ;
		NSRect  flpbounds = flipBounds(bounds) ;
		[graphicsDrawer touchesBegan: flppoint inBoundsRect: flpbounds] ;
	}
}
#endif

#if TARGET_OS_IPHONE
- (void) touchesMoved: (NSSet *) touches withEvent:(UIEvent *) event
{
	(void) event ;
	if([graphicsDrawer isEditable]){
		CGPoint touchedpoint = [[touches anyObject] locationInView:self];
		CGRect  bounds       = self.bounds ;
		CGPoint flppoint     = flipPoint(touchedpoint, bounds) ;
		CGRect  flprect      = flipBounds(bounds) ;
		[graphicsDrawer touchesMoved: flppoint inBoundsRect: flprect] ;
		[self setNeedsDisplay] ;
	}
}
#else
- (void) mouseDragged: (NSEvent *) event
{
	if([graphicsDrawer isEditable]){
		NSPoint abspoint  = [event locationInWindow] ;
		NSPoint locpoint  = [self convertPoint: abspoint fromView: nil] ;
		NSRect  bounds    = self.bounds ;
		NSPoint flppoint  = flipPoint(locpoint, bounds) ;
		NSRect  flpbounds = flipBounds(bounds) ;
		[graphicsDrawer touchesMoved: flppoint inBoundsRect: flpbounds] ;
		[self setNeedsDisplay: YES] ;
	}
}
#endif

#if TARGET_OS_IPHONE
- (void) touchesEnded: (NSSet *) touches withEvent:(UIEvent *)event
{
	(void) touches ; (void) event ;
	if([graphicsDrawer isEditable]){
		[graphicsDrawer touchesEnded] ;
		[self setNeedsDisplay] ;

		if(graphicsDelegate){
			[graphicsDelegate editingGraphicsEnded] ;
		}
	}
}

- (void) touchesCancelled: (NSSet *) touches withEvent:(UIEvent *)event
{
	(void) touches ; (void) event ;
	if([graphicsDrawer isEditable]){
		[graphicsDrawer touchesCancelled] ;
		[self setNeedsDisplay] ;

		if(graphicsDelegate){
			[graphicsDelegate editingGraphicsCancelled] ;
		}
	}
}
#else
- (void) mouseUp: (NSEvent *) event
{
	(void) event ;
	if([graphicsDrawer isEditable]){
		[graphicsDrawer touchesEnded] ;
		[self setNeedsDisplay: YES] ;
		
		if(graphicsDelegate){
			[graphicsDelegate editingGraphicsEnded] ;
		}
	}
}
#endif

@end


