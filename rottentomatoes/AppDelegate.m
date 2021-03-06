//
//  AppDelegate.m
//  rottentomatoes
//
//  Created by Palanisamy Kozhanthaiappan on 9/12/14.
//  Copyright (c) 2014 Palanisamy Kozhanthaiappan. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    /*UIColor *blueColor = [UIColor colorWithRed:0.345 green:0.522 blue:0.953 alpha:1];

    [[UINavigationBar appearance] setBarTintColor: blueColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];*/
    
    
    MoviesViewController *movieListVC= [[MoviesViewController alloc] init];
    movieListVC.dataUrl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=3aw6qppb5a4efy3mn9q5twth";
    
    
    UINavigationController *navMovieListVC = [[UINavigationController alloc] initWithRootViewController:movieListVC];
    navMovieListVC.tabBarItem.title = @"Movies";
    navMovieListVC.tabBarItem.image =  [UIImage imageNamed:@"movie"];

    
    
    MoviesViewController *dvdListVC = [[MoviesViewController alloc] init];
    dvdListVC.dataUrl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=3aw6qppb5a4efy3mn9q5twth";
    UINavigationController *navDvdListVC = [[UINavigationController alloc] initWithRootViewController:dvdListVC];
    navDvdListVC.tabBarItem.title = @"DVD";
    navDvdListVC.tabBarItem.image =  [UIImage imageNamed:@"dvd"];
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    NSArray* controllers = [NSArray arrayWithObjects: navMovieListVC, navDvdListVC, nil];
    tabBarController.viewControllers = controllers;
    
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
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

@end
