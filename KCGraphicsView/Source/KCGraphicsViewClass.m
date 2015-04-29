/**
 * @file	KCGraphicsViewClass.m
 * @brief	Define KCGraphicsView class for Mac OS X
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCGraphicsViewClass.h"

#define DO_DEBUG 0
#if DO_DEBUG
#	import <CoconutGraphics/CoconutGraphics.h>
#endif

static inline BOOL
isEditable(id <KCGraphicsEditing> editor)
{
	return (editor != nil) && [editor isEditable] ;
}

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
	layerLevel = 0 ;
	graphicsDrawer   = nil ;
	graphicsEditor   = nil ;
	graphicsDelegate = nil ;
#	if TARGET_OS_IPHONE
	self.opaque = NO ;
	self.backgroundColor = [UIColor colorWithWhite: 1.0 alpha: 0.0] ;
#	endif
	[self setTranslatesAutoresizingMaskIntoConstraints: NO] ;
}

- (void) setLayerLevel: (NSUInteger) level
{
	layerLevel = level ;
}

- (NSUInteger) layerLevel
{
	return layerLevel ;
}

- (void) setGraphicsDrawer: (id <KCGraphicsDrawing>) drawer
{
	graphicsDrawer = drawer ;
}

- (id <KCGraphicsDrawing>) graphicsDrawer
{
	return graphicsDrawer ;
}

- (void) setGraphicsEditor: (id <KCGraphicsEditing>) editor
{
	graphicsEditor = editor ;
}

- (void) removeGraphicsEditor
{
	graphicsEditor = nil ;
}

- (id <KCGraphicsEditing>) graphicsEditor
{
	return graphicsEditor ;
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
		[graphicsDrawer drawWithContext: context atLevel: layerLevel inBoundsRect: bounds] ;
		
#		if DO_DEBUG
		CNPrintRect(bounds) ;
#		endif
	}
	CGContextRestoreGState(context);
}

#if TARGET_OS_IPHONE
- (void) touchesBegan: (NSSet *) touches withEvent:(UIEvent *)event
{
	(void) event ;
	if(isEditable(graphicsEditor)){
		CGPoint touchedpoint = [[touches anyObject] locationInView:self];
		CGRect  bounds       = self.bounds ;
		CGPoint flppoint     = flipPoint(touchedpoint, bounds) ;
		CGRect  flprect      = flipBounds(bounds) ;
		[graphicsEditor touchesBegan: flppoint atLevel: layerLevel inBoundsRect: flprect] ;
	}
}
#else
- (void) mouseDown: (NSEvent *) event
{
	if(isEditable(graphicsEditor)){
		NSPoint abspoint  = [event locationInWindow] ;
		NSPoint locpoint  = [self convertPoint: abspoint fromView: nil] ;
		NSRect  bounds    = self.bounds ;
		NSPoint flppoint  = flipPoint(locpoint, bounds) ;
		NSRect  flpbounds = flipBounds(bounds) ;
		[graphicsEditor touchesBegan: flppoint atLevel: layerLevel inBoundsRect: flpbounds] ;
	}
}
#endif

#if TARGET_OS_IPHONE
- (void) touchesMoved: (NSSet *) touches withEvent:(UIEvent *)event
{
	(void) event ;
	if(isEditable(graphicsEditor)){
		CGPoint touchedpoint = [[touches anyObject] locationInView:self];
		CGRect  bounds       = self.bounds ;
		CGPoint flppoint     = flipPoint(touchedpoint, bounds) ;
		CGRect  flprect      = flipBounds(bounds) ;
		if([graphicsEditor touchesMoved: flppoint atLevel: layerLevel inBoundsRect: flprect]){
			[self setNeedsDisplay] ;
		}
	}
}
#else
- (void) mouseDragged: (NSEvent *) event
{
	if(isEditable(graphicsEditor)){
		NSPoint abspoint  = [event locationInWindow] ;
		NSPoint locpoint  = [self convertPoint: abspoint fromView: nil] ;
		NSRect  bounds    = self.bounds ;
		NSPoint flppoint  = flipPoint(locpoint, bounds) ;
		NSRect  flpbounds = flipBounds(bounds) ;
		if([graphicsEditor touchesMoved: flppoint atLevel: layerLevel inBoundsRect: flpbounds]){
			[self setNeedsDisplay: YES] ;
		}
	}
}
#endif

#if TARGET_OS_IPHONE
- (void) touchesEnded: (NSSet *) touches withEvent:(UIEvent *)event
{
	(void) touches ; (void) event ;
	if(isEditable(graphicsEditor)){
		if([graphicsEditor touchesEnded]){
			[self setNeedsDisplay] ;
		}
		if(graphicsDelegate){
			[graphicsDelegate editingGraphicsEnded] ;
		}
	}
}

- (void) touchesCancelled: (NSSet *) touches withEvent:(UIEvent *)event
{
	(void) touches ; (void) event ;
	if(isEditable(graphicsEditor)){
		if([graphicsEditor touchesCancelled]){
			[self setNeedsDisplay] ;
		}
		if(graphicsDelegate){
			[graphicsDelegate editingGraphicsCancelled] ;
		}
	}
}
#else
- (void) mouseUp: (NSEvent *) event
{
	(void) event ;
	if(isEditable(graphicsEditor)){
		if([graphicsEditor touchesEnded]){
			[self setNeedsDisplay: YES] ;
		}
		if(graphicsDelegate){
			[graphicsDelegate editingGraphicsEnded] ;
		}
	}
}
#endif

@end

@implementation KCGraphicsView

- (instancetype) initWithCoder:(NSCoder *) decoder
{
	if((self = [super initWithCoder: decoder]) != nil){
		transparentViews = nil ;
	}
	return self ;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame: frame]) != nil){
		transparentViews = nil ;
	}
	return self ;
}

- (void) setGraphicsDrawer: (id <KCGraphicsDrawing>) drawer
{
	[super setGraphicsDrawer: drawer] ;
	for(KCGraphicsLayerView * layer in transparentViews){
		[layer setGraphicsDrawer: drawer] ;
	}
}

- (void) setGraphicsEditor: (id <KCGraphicsEditing>) editor
{
	[super setGraphicsEditor: editor] ;
	for(KCGraphicsLayerView * layer in transparentViews){
		[layer setGraphicsEditor: editor] ;
	}
}

- (void) setGraphicsDelegate: (id <KCGraphicsDelegate>) delegate
{
	[super setGraphicsDelegate: delegate] ;
	for(KCGraphicsLayerView * layer in transparentViews){
		[layer setGraphicsDelegate: delegate] ;
	}
}

- (void) allocateTransparentViews: (unsigned int) viewnum
{
	if(transparentViews == nil){
		transparentViews = [[NSMutableArray alloc] initWithCapacity: 4] ;
	}
	
	NSUInteger i    = [transparentViews count] ;
	NSUInteger endi = i + viewnum ;
	for( ; i<endi ; i++){
		KCGraphicsLayerView * transview = [[KCGraphicsLayerView alloc] initWithFrame: self.bounds] ;
		
		[transview setLayerLevel: i+1] ;
		[transview setGraphicsDrawer: self.graphicsDrawer] ;
		if(self.graphicsEditor){
			[transview setGraphicsEditor: self.graphicsEditor] ;
		}
		if(self.graphicsDelegate){
			[transview setGraphicsDelegate: self.graphicsDelegate] ;
		}
		[self addSubview: transview] ;
		KCLayoutSubviewWithMargines(self, transview, 0.0, 0.0, 0.0, 0.0) ;
	}
}

@end

