//
//  ColoringWorkbenchView+Components.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 19/07/26.
//

import SwiftUI

extension ColoringWorkbenchView {
    
    // MARK: - Color Shelf Component
    var colorShelf: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Color Shelf")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundStyle(Color(red: 1.0, green: 0.9, blue: 0.28))
                .shadow(color: Color.black.opacity(0.22), radius: 2, x: 0, y: 1)

            let orbSize = isLandscape ? 58.0 : 42.0
            let orbSpacing = isLandscape ? 16.0 : 10.0

            LazyVGrid(columns: Array(repeating: GridItem(.fixed(orbSize), spacing: orbSpacing), count: 3), spacing: orbSpacing) {
                colorOrb(Color(red: 0.32, green: 0.54, blue: 1.0))
                colorOrb(Color(red: 1.0, green: 0.84, blue: 0.12))
                colorOrb(Color(red: 0.96, green: 0.24, blue: 0.34))
                colorOrb(Color(red: 0.25, green: 0.86, blue: 0.36))
                colorOrb(Color(red: 0.78, green: 0.32, blue: 1.0))
                colorOrb(Color(red: 1.0, green: 0.52, blue: 0.12))
                colorOrb(Color(red: 0.2, green: 0.86, blue: 0.9))
                colorOrb(Color(red: 1.0, green: 0.48, blue: 0.76))
                colorOrb(Color.white.opacity(0.9))
            }
            .padding(isLandscape ? 18 : 12)
            .background(Color(red: 0.52, green: 0.25, blue: 0.06).opacity(0.44), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color(red: 1.0, green: 0.76, blue: 0.22).opacity(0.35), lineWidth: 2)
            )
        }
    }

    // MARK: - Magic Mix Component
    var potionMixingArea: some View {
        VStack(alignment: .trailing, spacing: 18) {
            Text("Magic Mix")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundStyle(Color(red: 1.0, green: 0.9, blue: 0.28))
                .shadow(color: Color.black.opacity(0.22), radius: 2, x: 0, y: 1)

            HStack(alignment: .bottom, spacing: isLandscape ? 26 : 18) {
                beaker(fill: Color(red: 1.0, green: 0.2, blue: 0.34), height: isLandscape ? 148 : 116)
                beaker(fill: Color(red: 0.25, green: 0.84, blue: 0.38), height: isLandscape ? 128 : 102)
            }
            .padding(isLandscape ? 22 : 12)
            .background(Color(red: 0.34, green: 0.12, blue: 0.38).opacity(0.22), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.16), lineWidth: 2)
            )
        }
    }

    // MARK: - Orb & Beaker Render Helpers
    func colorOrb(_ color: Color) -> some View {
        let orbSize = isLandscape ? 58.0 : 42.0

        return Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color.white.opacity(0.92),
                        color,
                        color.opacity(0.64)
                    ],
                    center: .topLeading,
                    startRadius: 4,
                    endRadius: 38
                )
            )
            .frame(width: orbSize, height: orbSize)
            .overlay(Circle().stroke(Color.white.opacity(0.36), lineWidth: 2))
            .shadow(color: color.opacity(0.34), radius: 10, x: 0, y: 4)
    }

    func beaker(fill: Color, height: CGFloat) -> some View {
        let beakerWidth = isLandscape ? 104.0 : 78.0

        return ZStack(alignment: .bottom) {
            BeakerShape()
                .fill(Color.white.opacity(0.12))
                .frame(width: beakerWidth, height: height)
                .overlay(BeakerShape().stroke(Color.white.opacity(0.72), lineWidth: 4))

            BeakerShape()
                .fill(
                    LinearGradient(
                        colors: [fill.opacity(0.78), fill.opacity(0.42)],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .frame(width: beakerWidth, height: height * 0.45)
                .mask(
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .frame(height: height * 0.42)
                    }
                )
                .padding(.bottom, 7)

            Circle()
                .fill(Color.white.opacity(shinePhase ? 0.42 : 0.18))
                .frame(width: 16, height: 16)
                .offset(x: -20, y: -height * 0.45)
                .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: shinePhase)
        }
    }

    // MARK: - Decorative Gradients
    var tableHighlight: some View {
        LinearGradient(
            colors: [
                Color.white.opacity(0.18),
                Color.white.opacity(0.03),
                Color.clear
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 130)
        .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 34, bottomLeading: 0, bottomTrailing: 0, topTrailing: 34), style: .continuous))
    }

    var tableGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.83, green: 0.45, blue: 0.06),
                Color(red: 0.58, green: 0.27, blue: 0.03),
                Color(red: 0.31, green: 0.12, blue: 0.36)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var borderGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.75, blue: 0.18),
                Color(red: 0.58, green: 0.24, blue: 0.94),
                Color(red: 0.12, green: 0.05, blue: 0.25)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
