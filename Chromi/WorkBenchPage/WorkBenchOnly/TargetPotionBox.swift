//
//  TargetPotionBox.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 22/07/26.
//

import SwiftUI

struct TargetPotionBox: View {
    @Binding var targetPotion: TargetDataType
    
    var body: some View {
        ZStack {
            loadBundledImage("potionFrame.png")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 180)
                .clipped()

            PotionImageView(colorName: targetPotion.colorName)
                .frame(width: 140, height: 140)
                .opacity(targetPotion.isMatched ? 1.0 : 0.34)
                .saturation(targetPotion.isMatched ? 1.0 : 0.25)
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        targetPotion.globalFrame = geo.frame(in: .named("TableSpace"))
                    }
                    .onChange(of: geo.frame(in: .named("TableSpace"))) { _, newFrame in
                        targetPotion.globalFrame = newFrame
                    }
            }
        )
    }
}
