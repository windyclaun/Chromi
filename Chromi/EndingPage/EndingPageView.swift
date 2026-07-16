//
//  EndingPageView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 16/07/26.
//

import SwiftUI

struct EndingPageView: View {
    let modelName: String
    var onRestart: () -> Void = {}
    var onNextLevel: () -> Void = {}
    var onMenu: () -> Void = {}

    @State private var fruitYaw: Float = 0
    @State private var fruitPitch: Float = 0
    @State private var lastFruitDrag: CGSize = .zero
    @State private var isFloating = false

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let modelSize = min(geometry.size.width * (isLandscape ? 0.36 : 0.72), isLandscape ? 420 : 430)

            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.11, green: 0.03, blue: 0.28),
                        Color(red: 0.25, green: 0.10, blue: 0.62),
                        Color(red: 0.42, green: 0.18, blue: 0.78)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                EndingBlingField(count: isLandscape ? 78 : 56)
                    .blendMode(.screen)
                    .ignoresSafeArea()

                CelebrationEmojiField(isLandscape: isLandscape)
                    .ignoresSafeArea()

                RadialGradient(
                    colors: [Color.yellow.opacity(0.22), Color.clear],
                    center: .center,
                    startRadius: 12,
                    endRadius: min(geometry.size.width, geometry.size.height) * 0.5
                )
                .blendMode(.screen)
                .ignoresSafeArea()

                VStack(spacing: isLandscape ? 14 : 18) {
                    fruitShowcase(size: modelSize)
                        .offset(y: isFloating ? -8 : 6)
                        .animation(.easeInOut(duration: 2.1).repeatForever(autoreverses: true), value: isFloating)

                    VStack(spacing: 6) {
                        Text("Amazing!")
                            .font(.system(size: isLandscape ? 48 : 44, weight: .black, design: .rounded))
                            .foregroundStyle(Color(red: 1.0, green: 0.84, blue: 0.28))
                            .shadow(color: Color.yellow.opacity(0.55), radius: 18, x: 0, y: 0)
                            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)

                        Text("You brought the color back!")
                            .font(.system(size: isLandscape ? 20 : 18, weight: .black, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.9))
                            .shadow(color: Color.purple.opacity(0.45), radius: 8, x: 0, y: 3)
                    }

                    EndingActionButtons(
                        isLandscape: isLandscape,
                        onRestart: onRestart,
                        onNextLevel: onNextLevel,
                        onMenu: onMenu
                    )
                    .padding(.top, isLandscape ? 12 : 18)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .padding(.horizontal, isLandscape ? 42 : 24)
            }
            .onAppear {
                isFloating = true
            }
        }
        .ignoresSafeArea()
    }

    private func fruitShowcase(size: CGFloat) -> some View {
        ZStack {
            ExpandingFruitRings(size: size)

            Circle()
                .fill(Color.yellow.opacity(0.2))
                .frame(width: size * 0.96, height: size * 0.96)
                .blur(radius: 24)
                .blendMode(.screen)

            RealityFruitView(modelName: modelName, yaw: fruitYaw, pitch: fruitPitch, isMonochrome: false)
                .id(modelName)
                .frame(width: size, height: size)
                .contentShape(Rectangle())
                .gesture(fruitRotationGesture)
                .shadow(color: Color.black.opacity(0.24), radius: 18, x: 0, y: 14)
        }
    }

    private var fruitRotationGesture: some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                let deltaX = value.translation.width - lastFruitDrag.width
                let deltaY = value.translation.height - lastFruitDrag.height

                fruitYaw += Float(deltaX) * 0.01
                fruitPitch += Float(deltaY) * 0.01
                lastFruitDrag = value.translation
            }
            .onEnded { _ in
                lastFruitDrag = .zero
            }
    }
}

private struct ExpandingFruitRings: View {
    let size: CGFloat

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate

            ZStack {
                ForEach(0..<4, id: \.self) { index in
                    let progress = CGFloat((time * 0.42 + Double(index) * 0.25).truncatingRemainder(dividingBy: 1.0))
                    let scale = 0.72 + progress * 0.55
                    let opacity = 0.28 * (1 - progress)

                    RoundedRectangle(cornerRadius: size * 0.34, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(opacity),
                                    Color.yellow.opacity(opacity * 0.9),
                                    Color.purple.opacity(opacity)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2.5
                        )
                        .frame(width: size * 1.04, height: size * 1.24)
                        .scaleEffect(scale)
                        .shadow(color: Color.yellow.opacity(opacity), radius: 10, x: 0, y: 0)
                }
            }
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    EndingPageView(modelName: "Orange")
}
