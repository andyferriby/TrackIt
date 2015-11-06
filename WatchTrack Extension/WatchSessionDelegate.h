//
//  WatchSessionDelegate.h
//  TrackIt
//
//  Created by Jason Ji on 11/5/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WatchConnectivity;

@interface WatchSessionDelegate : NSObject<WCSessionDelegate>

@property (strong, nonatomic) WCSession *session;
-(void)requestTotalFromiPhoneWithCompletion:(void (^)(NSNumber *total, NSError *error))completionHandler;

@end
