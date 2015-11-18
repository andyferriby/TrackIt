//
//  EntryDelegate.h
//  TrackIt
//
//  Created by Jason Ji on 11/17/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EntryDelegate <NSObject>

-(void)newEntryAdded:(NSNumber *)newTotal;
-(void)newEntryCanceled;

@end