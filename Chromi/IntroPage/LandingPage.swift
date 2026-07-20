//
//  LandingPage.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 15/07/26.
//

import SwiftUI

struct LandingPage: View {
    var onLetsPlay: () -> Void = {}

    @State private var currentPage = 0
    @State private var pageTransitionDirection = 1

    private let pages: [IntroPage] = [
        IntroPage(
            leftFruit: "🍎", rightFruit: "🍎", accent: "🌈",
            title: "Once upon a time, in a magical land of colors...",
            detail: "Every fruit used to shine with its own beautiful color.",
            isColored: false
        ),
        IntroPage(
            leftFruit: "🍎", rightFruit: "🍎", accent: "😢",
            title: "One day, the colors suddenly disappeared!",
            detail: "All the fruits became gray and the color lab grew quiet.",
            isColored: false
        ),
        IntroPage(
            leftFruit: "🍎", rightFruit: "🍎", accent: "🧪",
            title: "A brave little wizard found magical color potions...",
            detail: "Mix the right colors to bring each fruit back to life.",
            isColored: false
        ),
        IntroPage(
            leftFruit: "🍎", rightFruit: "🍎", accent: "✨",
            title: "Now it is your turn...",
            detail: "Mix, create, and bring the colors back to life!",
            isColored: true
        )
    ]

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let cardWidth = min(geometry.size.width * (isLandscape ? 0.5 : 0.86), isLandscape ? 610 : 500)
            let cardHeight = min(geometry.size.height * (isLandscape ? 0.58 : 0.43), isLandscape ? 390 : 390)

            ZStack {
                // Background Utama
                bundledImage("bg_homepage.jpeg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()

                Color(red: 0.09, green: 0.03, blue: 0.24)
                    .opacity(0.12)

                RadialGradient(
                    colors: [Color.yellow.opacity(0.22), Color.purple.opacity(0.08), Color.clear],
                    center: .center,
                    startRadius: 8,
                    endRadius: min(geometry.size.width, geometry.size.height) * 0.72
                )
                .blendMode(.screen)

                LandingSparkleField(count: isLandscape ? 46 : 34)

                // Layouting Adaptif Berdasarkan Orientasi iPad
                if isLandscape {
                    landscapeLayout(size: geometry.size, cardWidth: cardWidth, cardHeight: cardHeight)
                } else {
                    portraitLayout(size: geometry.size, cardWidth: cardWidth, cardHeight: cardHeight)
                }
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .onAppear {
            playIntroSound(for: currentPage)
        }
        .onChange(of: currentPage) { _, newPage in
            playIntroSound(for: newPage)
        }
        .onDisappear {
            SoundEffectPlayer.shared.stopIntro()
        }
    }

    // MARK: - Layouts
    private func landscapeLayout(size: CGSize, cardWidth: CGFloat, cardHeight: CGFloat) -> some View {
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .center, spacing: 12) {
                mascotView(width: min(size.width * 0.31, 360))
                    .padding(.leading, size.width * 0.02)
                    .padding(.top, size.height * 0.18)
                    .offset(y: size.height * 0.08)

                Spacer(minLength: 4)

                IntroCardView(pages: pages, currentPage: $currentPage, pageTransitionDirection: $pageTransitionDirection, onLetsPlay: onLetsPlay, width: cardWidth, height: cardHeight)
                    .padding(.trailing, size.width * 0.08)
            }
            .frame(width: size.width, height: size.height)

            skipButton
                .padding(.top, 34)
                .padding(.trailing, 46)
        }
    }

    private func portraitLayout(size: CGSize, cardWidth: CGFloat, cardHeight: CGFloat) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 12) {
                Spacer(minLength: 28)

                IntroCardView(pages: pages, currentPage: $currentPage, pageTransitionDirection: $pageTransitionDirection, onLetsPlay: onLetsPlay, width: cardWidth, height: cardHeight)

                mascotView(width: min(size.width * 0.58, 330))
                    .offset(y: -4)

                Spacer(minLength: 18)
            }
            .frame(width: size.width, height: size.height)

            skipButton
                .padding(.top, 28)
                .padding(.trailing, 24)
        }
    }

    // MARK: - Components
    private var skipButton: some View {
        Button("Skip") {
            SoundEffectPlayer.shared.play(named: "ClickNextIntro", fileExtension: "m4a")
            pageTransitionDirection = 1
            withAnimation(.spring(response: 0.52, dampingFraction: 0.9)) {
                currentPage = pages.count - 1
            }
        }
        .font(.system(size: 18, weight: .heavy, design: .rounded))
        .foregroundStyle(Color(red: 1.0, green: 0.84, blue: 0.22))
        .padding(.horizontal, 22)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.15), in: Capsule())
        .overlay(Capsule().stroke(Color(red: 1.0, green: 0.76, blue: 0.25).opacity(0.8), lineWidth: 2))
        .shadow(color: Color.black.opacity(0.24), radius: 10, x: 0, y: 5)
    }

    private func mascotView(width: CGFloat) -> some View {
        ZStack {
            Ellipse()
                .fill(Color.purple.opacity(0.42))
                .frame(width: width * 1.18, height: width * 0.68)
                .blur(radius: 28)
                .offset(y: width * 0.24)
                .blendMode(.screen)

            LandingSparkleField(count: 10)
                .frame(width: width * 1.18, height: width * 1.18)
                .clipShape(Ellipse())

            bundledImage("maskotNew")
                .resizable()
                .scaledToFit()
                .frame(width: width)
                .shadow(color: .black.opacity(0.34), radius: 20, x: 0, y: 13)
        }
    }

    private func playIntroSound(for page: Int) {
        SoundEffectPlayer.shared.playIntro(pageIndex: page)
    }

    private func bundledImage(_ name: String) -> Image {
        if let uiImage = UIImage(named: name) { return Image(uiImage: uiImage) }
        return Image(name)
    }
}

#Preview {
    LandingPage()
}
