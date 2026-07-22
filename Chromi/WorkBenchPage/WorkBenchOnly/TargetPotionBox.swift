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

            VStack {
                Spacer()
                colorHint
            }
            .padding(.bottom, 12)
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

    private var colorHint: some View {
        Text(PotionAssetCatalog.displayName(for: targetPotion.colorName))
            .font(.system(size: 14, weight: .black, design: .rounded))
            .foregroundStyle(Color(red: 0.25, green: 0.08, blue: 0.58))
            .lineLimit(1)
            .minimumScaleFactor(0.72)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.9), in: Capsule())
            .overlay(Capsule().stroke(Color.purple.opacity(0.24), lineWidth: 2))
            .shadow(color: Color.black.opacity(0.24), radius: 6, x: 0, y: 3)
    }
}
