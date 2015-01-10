/**
 * @file	KCGraphicsDrawer.m
 * @brief	Define KCGraphicsDrawer class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCGraphicsDrawer.h"

@implementation KCGraphicsDrawer

- (void) drawWithContext: (CGContextRef) context inFrameRect: (NSRect) framerect
{
	CGContextSetRGBFillColor(context, 1, 1, 1, 1);//塗りつぶし色
	CGContextFillRect(context, NSRectToCGRect(framerect));// 四角形を塗りつぶす
	CGContextSaveGState(context);// グラフィック状態の保存
	CGContextSetRGBStrokeColor(context,0,0,1,1);// 線色
	CGContextSetLineWidth(context, 10.5); // 線の太さを変更
	CGContextMoveToPoint(context,10,200);
	CGContextAddLineToPoint(context, 200,200);
	CGContextStrokePath(context); // 描画！
	CGContextRestoreGState(context);// さっき保存した状態に戻す
}

@end
