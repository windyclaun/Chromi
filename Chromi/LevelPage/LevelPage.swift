//
//  LevelPage.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 15/07/26.
//

import SwiftUI
import UIKit

struct LevelPage: View {
    var onBack: () -> Void = {}
    var onSelectLevel: (LevelNode) -> Void = { _ in }

    @State private var mapOffset: CGFloat = 0
    @GestureState private var dragTranslation: CGFloat = 0

    private let levels: [LevelNode] = LevelNode.previewLevels
    private var backgroundAspectRatio: CGFloat {
        if let image = UIImage(named: "bg_long_level") ?? UIImage(named: "bg_long_level.jpg") {
            return image.size.width / image.size.height
        }
        return 1696.0 / 624.0
    }

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let mapHeight = geometry.size.height
            let mapWidth = max(geometry.size.width, mapHeight * backgroundAspectRatio)
            let minimumMapOffset = min(geometry.size.width - mapWidth, 0)
            let visibleMapOffset = clampedMapOffset(mapOffset + dragTranslation, minimumOffset: minimumMapOffset)

            ZStack(alignment: .topLeading) {
                Color(red: 0.18, green: 0.05, blue: 0.42)

                ZStack {
                    Color(red: 0.18, green: 0.05, blue: 0.42)

                    bundledImage("bg_long_level.jpg")
                        .resizable()
                        .scaledToFit()
                        .frame(width: mapWidth, height: mapHeight)
                        .clipped()

                    LinearGradient(
                        colors: [
                            Color(red: 0.09, green: 0.03, blue: 0.24).opacity(0.08),
                            Color.clear,
                            Color(red: 1.0, green: 0.82, blue: 0.23).opacity(0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )

                    MagicEffectsField()
                        .blendMode(.screen)

                    ForEach(levels) { level in
                        LevelNodeButton(
                            level: level,
                            position: CGPoint(
                                x: mapWidth * level.mapPosition.x,
                                y: mapHeight * level.mapPosition.y
                            ),
                            onSelect: onSelectLevel
                        )
                    }
                }
                .frame(width: mapWidth, height: mapHeight, alignment: .topLeading)
                .offset(x: visibleMapOffset)
                .animation(.interactiveSpring(response: 0.22, dampingFraction: 0.9), value: visibleMapOffset)
                .gesture(
                    DragGesture()
                        .updating($dragTranslation) { value, state, _ in
                            state = value.translation.width
                        }
                        .onEnded { value in
                            mapOffset = clampedMapOffset(
                                mapOffset + value.translation.width,
                                minimumOffset: minimumMapOffset
                            )
                        }
                )
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
                .clipped()

                topBar(width: min(geometry.size.width - 48, 560))
                    .padding(.top, isLandscape ? 28 : 34)
                    .padding(.horizontal, isLandscape ? 38 : 24)
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }

    private func topBar(width: CGFloat) -> some View {
        HStack {
            Button(action: onBack) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .font(.system(size: 16, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.72, green: 0.36, blue: 1.0), Color(red: 0.35, green: 0.14, blue: 0.76)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: Capsule()
                )
                .overlay(Capsule().stroke(Color.white.opacity(0.42), lineWidth: 2))
                .shadow(color: Color.purple.opacity(0.45), radius: 14, x: 0, y: 8)
            }
            .buttonStyle(LevelButtonStyle())

            Spacer()
        }
        .frame(width: width)
    }

    private func clampedMapOffset(_ offset: CGFloat, minimumOffset: CGFloat) -> CGFloat {
        min(max(offset, minimumOffset), 0)
    }

    private func bundledImage(_ name: String) -> Image {
        if let image = UIImage(named: name) ?? UIImage(named: "\(name).jpg") ?? UIImage(named: "\(name).png") {
            return Image(uiImage: image)
        }

        return Image(name)
    }
}

#Preview {
    LevelPage()
}
