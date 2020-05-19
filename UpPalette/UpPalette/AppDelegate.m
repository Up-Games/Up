//
//  AppDelegate.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

NSString *const PrimaryFillKey = @"PrimaryFill";
NSString *const InactiveFillKey = @"InactiveFill";
NSString *const ActiveFillKey = @"ActiveFill";
NSString *const HighlightedFillKey = @"HighlightedFill";
NSString *const SecondaryFillKey = @"SecondaryFill";
NSString *const SecondaryInactiveFillKey = @"SecondaryInactiveFill";
NSString *const SecondaryActiveFillKey = @"SecondaryActiveFill";
NSString *const SecondaryHighlightedFillKey = @"SecondaryHighlightedFill";
NSString *const PrimaryStrokeKey = @"PrimaryStroke";
NSString *const InactiveStrokeKey = @"InactiveStroke";
NSString *const ActiveStrokeKey = @"ActiveStroke";
NSString *const HighlightedStrokeKey = @"HighlightedStroke";
NSString *const SecondaryStrokeKey = @"SecondaryStroke";
NSString *const SecondaryInactiveStrokeKey = @"SecondaryInactiveStroke";
NSString *const SecondaryActiveStrokeKey = @"SecondaryActiveStroke";
NSString *const SecondaryHighlightedStrokeKey = @"SecondaryHighlightedStroke";
NSString *const ContentKey = @"Content";
NSString *const InactiveContentKey = @"InactiveContent";
NSString *const ActiveContentKey = @"ActiveContent";
NSString *const HighlightedContentKey = @"HighlightedContent";
NSString *const InformationKey = @"Information";
NSString *const InfinityKey = @"Infinity";

NSString *const ColorThemeLightKey = @"Light";
NSString *const ColorThemeDarkKey = @"Dark";
NSString *const ColorThemeLightStarkKey = @"LightStark";
NSString *const ColorThemeDarkStarkKey = @"DarkStark";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[ViewController instance] saveColorMap];
}


@end
