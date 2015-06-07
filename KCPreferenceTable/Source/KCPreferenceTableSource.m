/**
 * @file	KCPreferenceTableSource.m
 * @brief	Define KCPreferenceTableSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCPreferenceTableSource.h"
#import <KiwiControl/KiwiControl.h>

enum KCPreferenceTableSection {
	KCApplicationVersionSection	= 0,
	KCDeveloperSection		= 1,
	KCLicenseSection		= 2,
	KCManualSection			= 3,
	KCSourceCodeSection		= 4
} ;

#define KCNumberOfTableSections		5

@interface KCPreferenceTableSource (Private)
- (NSString *) selectContextByIndexPath: (NSIndexPath *) indexpath ;
@end

static UITextView *
textViewInTableCell(UITableViewCell * cell) ;

@implementation KCPreferenceTableSource

- (instancetype) init
{
	if((self = [super initWithNibName: @"KCPreferenceTableCell"]) != nil){
		//
	}
	return self ;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	((void) tableView) ;
	return KCNumberOfTableSections ;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	((void) tableView) ; ((void) section) ;
	return 1 ;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	((void) tableView) ;
	
	//KCPreference * preferennce = [KCPreference sharedPreference] ;
	NSString * title ;
	switch(section){
		case KCApplicationVersionSection: {
			title = @"Application"; // [preferennce applicationName] ;
		} break ;
		case KCDeveloperSection: {
			title = @"Developer" ;
		} break ;
		case KCLicenseSection: {
			title = @"License" ;
		} break ;
		case KCManualSection: {
			title = @"Manual" ;
		} break ;
		case KCSourceCodeSection: {
			title = @"Source code" ;
		} break ;
	}
	return title ;
}

- (UITableViewCell *) tableView: (UITableView *) tableview cellForRowAtIndexPath: (NSIndexPath *) indexpath
{
	UITableViewCell * newcell = [super tableView: tableview cellForRowAtIndexPath: indexpath] ;
	if([newcell isKindOfClass: [UITableViewCell class]]){
		NSString * text = [self selectContextByIndexPath: indexpath] ;
		UITextView * textview = textViewInTableCell(newcell) ;
		if(textview){
			textview.dataDetectorTypes = UIDataDetectorTypeLink ;
			textview.editable = NO ;
			
			KCPreference * pref = [KCPreference sharedPreference] ;
			
			UIColor * forecolor = [pref color: @"ForegroundColor"] ;
			if(forecolor == nil){
				forecolor = [UIColor blackColor];
			}
			UIColor * backcolor = [pref color: @"BackgroundColor"] ;
			if(backcolor == nil){
				backcolor = [UIColor whiteColor] ;
			}
			UIFont * font = [UIFont systemFontOfSize: 14.0] ;
			
			NSDictionary * attributes = @{NSFontAttributeName:		font,
						      NSForegroundColorAttributeName:	forecolor,
						      NSBackgroundColorAttributeName:	backcolor
						      };
			NSAttributedString * attrtext ;
			attrtext = [[NSAttributedString alloc] initWithString: text
								   attributes: attributes];
			textview.attributedText = attrtext ;
			textview.backgroundColor = backcolor ;
			
			CGSize cellsize  = newcell.frame.size ;
			CGSize checkSize = CGSizeMake(cellsize.width, 400) ;
			CGRect textframe = [attrtext boundingRectWithSize: checkSize
								  options: NSStringDrawingUsesLineFragmentOrigin
								  context: nil];
			textview.frame = textframe;
		} else {
			NSLog(@"No text view in cell") ;
		}
	} else {
		NSLog(@"Invalid cell class") ;
	}
	return newcell ;
}

@end

@implementation KCPreferenceTableSource (Private)

- (NSString *) selectContextByIndexPath: (NSIndexPath *) indexpath
{
	KCPreference * preferennce = [KCPreference sharedPreference] ;
	
	NSString * result = @"?" ;
	switch((enum KCPreferenceTableSection) indexpath.section){
		case KCApplicationVersionSection: {
			NSString * ver = [preferennce version] ;
			NSString * bid = [preferennce buildId] ;
			result = [[NSString alloc] initWithFormat: @"Version %@ (Build %@)", ver, bid] ;
		} break ;
		case KCDeveloperSection: {
			NSString * name = [preferennce developerName] ;
			NSString * url  = [preferennce developerURL] ;
			result = [[NSString alloc] initWithFormat: @"%@\n%@", name, url] ;
		} break ;
		case KCLicenseSection: {
			NSString * name = [preferennce licenseName] ;
			NSString * url  = [preferennce licenseURL] ;
			result = [[NSString alloc] initWithFormat: @"%@\n%@", name, url] ;
		} break ;
		case KCManualSection: {
			result = [preferennce manualURL] ;
		} break ;
		case KCSourceCodeSection: {
			result = [preferennce sourceCodeURL] ;
		} break ;
	}
	return result ;
}

@end

static UITextView *
textViewInTableCell(UITableViewCell * cell)
{
	UITextView * textview = nil ;
	NSArray * subviews = [cell.contentView subviews] ;
	for(UIView * view in subviews){
		if([view isKindOfClass: [UITextView class]]){
			textview = (UITextView *) view ;
			break ;
		}
	}
	return textview ;
}

