//
//  FruitIcon.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 15/07/26.
//

import SwiftUI

struct FruitIcon: View {
    let systemName: String
    let isColored: Bool

    var body: some View {
        Text(systemName)
            .font(.system(size: 62))
            .saturation(isColored ? 1 : 0)
            .brightness(isColored ? 0 : -0.28)
            .shadow(color: Color.black.opacity(0.24), radius: 7, x: 0, y: 5)
            .shadow(color: isColored ? Color.red.opacity(0.36) : .clear, radius: 12, x: 0, y: 0)
            .frame(width: 88, height: 78)
    }
}
