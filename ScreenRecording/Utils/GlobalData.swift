//
//  GlobalData.swift
//  VaultApp
//
//  Created by Zheng Cheng on 4/20/18.
//  Copyright © 2018 Zheng Cheng. All rights reserved.
//

import Foundation

class GlobalData {    
    static var frameArray = [UIImage]()
    static var seconds_per_frame = 1
    static var filePath  = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.cybertonic.FavSearch")!.path + "/Library/Caches/temp.mp4"
}
