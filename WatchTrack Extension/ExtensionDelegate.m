//
//  ExtensionDelegate.m
//  WatchTrack Extension
//
//  Created by Jason Ji on 11/4/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "ExtensionDelegate.h"

@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching {
    // Perform any final initialization of your application.
    
    self.watchDelegate = [WatchSessionDelegate new];
    
    if([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self.watchDelegate;
        [session activateSession];
        
        [self.watchDelegate requestTotalFromiPhoneWithCompletion:^(NSNumber *total, NSError *error) {
            if(error) {
            }
            else {
                [[NSUserDefaults standardUserDefaults] setValue:total forKey:@"TotalSpending"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.jyjapps.trackit"];
    [defaults registerDefaults:@{@"quickNote" : @"Lunch", @"quickNote2" : @"Dinner", @"quickNote3" : @"Haircut"}];
    [defaults synchronize];
}

- (void)applicationDidBecomeActive {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillResignActive {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
}

@end
