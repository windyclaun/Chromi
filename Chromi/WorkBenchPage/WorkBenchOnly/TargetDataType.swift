//
//  TargetDataType.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 22/07/26.
//

import SwiftUI

struct TargetDataType: Identifiable {
    let id = UUID()
    var colorName: String
    var isMatched: Bool = false
    var globalFrame: CGRect = .zero
}
