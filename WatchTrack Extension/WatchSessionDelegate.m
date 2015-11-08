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

-(instancetype)init {
    self = [super init];
    if(self) {
        _session = [WCSession defaultSession];
    }
    return self;
}

-(void)requestTotalFromiPhoneWithCompletion:(void (^)(NSNumber * total, NSError *error))completionHandler {
    
    if(self.session.reachable) {
        [self.session sendMessage:@{@"request" : @"total"}
                     replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                         NSNumber *total = replyMessage[@"total"];
                         [[NSUserDefaults standardUserDefaults] setValue:total forKey:@"TotalSpending"];
                         if(completionHandler)
                             completionHandler(total, nil);
                     }
                     errorHandler:^(NSError * _Nonnull error) {
                         NSLog(@"%@", error.localizedDescription);
                         completionHandler(nil, error);
                     }];
    }
}

#pragma mark - WCSessionDelegate

-(void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext {
    NSNumber *total = applicationContext[@"total"];
    NSLog(@"%@", total);
    
    [[NSUserDefaults standardUserDefaults] setValue:total forKey:@"TotalSpending"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewTotalReceived" object:self userInfo:applicationContext];
}

-(void)sessionReachabilityDidChange:(WCSession *)session {
    if(session.reachable) {
        [self requestTotalFromiPhoneWithCompletion:^(NSNumber *total, NSError *error) {
            if(error) {
                
            }
            else {
                [[NSUserDefaults standardUserDefaults] setValue:total forKey:@"TotalSpending"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewTotalReceived" object:self userInfo:@{@"total" : total}];
            }
        }];
    }
}

@end
