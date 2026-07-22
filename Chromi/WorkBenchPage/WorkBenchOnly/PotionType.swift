//
//  PotionType.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 22/07/26.
//

import SwiftUI

struct PotionType: Identifiable, Equatable {
    let id = UUID()
    var colorName: String
    var isUnlocked: Bool = true
    var position: CGPoint = .zero
    var homePosition: CGPoint = .zero
}
