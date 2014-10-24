/**
 * @file	KCPreferenceTableSource.m
 * @brief	Define KCPreferenceTableSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCPreferenceTableSource.h"
#import "KCPreferenceTableCell.h"
#import <KiwiControl/KiwiControl.h>

enum KCPreferenceTableSection {
	KCApplicationVersionSection	= 0,
	KCDeveloperSection		= 1,
	KCCopyrightSection		= 2,
	KCManualSection			= 3,
	KCSourceCodeSection		= 4
} ;

#define KCNumberOfTableSections		5

@interface KCPreferenceTableSource (Private)
- (NSString *) selectContextByIndexPath: (NSIndexPath *) indexpath ;
- (CGSize) adjustSize: (NSString *) title ;
@end

@implementation KCPreferenceTableSource

- (instancetype) init
{
	if((self = [super init]) != nil){
		didNibPrepared = NO ;
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
		case KCCopyrightSection: {
			title = @"Copyright" ;
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

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	if(didNibPrepared == NO){
		UINib *nib = [UINib nibWithNibName: @"KCPreferenceTableCell" bundle:nil];
		[tableView registerNib:nib forCellReuseIdentifier: @"CustomCell"];
		didNibPrepared = YES ;
	}
	
	/* Allocate cell */
	KCPreferenceTableCell * newcell = [tableView dequeueReusableCellWithIdentifier: @"CustomCell"];
	
	/* Set title */
	NSString * title = [self selectContextByIndexPath: indexPath] ;
	newcell.textView.text = title ;
	newcell.textView.editable = false ;
	newcell.textView.dataDetectorTypes = UIDataDetectorTypeAll;
	
	/* Resize */
	CGSize newsize = [self adjustSize: title] ;
	KCUpdateViewSize(newcell.textView, newsize) ;
	[newcell.contentView sizeToFit] ;
	
	return newcell ;
}

- (CGFloat)tableView: (UITableView *) tableView heightForHeaderInSection: (NSInteger)section
{
	((void) tableView) ; ((void) section) ;
	return 28.0 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	((void) tableView) ; ((void) section) ;
	return 0.1 ;
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
		case KCCopyrightSection: {
			NSString * name = [preferennce copyrightName] ;
			NSString * url  = [preferennce copyrightURL] ;
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

- (CGSize) adjustSize: (NSString *) title
{
	CGSize		maxSize = CGSizeMake(600, CGFLOAT_MAX);
	NSDictionary *	attr = @{NSFontAttributeName: [UIFont systemFontOfSize: 14.0]};
	CGRect newbounds = [title boundingRectWithSize:maxSize
					       options:NSStringDrawingUsesLineFragmentOrigin
					    attributes:attr
					       context:nil] ;
	CGSize result = CGSizeMake(ceilf(newbounds.size.width  + 16.0),
				   ceilf(newbounds.size.height + 16.0)) ;
	return result  ;
}

@end

