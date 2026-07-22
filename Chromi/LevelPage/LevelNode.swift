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

    static let maxLevelID: Int = 10

    private static let baseLevels: [(id: Int, title: String, mapPosition: CGPoint)] = [
        (id: 1, title: "Apple Peak", mapPosition: CGPoint(x: 0.08, y: 0.63)),
        (id: 2, title: "Melon Way", mapPosition: CGPoint(x: 0.14, y: 0.42)),
        (id: 3, title: "Orange Isle", mapPosition: CGPoint(x: 0.22, y: 0.70)),
        (id: 4, title: "Eggplant Grove", mapPosition: CGPoint(x: 0.32, y: 0.46)),
        (id: 5, title: "Lemon Land", mapPosition: CGPoint(x: 0.45, y: 0.65)),
        (id: 6, title: "Coconut Cove", mapPosition: CGPoint(x: 0.53, y: 0.42)),
        (id: 7, title: "Avocado Acres", mapPosition: CGPoint(x: 0.64, y: 0.56)),
        (id: 8, title: "Mystery Orchard", mapPosition: CGPoint(x: 0.74, y: 0.74)),
        (id: 9, title: "Mystery Meadow", mapPosition: CGPoint(x: 0.84, y: 0.40)),
        (id: 10, title: "Mystery Plateau", mapPosition: CGPoint(x: 0.94, y: 0.57))
    ]

    static func previewLevels(unlockedLevelID: Int = 1) -> [LevelNode] {
        baseLevels.map { level in
            LevelNode(
                id: level.id,
                title: level.title,
                isUnlocked: level.id <= unlockedLevelID,
                mapPosition: level.mapPosition
            )
        }
    }
}
