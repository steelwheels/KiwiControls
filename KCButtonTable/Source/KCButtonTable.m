/**
 * @file	KCButtonTable.m
 * @brief	Define KCButtonTable class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCButtonTable.h"

@implementation KCButtonTable

- (instancetype) init
{
	if((self = [super init]) != nil){
		backgroundView = [[KCButtonTableBackground alloc] initWithDelegate: self] ;
		buttonTableView = [[KCButtonTableView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)] ;
		[backgroundView addSubview: buttonTableView] ;
	}
	return self ;
}

- (void) buttonPressed: (NSUInteger) index
{
	[buttonTableDelegate buttonPressed: index] ;
	[backgroundView removeFromSuperview] ;
}

- (void) touchBackground
{
	[backgroundView removeFromSuperview] ;
}

- (void) displayButtonTableWithLabelNames: (NSArray *) names
			     withDelegate: (id <KCButtonTableDelegate>) delegate
			       withOrigin: (CGPoint) origin
			 atViewController: (UIViewController *) controller
{
	buttonTableDelegate = delegate ;
	
	/* Adjust size */
	[buttonTableView setDelegate: self] ;
	[buttonTableView setLabelNames: names] ;
	[buttonTableView setBorder] ;
	[buttonTableView adjustSize] ;
	
	/* Adjust origin */
	CGSize entiresize = controller.view.frame.size ;
	CGSize tablesize  = buttonTableView.frame.size ;
	CGFloat adjx, adjy ;
	if(origin.x + tablesize.width > entiresize.width){
		adjx = origin.x - (origin.x + tablesize.width - entiresize.width) ;
	} else {
		adjx = origin.x ;
	}
	if(origin.y + tablesize.height > entiresize.height){
		adjy = origin.y - (origin.y + tablesize.height - entiresize.height) ;
	} else {
		adjy = origin.y ;
	}
	CGPoint adjorigin = {.x=adjx, .y=adjy} ;
	
	/* Adjust origin */
	KCUpdateViewOrigin(buttonTableView, adjorigin) ;
	
	/* Add background into main window */
	[controller.view addSubview: backgroundView] ;
}

@end


#if 0
/** Reference: http://idea-cloud.com/dev/addsubview_modal.html */
- (void)modalOpen {
	//モーダル背景の生成
	_modalBg =[[UIView alloc] initWithFrame:CGRectMake(0,0,320,720)];
	_modalBg.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.3];
	[self.view addSubview:_modalBg];
	
	// モーダルウインドウの生成
	UIView *titleBg =[[UIView alloc] initWithFrame:CGRectMake(20,200,280,100)];
	titleBg.backgroundColor =  [UIColor colorWithWhite:1 alpha:1];
	
	
	[titleBg setAlpha:0.0];
	titleBg.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
	
	// アニメーション
	[UIView beginAnimations:nil context:NULL];
	// 秒数設定
	[UIView setAnimationDuration:0.4];
	[titleBg setAlpha:1];
	
	titleBg.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
	[_modalBg addSubview:titleBg];
	[UIView commitAnimations];
	
	//ラベルを生成
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.frame = CGRectMake(0, 20, 280, 25);
	titleLabel.text = @"モーダルウインドウを表示";
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed:0.238 green:0.501 blue:0.593 alpha:1.000];
	titleLabel.font = [UIFont boldSystemFontOfSize:13];
	
	
	[titleBg addSubview:titleLabel];
	UIButton* noButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	noButton.frame = CGRectMake(0,55,280,30);
	[noButton setTitle:@"モーダルを閉じる" forState:UIControlStateNormal];
	
	noButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[noButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
	noButton.tintColor = [UIColor colorWithRed:0.238 green:0.501 blue:0.593 alpha:1.000];
	
	// ボタンの動作
	[noButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
	
	// 作成
	[titleBg addSubview:noButton];
	
}
- (void)close:(id)sender {
	//モーダルを閉じる
	[_modalBg removeFromSuperview];
}
#endif

