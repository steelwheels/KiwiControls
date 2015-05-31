/**
 * @file	KCPreference.h
 * @brief	Define KCPreference class
 * @par Copyright
 *   Copyright (C) 2014 Steel Wheels Project
 */

#import "KCPreference.h"
#import "KCType.h"

#if TARGET_OS_IPHONE
#	define KCColor		UIColor
#	define KCFont		UIFont
#else /* TARGET_OS_IPHONE */
#	define KCColor		NSColor
#	define KCFont		NSFont
#endif /* TARGET_OS_IPHONE */

static NSUserDefaults * readApplicationDefaults(void) ;
static NSString *	getStringValueInStandardUserDefaults(NSUserDefaults * defaults, NSString * key) ;
static KCColor *	getColorInStandardUserDefaults(NSUserDefaults * defaults, NSString * key) ;
static void		dumpStringToFile(FILE * outfp, const char * name, NSString * data) ;
static void		dumpColorToFile(FILE * outfp, NSString * name, KCColor * data) ;

@implementation KCPreference

+ (KCPreference *) sharedPreference
{
	static KCPreference * sharedPreference = nil ;
	static dispatch_once_t once;
	dispatch_once( &once, ^{
		sharedPreference = [[KCPreference alloc] init] ;
	});
	return sharedPreference ;
}

- (instancetype) init
{
	if((self = [super init]) != nil){
		applicationDefaults = readApplicationDefaults() ;
		
		defaultFont	= [KCFont systemFontOfSize: 22.0] ;
		boldFont	= [KCFont boldSystemFontOfSize: 22.0] ;
		
		colorDictionary = [[NSMutableDictionary alloc] initWithCapacity: 8] ;
	}
	return self ;
}

- (NSString *) applicationName
{
	NSString * apppath = [[NSBundle mainBundle] bundlePath] ;
	NSString * filename = [apppath lastPathComponent] ;
	return [filename stringByDeletingPathExtension] ;
}

- (NSString *) version
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *) buildId
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSString *) developerName
{
	return getStringValueInStandardUserDefaults(applicationDefaults, @"DeveloperName") ;
}

- (NSString *) developerURL
{
	return getStringValueInStandardUserDefaults(applicationDefaults, @"DeveloperURL") ;
}

- (NSString *) licenseName
{
	return getStringValueInStandardUserDefaults(applicationDefaults, @"LicenseName") ;
}

- (NSString *) licenseURL
{
	return getStringValueInStandardUserDefaults(applicationDefaults, @"LicenseURL") ;
}

- (NSString *) sourceCodeURL
{
	return getStringValueInStandardUserDefaults(applicationDefaults, @"SourceCodeURL") ;
}

- (NSString *) manualURL
{
	return getStringValueInStandardUserDefaults(applicationDefaults, @"ManualURL") ;
}

#if TARGET_OS_IPHONE
- (CGRect) applicationFrame
{
	return [[UIScreen mainScreen] applicationFrame] ;
}
#endif /* TARGET_OS_IPHONE */

- (KCFont *) defaultFont
{
	return defaultFont ;
}

- (KCFont *) boldFont
{
	return boldFont ;
}

- (KCColor *) applicationColor: (NSString *) name
{
	KCColor * color = [colorDictionary valueForKey: name] ;
	if(color == nil){
		color = getColorInStandardUserDefaults(applicationDefaults, name) ;
		if(color != nil){
			[colorDictionary setObject: color forKey: name] ;
		}
	} else {
		if(![color isKindOfClass: [KCColor class]]){
			NSLog(@"Invalid color object") ;
			color = nil ;
		}
	}
	return color ;
}

- (void) dumpToFile: (FILE *) outfp
{
	dumpStringToFile(outfp, "application", [self applicationName]) ;
	dumpStringToFile(outfp, "version", [self version]) ;
	dumpStringToFile(outfp, "buildId", [self buildId]) ;
	dumpStringToFile(outfp, "developerName", [self developerName]) ;
	dumpStringToFile(outfp, "developerURL", [self developerURL]) ;
	
	for(NSString * colname in [colorDictionary allKeys]){
		KCColor * color = [colorDictionary valueForKey: colname] ;
		dumpColorToFile(outfp, colname, color) ;
	}
}

@end

static NSUserDefaults *
readApplicationDefaults(void)
{
	NSBundle * mainbundle = [NSBundle mainBundle];
	NSString* filepath  = [mainbundle pathForResource:@"AppDefaults" ofType:@"plist"];
	NSDictionary * userdict = [NSDictionary dictionaryWithContentsOfFile: filepath];
	if(userdict){
		NSUserDefaults * userdef = [NSUserDefaults standardUserDefaults] ;
		[userdef registerDefaults: userdict];
		[userdef synchronize];
	}
	return [NSUserDefaults standardUserDefaults] ;
}

static NSString *
getStringValueInStandardUserDefaults(NSUserDefaults * defaults, NSString * key)
{
	NSString * value = [defaults stringForKey: key] ;
	return value ? value : @"" ;
}

static KCColor *
getColorInStandardUserDefaults(NSUserDefaults * defaults, NSString * key)
{
	KCColor * result = nil ;
	NSString * colname = getStringValueInStandardUserDefaults(defaults, key) ;
	if(colname.length > 0){
		struct CNRGB rgb ;
		CNColorNameTable * ntable = [CNColorNameTable sharedColorNameTable] ;
		if([ntable getColor: &rgb byName: colname]){
			result = CNRGBtoColor(rgb) ;
		}
	}
	return result ;
}

static void
dumpStringToFile(FILE * outfp, const char * name, NSString * data)
{
	const char * cdata = data ? [data UTF8String] : "<nil>" ;
	fprintf(outfp, "%s : \"%s\"\n", name, cdata) ;
}

static void
dumpColorToFile(FILE * outfp, NSString * name, KCColor * data)
{
	dumpStringToFile(outfp, [name UTF8String], [data description]) ;
}

