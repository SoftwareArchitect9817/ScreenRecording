//
//  CMNotificatioin.swift
//  ScreenRecording
//
//  Created by Zhang Xiqian on 2020/7/29.
//  Copyright © 2020 RUBY MAE Brown. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    public struct CMNotificationName {
        public static let uploadVideoSuccess = Notification.Name(rawValue: "uploadVideoSuccess")
    }
    
}

extension CFNotificationName {
    public static let uploadVideoSuccess = CFNotificationName.init("uploadVideoSuccess" as CFString)
}
