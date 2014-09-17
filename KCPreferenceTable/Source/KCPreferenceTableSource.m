/**
 * @file	KCPreferenceTableSource.m
 * @brief	Define KCPreferenceTableSource class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCPreferenceTableSource.h"
#import "KCPreferenceTableCell.h"
#import <KiwiControl/KiwiControl.h>

/*
 +- Application version
 |  +- Build id
 |
 +- Copyright
 |  +- Producer
 |  |
 |  +- Copyright
 |
 
 */

enum KCPreferenceTableSection {
	KCApplicationVersionSection,
	KCCopyrightSection,
	KCManualSection,
	KCSourceCodeSection
} ;

#define KCNumberOfTableSections		4

@interface KCPreferenceTableSource (Private)
- (NSString *) selectContextByIndexPath: (NSIndexPath *) indexpath ;
- (CGSize) adjustSize: (NSString *) title ;
@end

@implementation KCPreferenceTableSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return KCNumberOfTableSections ;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rownum = 0 ;
	switch(section){
		case KCApplicationVersionSection: {
			rownum = 2 ;
		} break ;
		case KCCopyrightSection: {
			rownum = 2 ;
		} break ;
		case KCManualSection: {
			rownum = 1 ;
		} break ;
		case KCSourceCodeSection: {
			rownum = 1 ;
		} break ;
	}
	return rownum ;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	//KCPreference * preferennce = [KCPreference sharedPreference] ;
	NSString * title ;
	switch(section){
		case KCApplicationVersionSection: {
			title = @"Application"; // [preferennce applicationName] ;
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
	static BOOL s_is1st = YES ;
	if(s_is1st){
		UINib *nib = [UINib nibWithNibName: @"KCPreferenceTableCell" bundle:nil];
		[tableView registerNib:nib forCellReuseIdentifier: @"CustomCell"];
		s_is1st = NO ;
	}
	
	/* Set index */
	NSUInteger index = [indexPath row] ;
	KCPreferenceTableCell * newcell = [tableView dequeueReusableCellWithIdentifier: @"CustomCell"];
	newcell.contentLabel.tag = index ;
	
	/* Set title */
	newcell.contentLabel.text = [self selectContextByIndexPath: indexPath] ;
	
	/* Resize */
	CGSize newsize = [self adjustSize: newcell.contentLabel.text] ;
	KCUpdateViewSize(newcell.contentLabel, newsize) ;
	[newcell.contentView sizeToFit] ;
	
	return newcell ;
}

- (CGFloat)tableView: (UITableView *) tableView heightForHeaderInSection: (NSInteger)section
{
	return 28.0 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0.0 ;
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
			result = [[NSString alloc] initWithFormat: @"%@ (%@)", ver, bid] ;
		} break ;
		case KCCopyrightSection: {
			result = @"GPL" ;
		} break ;
		case KCManualSection: {
			result = @"Manual" ;
		} break ;
		case KCSourceCodeSection: {
			result = @"Code" ;
		} break ;
	}
	return result ;
}

- (CGSize) adjustSize: (NSString *) title
{
	CGSize		maxSize = CGSizeMake(200, CGFLOAT_MAX);
	NSDictionary *	attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize: 15.0]};
	CGRect newbounds = [title boundingRectWithSize:maxSize
					       options:NSStringDrawingUsesLineFragmentOrigin
					    attributes:attr
					       context:nil] ;
	CGSize result = CGSizeMake(ceilf(newbounds.size.width) + 8.0,
				   ceilf(newbounds.size.height) + 8.0) ;
	return result  ;
}

@end

