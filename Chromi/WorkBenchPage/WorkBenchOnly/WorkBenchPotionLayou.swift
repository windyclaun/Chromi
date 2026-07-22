//
//  WorkBenchPotionLayou.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 22/07/26.
//

import CoreGraphics

enum WorkBenchPotionLayout {
    static let size: CGFloat = 104
    static let spacing: CGFloat = 14
    static let maxRows = 3
    static let shelfWidth: CGFloat = 510
    static let shelfHeight: CGFloat = size * CGFloat(maxRows) + spacing * CGFloat(maxRows - 1)
}
