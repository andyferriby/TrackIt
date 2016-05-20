//
//  AppDelegate.m
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "AppDelegate.h"
#import "ContainerViewController.h"
#import "WatchSessionDelegate.h"
#import "TrackIt-Swift.h"

@interface AppDelegate ()

@property (strong, nonatomic) EntriesModel *watchModel;
@property (strong, nonatomic) WatchSessionDelegate *watchDelegate;

@end

@implementation AppDelegate

-(EntriesModel *)watchModel {
    if(!_watchModel) {
        DateFilter *filter = [[DateFilter alloc] initWithType:DateFilterTypeLast7Days];
        _watchModel = [[EntriesModel alloc] initWithFilters:@[filter] coreDataManager:[CoreDataStackManager sharedInstance]];
        
    }
    return _watchModel;
}

-(NSManagedObjectContext *)managedObjectContext {
    return [CoreDataStackManager sharedInstance].managedObjectContext;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIColor *moneyColor = [ColorManager moneyColor];
    UIFont *lightFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:19.0];
    UIFont *lightFontSmall = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    self.window.tintColor = moneyColor;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : moneyColor, NSFontAttributeName : lightFont}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : moneyColor, NSFontAttributeName : lightFontSmall} forState:UIControlStateNormal];
    
    // Watch Connectivity
    
    if([WCSession isSupported]) {
        self.watchDelegate = [WatchSessionDelegate new];
        WCSession *session = [WCSession defaultSession];
        session.delegate = self.watchDelegate;
        [session activateSession];
    }
    
    return YES;
}

-(void)sendNewTotalToWatch {
    if([WCSession isSupported]) {
        [self.watchModel refreshEntries];
        [self.watchDelegate sendTotalToWatch:[self.watchModel totalSpending]];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if([WCSession isSupported]) {
        [self.watchModel refreshEntries];
        [self.watchDelegate sendTotalToWatch:[self.watchModel totalSpending]];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - 3D Touch Quick Action

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if([shortcutItem.type isEqualToString:@"Add"]) {
        UINavigationController *navVC = (UINavigationController *)self.window.rootViewController;
        ContainerViewController *rootVC = (ContainerViewController *)navVC.topViewController;
        if(!rootVC.presentedViewController) {
            [rootVC performSegueWithIdentifier:@"addEntrySegue" sender:nil];
        }
        
    }
}

@end
