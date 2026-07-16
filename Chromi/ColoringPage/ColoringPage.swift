//
//  ColoringPage.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 15/07/26.
//

import SwiftUI

struct ColoringPage: View {
    let modelName: String
    var onBack: () -> Void = {}
    var onOpenWorkbench: () -> Void = {}

    @State private var isBubbleFloating = false
    @State private var isMascotFloating = false
    @State private var isWorkbenchRaised = false
    @State private var isPaused = false
    @State private var fruitYaw: Float = 0
    @State private var fruitPitch: Float = 0
    @State private var lastFruitDrag: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let stageHeight = geometry.size.height * (isLandscape ? 0.7 : 0.62)

            ZStack(alignment: .bottom) {
                Color(red: 0.13, green: 0.06, blue: 0.28)
                    .ignoresSafeArea()

                loadBundledImage("bg_coloring.png")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea()

                LinearGradient(
                    colors: [
                        Color(red: 0.09, green: 0.03, blue: 0.24).opacity(0.06),
                        Color.clear,
                        Color(red: 0.46, green: 0.2, blue: 0.75).opacity(0.08)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    topBar
                        .padding(.top, isLandscape ? 24 : 34)
                        .padding(.horizontal, isLandscape ? 42 : 24)

                    Spacer(minLength: 0)

                    coloringStage(size: geometry.size, height: stageHeight, isLandscape: isLandscape)
                        .frame(height: stageHeight)

                    Spacer(minLength: isLandscape ? 72 : 92)
                }

                ColoringWorkbenchView(
                    size: geometry.size,
                    isLandscape: isLandscape,
                    isWorkbenchRaised: $isWorkbenchRaised,
                    onOpenWorkbench: onOpenWorkbench
                )
                .allowsHitTesting(!isPaused)

                if isPaused {
                    PauseOverlayView(
                        onMainMenu: goToLevelPageFromPause,
                        onRestart: restartLevel,
                        onResume: resumeLevel
                    )
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
                    .zIndex(5)
                }
            }
            .animation(.easeInOut(duration: 0.22), value: isPaused)
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .onAppear {
            isBubbleFloating = true
            isMascotFloating = true
        }
    }

    private var topBar: some View {
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

            Button(action: pauseLevel) {
                Image(systemName: "pause.fill")
                    .font(.system(size: 18, weight: .black))
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.white.opacity(0.18), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.white.opacity(0.35), lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.24), radius: 10, x: 0, y: 6)
            }
            .buttonStyle(LevelButtonStyle())
        }
    }

    private func coloringStage(size: CGSize, height: CGFloat, isLandscape: Bool) -> some View {
        ZStack {
            VStack(spacing: 6) {
                speechBubble
                    .offset(y: isBubbleFloating ? -8 : 0)
                    .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isBubbleFloating)

                RealityFruitView(modelName: modelName, yaw: fruitYaw, pitch: fruitPitch)
                    .id(modelName)
                    .frame(width: min(size.width * (isLandscape ? 0.38 : 0.72), 500), height: min(height * 0.72, 470))
                    .shadow(color: Color.black.opacity(0.22), radius: 20, x: 0, y: 18)
                    .contentShape(Rectangle())
                    .gesture(fruitRotationGesture)

                HStack(spacing: 7) {
                    Image(systemName: "rotate.3d")
                    Text("Geser ke semua arah untuk memutar")
                }
                .font(.system(size: 13, weight: .black, design: .rounded))
                .foregroundStyle(.white.opacity(0.92))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(Color.black.opacity(0.18), in: Capsule())

                objectShadow
            }
            .offset(x: isLandscape ? size.width * 0.08 : 0, y: isLandscape ? -14 : -20)

            mascotGuide(width: min(size.width * (isLandscape ? 0.2 : 0.34), 230))
                .offset(
                    x: isLandscape ? -size.width * 0.34 : -size.width * 0.27,
                    y: isLandscape ? height * 0.2 : height * 0.18
                )
        }
    }

    private var speechBubble: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkles")
                .font(.system(size: 17, weight: .black))

            Text("Warnai aku dengan sihir warna!")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .lineLimit(2)
                .minimumScaleFactor(0.72)
        }
        .foregroundStyle(Color(red: 0.28, green: 0.08, blue: 0.62))
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [Color.white, Color(red: 1.0, green: 0.92, blue: 0.28)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .overlay(alignment: .bottom) {
            TrianglePointer()
                .fill(Color(red: 1.0, green: 0.92, blue: 0.28))
                .frame(width: 22, height: 14)
                .offset(y: 12)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.72), lineWidth: 2)
        )
        .shadow(color: Color.yellow.opacity(0.42), radius: 16, x: 0, y: 0)
        .shadow(color: Color.black.opacity(0.18), radius: 10, x: 0, y: 6)
    }

    private func mascotGuide(width: CGFloat) -> some View {
        ZStack(alignment: .topTrailing) {
            loadBundledImage("maskot2d")
                .resizable()
                .scaledToFit()
                .frame(width: width)
                .shadow(color: Color.purple.opacity(0.55), radius: 22, x: 0, y: 0)
                .shadow(color: Color.black.opacity(0.32), radius: 14, x: 0, y: 10)
                .offset(y: isMascotFloating ? -5 : 5)
                .animation(.easeInOut(duration: 2.1).repeatForever(autoreverses: true), value: isMascotFloating)

            Text("Ayo mix warna!")
                .font(.system(size: 15, weight: .black, design: .rounded))
                .foregroundStyle(Color(red: 0.32, green: 0.08, blue: 0.68))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(red: 1.0, green: 0.88, blue: 0.18), in: Capsule())
                .shadow(color: Color.yellow.opacity(0.45), radius: 10, x: 0, y: 0)
                .offset(x: width * 0.1, y: -12)
        }
    }

    private var objectShadow: some View {
        Ellipse()
            .fill(Color.black.opacity(0.16))
            .frame(width: 200, height: 30)
            .blur(radius: 14)
            .offset(y: 16)
    }

    private var fruitRotationGesture: some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                guard !isPaused else { return }

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

    private func pauseLevel() {
        SoundEffectPlayer.shared.play(named: "ClickStartSound", fileExtension: "wav")
        isPaused = true
    }

    private func resumeLevel() {
        SoundEffectPlayer.shared.play(named: "ClickStartSound", fileExtension: "wav")
        isPaused = false
    }

    private func goToLevelPageFromPause() {
        SoundEffectPlayer.shared.play(named: "ClickStartSound", fileExtension: "wav")
        isPaused = false
        onBack()
    }

    private func restartLevel() {
        SoundEffectPlayer.shared.play(named: "ClickStartSound", fileExtension: "wav")
        fruitYaw = 0
        fruitPitch = 0
        lastFruitDrag = .zero
        isWorkbenchRaised = false
        isPaused = false
    }
}

#Preview {
    ColoringPage(modelName: "Orange")
}
