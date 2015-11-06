//
//  ExtensionDelegate.h
//  WatchTrack Extension
//
//  Created by Jason Ji on 11/4/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import "WatchSessionDelegate.h"

@interface ExtensionDelegate : NSObject <WKExtensionDelegate>

@property (strong, nonatomic) WatchSessionDelegate *watchDelegate;

@end
