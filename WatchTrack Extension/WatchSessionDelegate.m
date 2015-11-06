//
//  WatchSessionDelegate.m
//  TrackIt
//
//  Created by Jason Ji on 11/5/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "WatchSessionDelegate.h"
#import "ExtensionDelegate.h"

@implementation WatchSessionDelegate

#pragma mark - WCSessionDelegate

-(void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext {
    NSNumber *total = applicationContext[@"total"];
    NSLog(@"%@", total);
    
    [[NSUserDefaults standardUserDefaults] setValue:total forKey:@"TotalSpending"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewTotalReceived" object:self userInfo:applicationContext];
}

@end
