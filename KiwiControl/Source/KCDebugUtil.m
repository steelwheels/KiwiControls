/**
 * @file	KCDebugUtil.m
 * @brief	Define utility functions for debugging
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCDebugUtil.h"
#import "KCViewVisitor.h"
#import "KCType.h"

#if TARGET_OS_IPHONE
#	define	KCView			UIView
#else
#	define	KCView			NSView
#endif

static const char *
y_or_n(BOOL flag)
{
	return flag ? "yes" : "no" ;
}

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
- (void) printMainView: (KCView *) view withParameter: (KCPrintParameter *) parameter ;
@end

@implementation KCViewPrinter

- (instancetype) init
{
	if((self = [super init]) != nil){
	}
	return self ;
}

- (void) visitView: (KCView *) view withParameter: (id) parameter
{
	[self printMainView: view withParameter: parameter] ;
	
	KCPrintParameter * mainparam = parameter ;
	KCPrintParameter * subparam = [[KCPrintParameter alloc] init] ;
	subparam.index = 0 ;
	subparam.depth = mainparam.depth + 1 ;
	NSArray * subviews = [view subviews] ;
	KCView * subview ;
	for(subview in subviews){
		[subview acceptViewVisitor: self withParameter: subparam] ;
		subparam.index += 1 ;
	}
}

#if TARGET_OS_IPHONE

- (void) visitTableView: (UITableView *) view withParameter: (id) parameter
{
	[self printMainView: view withParameter: parameter] ;
	
	KCPrintParameter * mainparam = parameter ;
	KCPrintParameter * subparam = [[KCPrintParameter alloc] init] ;
	subparam.index = 0 ;
	subparam.depth = mainparam.depth + 1 ;
	NSArray * cells = [view visibleCells] ;
	for(UITableViewCell * cell in cells){
		UIView * content = cell.contentView ;
		[content acceptViewVisitor: self withParameter: subparam] ;
		subparam.index += 1 ;
	}
}

- (void) visitCollectionView: (UICollectionView *) view withParameter: (id) parameter
{
	[self printMainView: view withParameter: parameter] ;
	
	KCPrintParameter * mainparam = parameter ;
	KCPrintParameter * subparam = [[KCPrintParameter alloc] init] ;
	subparam.index = 0 ;
	subparam.depth = mainparam.depth + 1 ;
	NSArray * cells = [view visibleCells] ;
	for(UICollectionViewCell * cell in cells){
		UIView * content = cell.contentView ;
		[content acceptViewVisitor: self withParameter: subparam] ;
		subparam.index += 1 ;
	}
}

#endif

- (void) printMainView: (KCView *) view withParameter: (KCPrintParameter *) parameter
{
	NSString * name = NSStringFromClass([view class]) ;
	
	printIndent(parameter.depth) ;
	printf("%lu: %s ", (unsigned long int) parameter.index, [name UTF8String]) ;
	
	fputs(" f", stdout) ; CNPrintRect(view.frame) ;
	fputs(" b", stdout) ; CNPrintRect(view.frame) ;
	
	printf("*1:%s ", y_or_n([view translatesAutoresizingMaskIntoConstraints])) ;
	putc('\n', stdout) ;
}

@end

void
KCPrintView(KCView * view)
{
	KCViewPrinter * printer = [[KCViewPrinter alloc] init] ;
	KCPrintParameter * parameter = [[KCPrintParameter alloc] init] ;
	[view acceptViewVisitor: printer withParameter: parameter] ;
}
