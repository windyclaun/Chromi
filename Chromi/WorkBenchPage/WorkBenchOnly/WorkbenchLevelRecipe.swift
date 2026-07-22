//
//  WorkbenchLevelRecipe.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 22/07/26.
//

import Foundation

enum WorkbenchLevelRecipe {
    static let levelOnePlaceholder = WorkbenchLevelConfig(
        targets: ["red"],
        unlockedPotions: ["red", "yellow", "blue"],
        lockedPotions: ["orange", "purple", "green", "brown", "min_red", "min_blue", "min_yellow"]
    )

    static func config(for modelName: String) -> WorkbenchLevelConfig {
        switch modelName {
        case "Apple", "Placeholder8", "Placeholder9", "Placeholder10":
            return levelOnePlaceholder
        case "Melon":
            return WorkbenchLevelConfig(
                targets: ["green"],
                unlockedPotions: ["red", "yellow", "blue"],
                lockedPotions: ["orange", "purple", "green", "brown", "min_red", "min_blue", "min_yellow"]
            )
        case "Orange":
            return WorkbenchLevelConfig(
                targets: ["orange", "green"],
                unlockedPotions: ["red", "yellow", "blue", "green"],
                lockedPotions: ["purple", "orange", "brown", "min_red", "min_blue", "min_yellow"]
            )
        case "Eggplant":
            return WorkbenchLevelConfig(
                targets: ["purple", "green"],
                unlockedPotions: ["red", "yellow", "blue", "green", "orange"],
                lockedPotions: ["purple", "brown", "min_red", "min_blue", "min_yellow"]
            )
        case "Lemon1":
            return WorkbenchLevelConfig(
                targets: ["yellow"],
                unlockedPotions: ["orange", "purple", "blue", "green", "min_red", "min_blue", "min_yellow"],
                lockedPotions: ["red", "yellow", "brown"]
            )
        case "Coconut":
            return WorkbenchLevelConfig(
                targets: ["brown"],
                unlockedPotions: ["red", "yellow", "blue", "orange", "purple", "green", "min_red", "min_blue", "min_yellow"],
                lockedPotions: ["brown"]
            )
        case "Avocado":
            return WorkbenchLevelConfig(
                targets: ["green"],
                unlockedPotions: ["purple", "yellow", "min_red", "min_blue", "min_yellow"],
                lockedPotions: ["red", "orange", "green", "brown", "blue"]
            )
        default:
            return levelOnePlaceholder
        }
    }

    static func targets(for modelName: String) -> [TargetDataType] {
        config(for: modelName).targets.map { TargetDataType(colorName: $0) }
    }
}
