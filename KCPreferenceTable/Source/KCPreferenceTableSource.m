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
	KCCopyrightSection		= 1,
	KCManualSection			= 2,
	KCSourceCodeSection		= 3
} ;

enum KCApplicationVersions {
	KCApplicationName		= 0,
	KCApplicationVersion		= 1
} ;

enum KCCopyrights {
	KCCopyright			= 0
} ;

enum KCManuals {
	KCManual			= 0
} ;

enum KCSourceCodes {
	KCSourceCode			= 0
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
			rownum = KCApplicationVersion + 1 ;
		} break ;
		case KCCopyrightSection: {
			rownum = KCCopyright + 1 ;
		} break ;
		case KCManualSection: {
			rownum = KCManual + 1 ;
		} break ;
		case KCSourceCodeSection: {
			rownum = KCSourceCode + 1 ;
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
			switch((enum KCApplicationVersions) indexpath.row){
				case KCApplicationName: {
					result = [preferennce applicationName] ;
				} break ;
				case KCApplicationVersion: {
					NSString * ver = [preferennce version] ;
					NSString * bid = [preferennce buildId] ;
					result = [[NSString alloc] initWithFormat: @"Version %@ (Build %@)", ver, bid] ;
				} break ;
			}
		} break ;
		case KCCopyrightSection: {
			switch((enum KCCopyrights) indexpath.row){
				case KCCopyright: {
					result = @"GNU General Public License 2.0\nhttp://www.gnu.org/licenses/gpl-2.0.html" ;
				} break ;
			}
		} break ;
		case KCManualSection: {
			switch((enum KCManuals) indexpath.row){
				case KCManual: {
					NSString * appname = [preferennce applicationName] ;
					result = [[NSString alloc] initWithFormat: @"%@ Online Manual", appname] ;
				} break ;
			}
		} break ;
		case KCSourceCodeSection: {
			switch((enum KCSourceCodes) indexpath.row){
				case KCSourceCode: {
					result = @"Code" ;
				} break ;
			}
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
	CGSize result = CGSizeMake(ceilf(newbounds.size.width)  + 16.0,
				   ceilf(newbounds.size.height) + 16.0) ;
	return result  ;
}

@end

