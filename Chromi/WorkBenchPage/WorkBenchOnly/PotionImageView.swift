//
//  PotionImageView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 22/07/26.
//

import SwiftUI

struct PotionImageView: View {
    let colorName: String

    var body: some View {
        if let imageName = resolvedPotionImageName {
            loadBundledImage(imageName)
                .resizable()
                .scaledToFit()
        } else {
            potionFallback
        }
    }

    private var resolvedPotionImageName: String? {
        [
            PotionAssetCatalog.imageName(for: colorName),
            "\(colorName).PNG",
            "Assets/ColorPotion/\(colorName).PNG",
            "potions/\(colorName).png"
        ].first { bundledUIImage(named: $0) != nil }
    }

    private var potionFallback: some View {
        let tint = PotionAssetCatalog.tint(for: colorName)

        return ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [tint.opacity(0.92), tint.opacity(0.58)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.42), lineWidth: 3)
                )

            VStack(spacing: 3) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 25, weight: .black))
                Text(PotionAssetCatalog.displayName(for: colorName))
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
            .foregroundStyle(.white)
            .shadow(color: Color.black.opacity(0.22), radius: 2, x: 0, y: 1)
            .padding(.horizontal, 6)
        }
    }
}
