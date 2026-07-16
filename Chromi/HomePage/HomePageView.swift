//
//  HomePageView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 16/07/26.
//

import SwiftUI

struct HomePageView: View {
    @State private var showGameFlow = false

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height

            ZStack {
                bundledImage("bg_homepage.jpeg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()

                RadialGradient(
                    colors: [Color.yellow.opacity(0.18), Color.clear],
                    center: .center,
                    startRadius: 20,
                    endRadius: min(geometry.size.width, geometry.size.height) * 0.55
                )
                .blendMode(.screen)

                SparkleField(count: isLandscape ? 18 : 14)

                if isLandscape {
                    landscapeContent(in: geometry.size)
                } else {
                    portraitContent(in: geometry.size)
                }
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .onAppear {
            BackgroundMusicPlayer.shared.playLoop(named: "HomePageSound")
        }
        .fullScreenCover(isPresented: $showGameFlow, onDismiss: {
            BackgroundMusicPlayer.shared.playLoop(named: "HomePageSound")
        }) {
            GameFlowView {
                showGameFlow = false
            }
        }
    }

    // MARK: - Layout Orientations
    private func landscapeContent(in size: CGSize) -> some View {
        HStack(spacing: 18) {
            Spacer(minLength: 12)

            ZStack {
                glowBlob(color: .purple, width: min(size.width * 0.34, 390), height: min(size.width * 0.28, 320))
                SparkleHalo(width: min(size.width * 0.34, 390), height: min(size.width * 0.32, 360))
                bundledImage("maskotNew")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(size.width * 0.5, 450))
                    .shadow(color: .black.opacity(0.35), radius: 22, x: 0, y: 14)
            }

            Spacer(minLength: 6)

            VStack(spacing: 34) {
                ZStack {
                    glowBlob(color: .yellow, width: min(size.width * 0.5, 560), height: min(size.height * 0.34, 230))
                    SparkleHalo(width: min(size.width * 0.5, 560), height: min(size.height * 0.34, 230))
                    bundledImage("LogoTulisan")
                        .resizable()
                        .scaledToFit()
                        .frame(width: min(size.width * 0.51, 560))
                        .shadow(color: .yellow.opacity(0.5), radius: 18, x: 0, y: 0)
                        .shadow(color: .purple.opacity(0.28), radius: 12, x: 0, y: 8)
                }
                startButton(width: min(size.width * 0.31, 340))
            }
            .padding(.top, size.height * 0.02)

            Spacer(minLength: 18)
        }
        .frame(width: size.width, height: size.height)
    }

    private func portraitContent(in size: CGSize) -> some View {
        VStack(spacing: 22) {
            Spacer(minLength: 24)

            ZStack {
                glowBlob(color: .yellow, width: min(size.width * 0.92, 480), height: 190)
                SparkleHalo(width: min(size.width * 0.9, 460), height: 180)
                bundledImage("LogoTulisan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(size.width * 0.9, 460))
                    .shadow(color: .yellow.opacity(0.5), radius: 18, x: 0, y: 0)
            }

            ZStack {
                glowBlob(color: .purple, width: min(size.width * 0.72, 350), height: min(size.width * 0.7, 340))
                SparkleHalo(width: min(size.width * 0.72, 350), height: min(size.width * 0.7, 340))
                bundledImage("maskotNew")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(size.width * 0.68, 350))
                    .shadow(color: .black.opacity(0.35), radius: 22, x: 0, y: 14)
            }

            startButton(width: min(size.width * 0.64, 330))
            Spacer(minLength: 30)
        }
        .frame(width: size.width, height: size.height)
    }

    // MARK: - Subviews & Controls
    private func glowBlob(color: Color, width: CGFloat, height: CGFloat) -> some View {
        Ellipse()
            .fill(color.opacity(0.28))
            .frame(width: width, height: height)
            .blur(radius: 34)
            .blendMode(.screen)
    }

    private func startButton(width: CGFloat) -> some View {
        Button(action: startGame) {
            HStack(spacing: 10) {
                Image(systemName: "play.fill").font(.system(size: 25, weight: .bold))
                Text("START")
                    .font(.system(size: 35, weight: .heavy, design: .rounded))
            }
            .foregroundStyle(Color(red: 0.24, green: 0.1, blue: 0.55))
            .frame(width: width, height: 78)
            .background(LinearGradient(colors: [Color(red: 1.0, green: 0.92, blue: 0.08), Color(red: 0.92, green: 0.66, blue: 0.09)], startPoint: .top, endPoint: .bottom))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.white.opacity(0.75), lineWidth: 5))
            .overlay(alignment: .topLeading) {
                Capsule().fill(Color.white.opacity(0.28)).frame(height: 22).padding(.horizontal, 18).padding(.top, 8)
            }
        }
        .buttonStyle(AnimatedStartButtonStyle())
    }

    private func startGame() {
        SoundEffectPlayer.shared.play(named: "ClickStartSound", fileExtension: "wav")
        showGameFlow = true
    }

    private func bundledImage(_ name: String) -> Image {
        if let image = UIImage(named: name) { return Image(uiImage: image) }
        return Image(name)
    }
}

#Preview {
    HomePageView()
}
