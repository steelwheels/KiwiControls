/**
 * @file	UTGraphicsDrawer.m
 * @brief	Subclass of KCGraphicsDrawer for unit test
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */


#import "UTGraphicsDrawer.h"

@interface UTGraphicsDrawer (Private)
- (void) drawCircleWithContext: (CGContextRef) context atLevel: (NSUInteger) level inBoundsRect: (CGRect) boundsrect ;
@end

@implementation UTGraphicsDrawer

- (void) drawWithContext: (CGContextRef) context atLevel: (NSUInteger) level inBoundsRect: (CGRect) boundsrect
{
	[self drawCircleWithContext: context atLevel: level inBoundsRect: boundsrect] ;
}

@end

@implementation UTGraphicsDrawer (Private)

- (void) drawCircleWithContext: (CGContextRef) context atLevel: (NSUInteger) level inBoundsRect: (CGRect) boundsrect
{
	(void) level ;
	//printf("[%s] draw for layer %u\n", __func__, (unsigned int) level) ;
	//CNPrintRect(boundsrect) ;
	
	CNColorTable * coltable = [CNColorTable defaultColorTable] ;
	struct CNRGB black = coltable.black ;
	struct CNRGB red = coltable.red ;
	
	switch(2){
		case 0: {
			KCSetFillColor(context, &red) ;
			CGFloat width = MIN(boundsrect.size.width, boundsrect.size.height) ;
			CGRect circlebounds = {
				.origin = {.x = 0.0, .y=0.0} ,
				.size   = {.width = width, .height=width}
			} ;
			CGContextFillEllipseInRect(context, circlebounds);
		} break ;
		case 1: {
			KCSetFillColor(context, &red) ;
			CGFloat radius = MIN(boundsrect.size.width / 2.0, boundsrect.size.height / 2.0) ;
			struct CNCircle circle = CNMakeCircle(radius, radius, radius) ;
			CGRect cbounds = CNBoundsOfCircle(&circle) ;
			CGContextFillEllipseInRect(context, cbounds);
		} break ;
		case 2: {
			//CGContextRef context = UIGraphicsGetCurrentContext();
			CGContextSaveGState(context);
   
			CGContextAddEllipseInRect(context, boundsrect);
			KCSetFillColor(context, &black) ;
			CGContextFillRect(context, boundsrect) ;
			
			CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
			CGFloat components[] = {
				1.0f, 1.0f, 1.0f, 1.0f,
				0.5f, 0.5f, 0.5f, 1.0f,
				0.0f, 0.0f, 0.0f, 1.0f,
			};
			CGFloat locations[] = { 0.0, 0.5, 1.0 };
   
			size_t count = sizeof(components)/ (sizeof(CGFloat)* 4);
			CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, count);
			
			CGRect frame = boundsrect ;
			CGFloat radius = MIN(frame.size.height, frame.size.width)/2.0*0.8;
			
			CGPoint startCenter = frame.origin;
			startCenter.x += frame.size.width/2.0;
			startCenter.y += frame.size.height/2.0;
			CGPoint endCenter = startCenter;
   
			CGFloat startRadius = radius * 0.8 ; //0;
			CGFloat endRadius = radius;
   
			CGContextDrawRadialGradient(context,
						    gradientRef,
						    startCenter,
						    startRadius,
						    endCenter,
						    endRadius,
						    kCGGradientDrawsAfterEndLocation);
   
			CGGradientRelease(gradientRef);
			CGColorSpaceRelease(colorSpaceRef);
   
			CGContextRestoreGState(context);
		} break ;
	}
}

@end
