/**
 * @file	KCDebugUtil.m
 * @brief	Define utility functions for debugging
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCDebugUtil.h"
#import "KCViewVisitor.h"

static const char *
y_or_n(BOOL flag) ;

void
KCPrintPoint(CGPoint src)
{
	printf("(x=%.2lf, y=%.2lf)", src.x, src.y) ;
}

void
KCPrintSize(CGSize src)
{
	printf("(w=%.2lf, h=%.2lf)", src.width, src.height) ;
}

void
KCPrintRect(CGRect src)
{
	fputs("(", stdout) ;
	KCPrintPoint(src.origin) ;
	KCPrintSize(src.size) ;
	fputs(")", stdout) ;
}

static const char *
y_or_n(BOOL flag)
{
	return flag ? "yes" : "no" ;
}

/************************************************************************
 * View printer								*
 ************************************************************************/

@interface KCPrintParameter : NSObject
@property (assign, nonatomic)	NSUInteger	depth ;
@property (assign, nonatomic)	NSUInteger	index ;
- (instancetype) init ;
@end

@implementation KCPrintParameter
@synthesize depth, index ;
- (instancetype) init
{
	if((self = [super init]) != nil){
		self.depth = self.index = 0 ;
	}
	return self ;
}
@end

static void
printIndent(NSUInteger depth)
{
	NSUInteger i ;
	for(i=0 ; i<depth ; i++){
		putc(' ', stdout) ;
	}
}

@interface KCViewPrinter : KCViewVisitor
- (instancetype) init ;
- (void) printView: (UIView *) view withParameter: (KCPrintParameter *) parameter ;
@end

@implementation KCViewPrinter

- (instancetype) init
{
	if((self = [super init]) != nil){
	}
	return self ;
}

- (void) visitView: (UIView *) view withParameter: (id) parameter
{
	[self printView: view withParameter: parameter] ;
}

- (void) visitTableView: (UITableView *) view withParameter: (id) parameter
{
	[self printView: view withParameter: parameter] ;
}

- (void) visitCollectionView: (UICollectionView *) view withParameter: (id) parameter
{
	[self printView: view withParameter: parameter] ;
}

- (void) printView: (UIView *) view withParameter: (KCPrintParameter *) parameter
{
	NSString * name = NSStringFromClass([view class]) ;
	
	printIndent(parameter.depth) ;
	printf("%lu: %s ", (unsigned long int) parameter.index, [name UTF8String]) ;
	
	fputs(" f", stdout) ; KCPrintRect(view.frame) ;
	fputs(" b", stdout) ; KCPrintRect(view.frame) ;
	
	printf("*1:%s ", y_or_n([view translatesAutoresizingMaskIntoConstraints])) ;
	putc('\n', stdout) ;
	
	KCPrintParameter * subparam = [[KCPrintParameter alloc] init] ;
	subparam.index = 0 ;
	subparam.depth = parameter.depth + 1 ;
	NSArray * subviews = [view subviews] ;
	UIView * subview ;
	for(subview in subviews){
		[subview acceptViewVisitor: self withParameter: subparam] ;
		subparam.index += 1 ;
	}
}

@end

void
KCPrintView(UIView * view)
{
	KCViewPrinter * printer = [[KCViewPrinter alloc] init] ;
	KCPrintParameter * parameter = [[KCPrintParameter alloc] init] ;
	[view acceptViewVisitor: printer withParameter: parameter] ;
}
