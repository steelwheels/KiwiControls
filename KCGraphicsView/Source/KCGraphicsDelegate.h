/**
 * @file	KCGraphicsDelegate.h
 * @brief	Define KCGraphicsDelegate delegate
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

@protocol KCGraphicsDelegate <NSObject>
- (void) editingGraphicsEndedWithData: (void *) data ;
- (void) editingGraphicsCancelled ;
@end
