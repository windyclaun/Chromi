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
    let fruitIcon: String
    let isUnlocked: Bool
    let stars: Int
    let mapPosition: CGPoint

    static let previewLevels: [LevelNode] = [
        LevelNode(id: 1, title: "Lemon Land", fruitIcon: "lemon.fill", isUnlocked: true, stars: 3, mapPosition: CGPoint(x: 0.08, y: 0.63)),
        LevelNode(id: 2, title: "Orange Isle", fruitIcon: "circle.fill", isUnlocked: true, stars: 2, mapPosition: CGPoint(x: 0.14, y: 0.42)),
        LevelNode(id: 3, title: "Apple Peak", fruitIcon: "apple.logo", isUnlocked: false, stars: 0, mapPosition: CGPoint(x: 0.22, y: 0.70)),
        LevelNode(id: 4, title: "Grape Grove", fruitIcon: "drop.fill", isUnlocked: false, stars: 0, mapPosition: CGPoint(x: 0.32, y: 0.46)),
        LevelNode(id: 5, title: "Berry Bay", fruitIcon: "seal.fill", isUnlocked: false, stars: 0, mapPosition: CGPoint(x: 0.45, y: 0.65)),
        LevelNode(id: 6, title: "Peach Point", fruitIcon: "circle.fill", isUnlocked: false, stars: 0, mapPosition: CGPoint(x: 0.53, y: 0.42)),
        LevelNode(id: 7, title: "Kiwi Keep", fruitIcon: "circle.fill", isUnlocked: false, stars: 0, mapPosition: CGPoint(x: 0.64, y: 0.56)),
        LevelNode(id: 8, title: "Cherry Cliff", fruitIcon: "circle.fill", isUnlocked: false, stars: 0, mapPosition: CGPoint(x: 0.74, y: 0.74)),
        LevelNode(id: 9, title: "Mango Meadow", fruitIcon: "circle.fill", isUnlocked: false, stars: 0, mapPosition: CGPoint(x: 0.84, y: 0.40)),
        LevelNode(id: 10, title: "Plum Plateau", fruitIcon: "circle.fill", isUnlocked: false, stars: 0, mapPosition: CGPoint(x: 0.94, y: 0.52))
    ]
}
