//
//  VSThemeLoader.m
//  Q Branch LLC
//
//  Created by Brent Simmons on 6/26/13.
//  Copyright (c) 2012 Q Branch LLC. All rights reserved.
//

#import "VSThemeLoader.h"
#import "VSTheme.h"


@interface VSThemeLoader ()

@property (nonatomic, strong, readwrite) VSTheme *defaultTheme;
@property (nonatomic, strong, readwrite) NSArray *themes;
@end


@implementation VSThemeLoader


- (id)init {
    NSURL * themesURL =[[NSBundle mainBundle] URLForResource:@"DB5" withExtension:@"plist"];
    return [self initWithURL:themesURL];
}

- (id) initWithURL:(NSURL *) url {
    self = [super init];
    if (self == nil)
        return nil;
    
	NSDictionary *themesDictionary = [NSDictionary dictionaryWithContentsOfURL:url];
	
	NSMutableArray *themes = [NSMutableArray array];
	for (NSString *oneKey in themesDictionary) {
		
		VSTheme *theme = [[VSTheme alloc] initWithDictionary:themesDictionary[oneKey]];
		if ([[oneKey lowercaseString] isEqualToString:@"default"])
			_defaultTheme = theme;
		theme.name = oneKey;
		[themes addObject:theme];
	}
    
    for (VSTheme *oneTheme in themes) { /*All themes inherit from the default theme.*/
		if (oneTheme != _defaultTheme)
			oneTheme.parentTheme = _defaultTheme;
    }
    
	_themes = themes;
    
    return self;
}


- (VSTheme *)themeNamed:(NSString *)themeName {

	for (VSTheme *oneTheme in self.themes) {
		if ([themeName isEqualToString:oneTheme.name])
			return oneTheme;
	}

	return nil;
}

@end

