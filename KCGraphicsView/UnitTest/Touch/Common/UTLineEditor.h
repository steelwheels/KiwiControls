/**
 * @file	UTLineEditor.h
 * @brief	Define UTLineEditor class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import <KCGraphicsView/KCGraphicsView.h>

#define MAX_POINT_NUM		1024

@interface UTLineEditor : NSObject <KCGraphicsDrawing>
{
	unsigned int	pointNum ;
	CGPoint		pointArray[MAX_POINT_NUM] ;
}

- (instancetype) init ;

@end
