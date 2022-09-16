//
//  ActivityAttributes.swift
//  LiveActivity-iOS16
//
//  Created by LiYanan2004 on 2022/8/2.
//

import ActivityKit
import Foundation

struct ActivityAttribute: ActivityAttributes {
    struct ContentState: Hashable, Codable {
        var time = Date.now
        var count = 0
    }
}
