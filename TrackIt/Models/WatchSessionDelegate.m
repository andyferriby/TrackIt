//
//  WatchSessionDelegate.m
//  TrackIt
//
//  Created by Jason Ji on 11/5/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "WatchSessionDelegate.h"
#import "EntriesModel.h"

@implementation WatchSessionDelegate

-(void)sendTotalToWatch:(NSNumber *)total {
    NSError *error;
    WCSession *session = [WCSession defaultSession];
    if(session.isPaired && session.isWatchAppInstalled) {
        [session updateApplicationContext:@{@"total" : total} error:&error];
        if(error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }
}

#pragma mark - WCSessionDelegate

-(void)sessionWatchStateDidChange:(WCSession *)session {
    
}

-(void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo {
    
}

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    if([message[@"request"] isEqualToString:@"total"]) {
        EntriesModel *model = [[EntriesModel alloc] initWithTimePeriod:@7];
        [model refreshEntries];
        replyHandler(@{@"total" : [model totalSpending]});
    }
}

@end
