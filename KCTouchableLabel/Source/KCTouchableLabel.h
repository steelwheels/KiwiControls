/**
 * @file	KCTouchableLabel.h
 * @brief	Define KCTouchableLabel class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 * @par Reference
 *   <ul>
 *     <li><a href="http://program.station.ez-net.jp/special/handbook/objective-c/uilabel/touch.asp">UILabel でタッチされたことを検出する</a>(Japanese)</li>
 *   </ul>
 */

#import <UIKit/UIKit.h>

@class KCTouchableLabel ;

@protocol KCTouchLabelDelegate
- (void)label:(KCTouchableLabel *)label touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)label:(KCTouchableLabel *)label touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)label:(KCTouchableLabel *)label touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface KCTouchableLabel : UILabel

@property (strong, nonatomic) id <KCTouchLabelDelegate>	touchableLabelDelegate ;

@end
