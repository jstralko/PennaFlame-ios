//
//  PFAppDelegate.m
//  PennaFlame
//
//  Created by Gerald Stralko on 10/6/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFAppDelegate.h"
#import "PFHomeViewController.h"
#import "PFMetricViewController.h"
#import "PFMathConverterViewController.h"
#import "PFChartViewController.h"
#import "PFFullChartViewController.h"
#import "PFMTIViewController.h"
#import "PFContactInfoViewController.h"

@implementation PFAppDelegate

@synthesize hardnessCaseDepthChartDict;
@synthesize hardnessChartDict;
@synthesize hardnessChartSortedKeys;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HardnessCaseDepth" ofType:@"plist"];
    hardnessCaseDepthChartDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    plistPath = [[NSBundle mainBundle] pathForResource:@"HardnessChartData" ofType:@"plist"];
    hardnessChartDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSMutableArray *sortedKeys = [NSMutableArray array];
    [sortedKeys addObject:@"EQUO TIP Ld"];
    [sortedKeys addObject:@"ROCKWELL C HRC"];
    [sortedKeys addObject:@"BRINELL BHN"];
    [sortedKeys addObject:@"SHORE C HSc"];
    [sortedKeys addObject:@"SHORE C HFRSc"];
    [sortedKeys addObject:@"VICKERS HV/DPH"];
    hardnessChartSortedKeys = [[NSArray alloc] initWithArray:sortedKeys];
    
    //New UICollectionViewController - new and shiney!
    PFHomeViewController *home = [[PFHomeViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:home];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) tabBarButtonClicked:(id) sender fromIndex:(NSInteger) fromIndex toIndex:(NSInteger) toIndex {
    
    if (fromIndex == toIndex)
        return;
    
    switch (toIndex) {
        case 1: {
            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
            PFMetricViewController *metric = [[PFMetricViewController alloc] init];
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:metric animated:NO];
        }
            break;
        case 2: {
            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
            PFMathConverterViewController *math = [[PFMathConverterViewController alloc] init];
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:math animated:NO];
        }
            break;
        case 3: {
            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
            NSDictionary *chartDictionary = self.hardnessCaseDepthChartDict;
            PFFullChartViewController *fcvc = [[PFFullChartViewController alloc ] initWithDict:chartDictionary withTile:HARDNESS_CASE_DEPTH_TITLE];
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:fcvc animated:NO];
        }
            break;
        case 4: {
            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
            PFAppDelegate *appDelegate = (PFAppDelegate *)[UIApplication sharedApplication].delegate;
            PFChartViewController *pfhcvc = [[PFChartViewController alloc]initWithDict:appDelegate.hardnessChartDict withTitle:HARDNESS_CHART_TITLE];
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:pfhcvc animated:NO];
        }
            break;
        case 5: {
            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
            PFMTIViewController *pfmvc = [[PFMTIViewController alloc] init];
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:pfmvc animated:NO];
        }
            break;
        case 6: {
            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
            PFContactInfoViewController *pfci = [[PFContactInfoViewController alloc]init];
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:pfci animated:NO];
        }
            break;
            
        default:
            break;
    }
}

@end
