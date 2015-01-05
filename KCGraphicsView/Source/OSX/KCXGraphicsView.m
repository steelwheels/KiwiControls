/**
 * @file	KCXGraphicsView.m
 * @brief	Define KCGraphicsView class for Mac OS X
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCXGraphicsView.h"

@implementation KCGraphicsView

- (void) drawRect:(NSRect) dirtyRect
{
	[super drawRect:dirtyRect];
    
	// Drawing code here.
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort] ;
	CGContextSetRGBFillColor(context, 1, 1, 1, 1);//塗りつぶし色
	CGContextFillRect(context, NSRectToCGRect(dirtyRect));// 四角形を塗りつぶす
	CGContextSaveGState(context);// グラフィック状態の保存
	CGContextSetRGBStrokeColor(context,0,0,1,1);// 線色
	CGContextSetLineWidth(context, 10.5); // 線の太さを変更
	CGContextMoveToPoint(context,10,200);
	CGContextAddLineToPoint(context, 200,200);
	CGContextStrokePath(context); // 描画！
	CGContextRestoreGState(context);// さっき保存した状態に戻す
}

@end
