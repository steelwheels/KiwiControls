/**
 * @file	KCDebugUtil.m
 * @brief	Define utility functions for debugging
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCDebugUtil.h"

static const char *
y_or_n(BOOL flag) ;

static void
printView(unsigned int depth, unsigned int index, UIView * view)
{
	NSString * name = NSStringFromClass([view class]) ;
	unsigned int i ;
	for(i=0 ; i<depth ; i++){
		putc(' ', stdout) ;
	}
	printf("%u: %s ", index, [name UTF8String]) ;
	printf("*1:%s ", y_or_n([view translatesAutoresizingMaskIntoConstraints])) ;
	putc('\n', stdout) ;
	
	i = 0 ;
	NSArray * subviews = [view subviews] ;
	UIView * subview ;
	for(subview in subviews){
		printView(depth+1, i++, subview) ;
	}
}

void
KCPrintView(UIView * view)
{
	printf("*1 : translatesAutoresizingMaskIntoConstraints\n") ;
	printView(0, 0, view) ;
}

static const char *
y_or_n(BOOL flag)
{
	return flag ? "yes" : "no" ;
}