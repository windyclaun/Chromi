//
//  LevelNode.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 15/07/26.
//

import SwiftUI

struct LevelNode: Identifiable, Equatable {
    let id: Int
    let title: String
    let isUnlocked: Bool
    let mapPosition: CGPoint

    static let previewLevels: [LevelNode] = [
        LevelNode(id: 1, title: "Lemon Land", isUnlocked: true, mapPosition: CGPoint(x: 0.08, y: 0.63)),
        LevelNode(id: 2, title: "Orange Isle", isUnlocked: true, mapPosition: CGPoint(x: 0.14, y: 0.42)),
        LevelNode(id: 3, title: "Apple Peak", isUnlocked: true, mapPosition: CGPoint(x: 0.22, y: 0.70)),
        LevelNode(id: 4, title: "Grape Grove", isUnlocked: true, mapPosition: CGPoint(x: 0.32, y: 0.46)),
        LevelNode(id: 5, title: "Berry Bay", isUnlocked: true, mapPosition: CGPoint(x: 0.45, y: 0.65)),
        LevelNode(id: 6, title: "Peach Point", isUnlocked: true, mapPosition: CGPoint(x: 0.53, y: 0.42)),
        LevelNode(id: 7, title: "Kiwi Keep", isUnlocked: true, mapPosition: CGPoint(x: 0.64, y: 0.56)),
        LevelNode(id: 8, title: "Cherry Cliff", isUnlocked: false, mapPosition: CGPoint(x: 0.74, y: 0.74)),
        LevelNode(id: 9, title: "Mango Meadow", isUnlocked: false, mapPosition: CGPoint(x: 0.84, y: 0.40)),
        LevelNode(id: 10, title: "Plum Plateau", isUnlocked: false, mapPosition: CGPoint(x: 0.94, y: 0.57))
    ]
}
