//
//  PotionAssetCatalog.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 22/07/26.
//

import SwiftUI

enum PotionAssetCatalog {
    static let primaryColorNames = ["red", "yellow", "blue"]
    static let secondaryColorNames = ["orange", "purple", "green", "brown"]
    static let modifierColorNames = ["min_red", "min_blue", "min_yellow", "min_green", "min_orange", "min_purple"]

    static var allColorNames: [String] {
        primaryColorNames + secondaryColorNames + modifierColorNames
    }

    static func potions(for modelName: String) -> [PotionType] {
        let config = WorkbenchLevelRecipe.config(for: modelName)
        let unlockedSet = Set(config.unlockedPotions)
        let orderedNames = unique(config.unlockedPotions + config.lockedPotions)

        return orderedNames.map { colorName in
            PotionType(colorName: colorName, isUnlocked: unlockedSet.contains(colorName))
        }
    }

    static func imageName(for colorName: String) -> String {
        "ColorPotion/\(colorName).PNG"
    }

    static func displayName(for colorName: String) -> String {
        switch colorName {
        case "red": return "Red"
        case "yellow": return "Yellow"
        case "blue": return "Blue"
        case "orange": return "Orange"
        case "purple": return "Purple"
        case "green": return "Green"
        case "brown": return "Brown"
        case "min_red": return "-Red"
        case "min_blue": return "-Blue"
        case "min_yellow": return "-Yellow"
        case "min_green": return "-Green"
        case "min_orange": return "-Orange"
        case "min_purple": return "-Purple"
        default: return colorName
        }
    }

    static func tint(for colorName: String) -> Color {
        switch colorName {
        case "red", "min_red": return Color(red: 0.96, green: 0.18, blue: 0.26)
        case "yellow", "min_yellow": return Color(red: 1.0, green: 0.82, blue: 0.12)
        case "blue", "min_blue": return Color(red: 0.22, green: 0.48, blue: 1.0)
        case "orange", "min_orange": return Color(red: 1.0, green: 0.48, blue: 0.08)
        case "purple", "min_purple": return Color(red: 0.62, green: 0.28, blue: 0.92)
        case "green", "min_green": return Color(red: 0.18, green: 0.72, blue: 0.32)
        case "brown": return Color(red: 0.44, green: 0.24, blue: 0.1)
        default: return .gray
        }
    }

    private static func unique(_ names: [String]) -> [String] {
        var seen = Set<String>()
        return names.filter { seen.insert($0).inserted }
    }
}
