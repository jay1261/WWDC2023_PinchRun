//
//  Constants.swift
//  PinchGame
//
//  Created by Jay on 2023/04/16.
//

import Foundation
import SwiftUI


struct PhysicsCategory {
    static let cat: UInt32 = 0x1 << 0  // 1
    static let land: UInt32 = 0x1 << 1  // 2
    static let obstacle: UInt32 = 0x1 << 2  // 4
    static let score: UInt32 = 0x1 << 3 // 8
}

struct K {
    static var gameLevel: Int = 1  // 1, 2, 3
}
