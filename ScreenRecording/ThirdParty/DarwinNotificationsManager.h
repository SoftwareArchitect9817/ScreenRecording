//
//  DarwinNotificationsManager.h
//  ScreenRecording
//
//  Created by Zhang Xiqian on 2020/7/29.
//  Copyright © 2020 RUBY MAE Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef DarwinNotifications_h
#define DarwinNotifications_h
@interface DarwinNotificationsManager : NSObject
@property (strong, nonatomic) id someProperty;
+ (instancetype)sharedInstance;
- (void)registerForNotificationName:(NSString *)name callback:(void (^)(void))callback;
- (void)postNotificationWithName:(NSString *)name;
@end
#endif
