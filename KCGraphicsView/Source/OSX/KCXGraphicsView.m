/**
 * @file	KCXGraphicsView.m
 * @brief	Define KCGraphicsView class for Mac OS X
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCXGraphicsView.h"
#import <KiwiControl/KiwiControl.h>

#define DO_DEBUG 0
#if DO_DEBUG
#	import <CoconutGraphics/CoconutGraphics.h>
#endif

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

- (instancetype) initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame: frame]) != nil){
		[self setLayerAttribute] ;
	}
	return self ;
}

- (void) setLayerAttribute
{
	layerLevel = 0 ;
	graphicsDrawer = nil ;
	//self.opaque = NO ;
	//self.backgroundColor = [NSColor colorWithWhite: 1.0 alpha: 0.0] ;
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

- (void) setGraphicsDrawer: (KCGraphicsDrawer *) drawer
{
	graphicsDrawer = drawer ;
}

- (KCGraphicsDrawer *) graphicsDrawer
{
	return graphicsDrawer ;
}

- (void) drawRect:(CGRect) dirtyRect
{
	[super drawRect:dirtyRect];
	
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort] ;
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

- (void) setGraphicsDrawer: (KCGraphicsDrawer *) drawer
{
	[super setGraphicsDrawer: drawer] ;
	for(KCGraphicsLayerView * layer in transparentViews){
		[layer setGraphicsDrawer: drawer] ;
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
		[self addSubview: transview] ;
		
		KCLayoutSubviewWithMargines(self, transview, 0.0, 0.0, 0.0, 0.0) ;
	}
}

@end

