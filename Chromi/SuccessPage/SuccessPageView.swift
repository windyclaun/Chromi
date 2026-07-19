//
//  SuccessPageView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 16/07/26.
//

import SwiftUI

struct SuccessPageView: View {
    let modelName: String
    var onLevelCompleted: () -> Void = {}
    var onBack: () -> Void = {}
    var onRestart: () -> Void = {}
    var onNextLevel: () -> Void = {}
    var onMenu: () -> Void = {}

    @State private var fruitYaw: Float = 0
    @State private var fruitPitch: Float = 0
    @State private var lastFruitDrag: CGSize = .zero
    @State private var isFloating = false
    @State private var showEndingPage = false

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let stageHeight = geometry.size.height * (isLandscape ? 0.72 : 0.66)
            let modelSize = min(geometry.size.width * (isLandscape ? 0.36 : 0.72), isLandscape ? 430 : 450)

            ZStack(alignment: .bottomTrailing) {
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
                        Color(red: 0.1, green: 0.03, blue: 0.26).opacity(0.1),
                        Color.clear,
                        Color(red: 0.7, green: 0.22, blue: 0.9).opacity(0.12)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                SuccessBlinkField(count: isLandscape ? 70 : 50)
                    .blendMode(.screen)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    topBar
                        .padding(.top, isLandscape ? 24 : 34)
                        .padding(.horizontal, isLandscape ? 42 : 24)

                    Spacer(minLength: 0)

                    ZStack {
                        SuccessGlowRings(size: modelSize)

                        RadialGradient(
                            colors: [Color.yellow.opacity(0.34), Color.clear],
                            center: .center,
                            startRadius: 10,
                            endRadius: modelSize * 0.72
                        )
                        .frame(width: modelSize * 1.5, height: modelSize * 1.5)
                        .blendMode(.screen)

                        RealityFruitView(modelName: modelName, yaw: fruitYaw, pitch: fruitPitch, isMonochrome: false)
                            .id(modelName)
                            .frame(width: modelSize, height: modelSize)
                            .contentShape(Rectangle())
                            .gesture(fruitRotationGesture)
                            .shadow(color: Color.black.opacity(0.24), radius: 18, x: 0, y: 14)
                    }
                    .frame(height: stageHeight)
                    .offset(y: isFloating ? -8 : 6)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isFloating)

                    nextButton
                        .padding(.top, 14)
                        .padding(.bottom, isLandscape ? 20 : 28)

                    Spacer(minLength: isLandscape ? 24 : 36)
                }
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .onAppear {
            isFloating = true
        }
        .fullScreenCover(isPresented: $showEndingPage) {
            EndingPageView(
                modelName: modelName,
                onRestart: {
                    showEndingPage = false
                    onRestart()
                },
                onNextLevel: {
                    showEndingPage = false
                    onNextLevel()
                },
                onMenu: {
                    showEndingPage = false
                    onMenu()
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
        }
    }

    private var nextButton: some View {
        Button {
            SoundEffectPlayer.shared.play(named: "ClickStartSound", fileExtension: "wav")
            onLevelCompleted()
            showEndingPage = true
        } label: {
            ChromiStartButtonLabel(
                title: "NEXT",
                systemImage: "arrow.right",
                width: 170,
                height: 62,
                fontSize: 24,
                iconSize: 19
            )
        }
        .buttonStyle(AnimatedStartButtonStyle())
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

#Preview {
    SuccessPageView(modelName: "Orange")
}
