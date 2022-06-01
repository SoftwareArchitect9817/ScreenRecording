//
//  ESPThread.h
//  ScreenRecording
//
//  Created by Zhang Xiqian on 2020/7/29.
//  Copyright © 2020 RUBY MAE Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESPThread : NSObject

+ (ESPThread *)currentThread;

- (BOOL)sleep:(long long)milliseconds;

- (void)interrupt;

- (BOOL)isInterrupt;


@end

NS_ASSUME_NONNULL_END

