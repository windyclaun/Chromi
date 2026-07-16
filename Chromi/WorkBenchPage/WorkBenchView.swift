//
//  WorkBenchView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 16/07/26.
//

import SwiftUI

struct WorkBenchView: View {
    let modelName: String
    let onLevelCompleted: () -> Void
    let onRestart: () -> Void
    let onNextLevel: () -> Void
    let onMenu: () -> Void
    let onBack: () -> Void

    @State private var fruitYaw: Float = 0
    @State private var fruitPitch: Float = 0
    @State private var lastFruitDrag: CGSize = .zero
    @State private var isFruitFloating = false
    @State private var showSuccessPage = false

    init(
        modelName: String,
        onLevelCompleted: @escaping () -> Void = {},
        onRestart: @escaping () -> Void,
        onNextLevel: @escaping () -> Void,
        onMenu: @escaping () -> Void,
        onBack: @escaping () -> Void
    ) {
        self.modelName = modelName
        self.onLevelCompleted = onLevelCompleted
        self.onRestart = onRestart
        self.onNextLevel = onNextLevel
        self.onMenu = onMenu
        self.onBack = onBack
    }

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let topAreaHeight = geometry.size.height * 0.34
            let bottomAreaHeight = geometry.size.height - topAreaHeight
            let fruitSize = min(geometry.size.width * (isLandscape ? 0.26 : 0.42), isLandscape ? 250 : 320)

            ZStack(alignment: .top) {
                loadBundledImage("bg_workbench.jpg")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea()

                LinearGradient(
                    colors: [
                        Color.black.opacity(0.18),
                        Color.clear,
                        Color.black.opacity(0.28)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    topBar
                        .padding(.top, isLandscape ? 22 : 30)
                        .padding(.horizontal, isLandscape ? 36 : 20)

                    VStack(spacing: 10) {
                        RealityFruitView(modelName: modelName, yaw: fruitYaw, pitch: fruitPitch)
                            .id(modelName)
                            .frame(width: fruitSize, height: fruitSize)
                            .shadow(color: Color.black.opacity(0.24), radius: 18, x: 0, y: 16)
                            .contentShape(Rectangle())
                            .gesture(fruitRotationGesture())

                        HStack(spacing: 7) {
                            Image(systemName: "rotate.3d")
                            Text("Geser ke semua arah untuk memutar")
                        }
                        .font(.system(size: 13, weight: .black, design: .rounded))
                        .foregroundStyle(.white.opacity(0.94))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Color.black.opacity(0.18), in: Capsule())
                    }
                    .offset(y: isFruitFloating ? -6 : 0)
                    .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isFruitFloating)
                    .frame(height: topAreaHeight - 90)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 6)

                    Spacer(minLength: 0)

                    mixingArea(height: bottomAreaHeight, isLandscape: isLandscape)
                }

            }
            .ignoresSafeArea()
            .overlay(alignment: .bottomTrailing) {
                applyButton
                    .padding(.trailing, isLandscape ? 42 : 24)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 24, isLandscape ? 34 : 30))
            }
        }
        .ignoresSafeArea()
        .onAppear {
            isFruitFloating = true
        }
        .fullScreenCover(isPresented: $showSuccessPage) {
            SuccessPageView(
                modelName: modelName,
                onLevelCompleted: {
                    onLevelCompleted()
                },
                onBack: {
                    showSuccessPage = false
                },
                onRestart: {
                    showSuccessPage = false
                    onRestart()
                },
                onNextLevel: {
                    showSuccessPage = false
                    onNextLevel()
                },
                onMenu: {
                    showSuccessPage = false
                    onMenu()
                },
            )
        }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
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

            Spacer(minLength: 0)
        }
    }

    private func mixingArea(height: CGFloat, isLandscape: Bool) -> some View {
        VStack(spacing: 14) {
            HStack {
                Text("Mixing Area")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(Color.yellow.opacity(0.95))
                Spacer()
            }

            HStack(spacing: isLandscape ? 18 : 14) {
                colorTile(Color(red: 0.32, green: 0.54, blue: 1.0))
                colorTile(Color(red: 1.0, green: 0.84, blue: 0.12))
                colorTile(Color(red: 0.96, green: 0.24, blue: 0.34))
            }

            HStack(spacing: isLandscape ? 20 : 14) {
                beaker(fill: Color(red: 1.0, green: 0.2, blue: 0.34), height: isLandscape ? 168 : 142)
                beaker(fill: Color(red: 0.25, green: 0.84, blue: 0.38), height: isLandscape ? 168 : 142)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, minHeight: height)
        .padding(.horizontal, isLandscape ? 44 : 22)
        .padding(.top, isLandscape ? 24 : 18)
        .padding(.horizontal, isLandscape ? 20 : 14)
        .padding(.bottom, isLandscape ? 18 : 14)
    }

    private var applyButton: some View {
        Button {
            SoundEffectPlayer.shared.play(named: "ClickStartSound", fileExtension: "wav")
            showSuccessPage = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "wand.and.sparkles")
                Text("Apply")
            }
            .font(.system(size: 18, weight: .black, design: .rounded))
            .foregroundStyle(Color(red: 0.3, green: 0.07, blue: 0.62))
            .padding(.horizontal, 22)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: [Color.white, Color(red: 1.0, green: 0.86, blue: 0.26)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: Capsule()
            )
            .overlay(Capsule().stroke(Color.white.opacity(0.82), lineWidth: 2))
            .shadow(color: Color.yellow.opacity(0.38), radius: 14, x: 0, y: 6)
            .shadow(color: Color.black.opacity(0.22), radius: 8, x: 0, y: 5)
        }
        .buttonStyle(LevelButtonStyle())
    }

    private func colorTile(_ color: Color) -> some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [color.opacity(0.95), color.opacity(0.62)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 52, height: 52)
            .overlay(Circle().stroke(Color.white.opacity(0.34), lineWidth: 2))
            .shadow(color: color.opacity(0.32), radius: 8, x: 0, y: 4)
    }

    private func beaker(fill: Color, height: CGFloat) -> some View {
        BeakerShape()
            .fill(
                LinearGradient(
                    colors: [fill.opacity(0.8), fill.opacity(0.35)],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(width: 108, height: height)
            .overlay(
                BeakerShape()
                    .stroke(Color.white.opacity(0.78), lineWidth: 4)
            )
            .shadow(color: fill.opacity(0.22), radius: 10, x: 0, y: 6)
    }

    private func fruitRotationGesture() -> some Gesture {
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

private struct BeakerShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let neckWidth = rect.width * 0.38
        let neckMinX = rect.midX - neckWidth * 0.5
        let neckMaxX = rect.midX + neckWidth * 0.5
        let neckBottomY = rect.minY + rect.height * 0.38
        let baseInset = rect.width * 0.08

        path.move(to: CGPoint(x: neckMinX, y: rect.minY))
        path.addLine(to: CGPoint(x: neckMaxX, y: rect.minY))
        path.addLine(to: CGPoint(x: neckMaxX, y: neckBottomY))
        path.addLine(to: CGPoint(x: rect.maxX - baseInset, y: rect.maxY - 14))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - 24, y: rect.maxY),
            control: CGPoint(x: rect.maxX - baseInset, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: rect.minX + 24, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + baseInset, y: rect.maxY - 14),
            control: CGPoint(x: rect.minX + baseInset, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: neckMinX, y: neckBottomY))
        path.closeSubpath()

        return path
    }
}

#Preview {
    WorkBenchView(modelName: "Orange", onRestart: {}, onNextLevel: {}, onMenu: {}, onBack: {})
}
