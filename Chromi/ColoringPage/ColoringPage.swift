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
    var onMenu: () -> Void = {}
    var onNextLevel: () -> Void = {}
    var onLevelCompleted: () -> Void = {}
    var onOpenWorkbench: () -> Void = {}

    @State private var isPaused = false
    @State private var showWorkbenchPage = false
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

                    ColoringStageView(
                        modelName: modelName,
                        geometrySize: geometry.size,
                        height: stageHeight,
                        isLandscape: isLandscape,
                        isPaused: isPaused,
                        fruitYaw: $fruitYaw,
                        fruitPitch: $fruitPitch,
                        lastFruitDrag: $lastFruitDrag,
                        onOpenWorkbench: openWorkbenchPage
                    )
                    .frame(height: stageHeight)

                    Spacer(minLength: isLandscape ? 72 : 92)
                }

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
        .fullScreenCover(isPresented: $showWorkbenchPage) {
            WorkBenchView(
                modelName: modelName,
                onLevelCompleted: {
                    onLevelCompleted()
                },
                onRestart: {
                    showWorkbenchPage = false
                },
                onNextLevel: {
                    showWorkbenchPage = false
                    onNextLevel()
                },
                onMenu: {
                    showWorkbenchPage = false
                    onMenu()
                },
                onBack: {
                    showWorkbenchPage = false
                }
            )
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

    private func openWorkbenchPage() {
        SoundEffectPlayer.shared.play(named: "ClickStartSound", fileExtension: "wav")
        withAnimation(.easeInOut(duration: 0.2)) {
            showWorkbenchPage = true
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
        isPaused = false
    }
}

#Preview {
    ColoringPage(modelName: "Orange")
}
