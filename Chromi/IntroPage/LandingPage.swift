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
            let cardWidth = min(geometry.size.width * (isLandscape ? 0.48 : 0.86), 590)
            let cardHeight = min(geometry.size.height * (isLandscape ? 0.55 : 0.5), isLandscape ? 380 : 440)

            ZStack {
                bundledImage("bg_level.png")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .ignoresSafeArea()

                Color(red: 0.09, green: 0.03, blue: 0.24)
                    .opacity(0.18)
                    .ignoresSafeArea()

                LandingSparkleField(count: isLandscape ? 24 : 18)
                    .ignoresSafeArea()

                if isLandscape {
                    landscapeLayout(size: geometry.size, cardWidth: cardWidth, cardHeight: cardHeight)
                } else {
                    portraitLayout(size: geometry.size, cardWidth: cardWidth, cardHeight: cardHeight)
                }
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }

    private func landscapeLayout(size: CGSize, cardWidth: CGFloat, cardHeight: CGFloat) -> some View {
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .center, spacing: 26) {
                mascotView(width: min(size.width * 0.22, 250))
                    .padding(.top, size.height * 0.24)
                    .offset(y: size.height * 0.1)

                introCard(width: cardWidth, height: cardHeight)
                    .padding(.trailing, size.width * 0.08)
            }
            .frame(width: size.width, height: size.height)

            skipButton
                .padding(.top, 34)
                .padding(.trailing, 210)
        }
    }

    private func portraitLayout(size: CGSize, cardWidth: CGFloat, cardHeight: CGFloat) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 20) {
                Spacer(minLength: 36)

                introCard(width: cardWidth, height: cardHeight)

                mascotView(width: min(size.width * 0.44, 230))
                    .offset(y: 6)

                Spacer(minLength: 24)
            }
            .frame(width: size.width, height: size.height)

            skipButton
                .padding(.top, 28)
                .padding(.trailing, 24)
        }
    }

    private func introCard(width: CGFloat, height: CGFloat) -> some View {
        let page = pages[currentPage]
        let isLastPage = currentPage == pages.count - 1

        return ZStack {
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(Color(red: 1.0, green: 0.97, blue: 0.88))
                .shadow(color: Color.yellow.opacity(0.45), radius: 24, x: 0, y: 0)
                .shadow(color: Color.black.opacity(0.28), radius: 18, x: 0, y: 14)
                .overlay(
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .stroke(Color(red: 1.0, green: 0.8, blue: 0.23), lineWidth: 4)
                )

            LandingSparkleCorners()
                .padding(18)

            VStack(spacing: 18) {
                fruitStoryView(page: page)
                    .frame(height: height * 0.26)

                Text(page.accent)
                    .font(.system(size: width > 420 ? 48 : 38))
                    .scaleEffect(isLastPage ? 1.08 : 1.0)
                    .shadow(color: .yellow.opacity(0.45), radius: 10, x: 0, y: 0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: currentPage)

                VStack(spacing: 8) {
                    Text(page.title)
                        .font(.system(size: width > 420 ? 23 : 18, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(red: 0.18, green: 0.08, blue: 0.45))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .minimumScaleFactor(0.68)

                    Text(page.detail)
                        .font(.system(size: width > 420 ? 17 : 14, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.42, green: 0.3, blue: 0.68))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .minimumScaleFactor(0.68)
                }
                .padding(.horizontal, width * 0.1)

                pageDots

                if isLastPage {
                    letsPlayButton(width: min(width * 0.46, 230))
                } else {
                    nextButton(width: min(width * 0.36, 180))
                }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 24)
            .id(currentPage)
            .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
        }
        .frame(width: width, height: height)
        .contentShape(RoundedRectangle(cornerRadius: 34, style: .continuous))
        .onTapGesture {
            guard !isLastPage else { return }
            goToNextPage()
        }
        .animation(.spring(response: 0.42, dampingFraction: 0.82), value: currentPage)
    }

    private func fruitStoryView(page: IntroPage) -> some View {
        HStack(spacing: 28) {
            FruitIcon(systemName: page.leftFruit, isColored: false)

            Image(systemName: "arrow.right")
                .font(.system(size: 32, weight: .heavy))
                .foregroundStyle(Color(red: 0.45, green: 0.36, blue: 0.66))
                .symbolEffect(.pulse, value: currentPage)

            FruitIcon(systemName: page.rightFruit, isColored: page.isColored)
        }
    }

    private var pageDots: some View {
        HStack(spacing: 9) {
            ForEach(pages.indices, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? Color(red: 0.45, green: 0.2, blue: 0.82) : Color(red: 0.78, green: 0.62, blue: 1.0))
                    .frame(width: index == currentPage ? 28 : 10, height: 10)
                    .shadow(color: index == currentPage ? Color.purple.opacity(0.35) : .clear, radius: 6, x: 0, y: 0)
                    .animation(.spring(response: 0.28, dampingFraction: 0.72), value: currentPage)
            }
        }
    }

    private var skipButton: some View {
        Button("Skip") {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentPage = pages.count - 1
            }
        }
        .font(.system(size: 18, weight: .heavy, design: .rounded))
        .foregroundStyle(Color(red: 1.0, green: 0.84, blue: 0.22))
        .padding(.horizontal, 22)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.13), in: Capsule())
        .overlay(
            Capsule()
                .stroke(Color(red: 1.0, green: 0.76, blue: 0.25).opacity(0.72), lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.24), radius: 10, x: 0, y: 5)
    }

    private func nextButton(width: CGFloat) -> some View {
        Button(action: goToNextPage) {
            HStack(spacing: 8) {
                Text("Next")
                Image(systemName: "chevron.right")
            }
            .font(.system(size: 17, weight: .heavy, design: .rounded))
            .foregroundStyle(.white)
            .frame(width: width, height: 48)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.62, green: 0.34, blue: 0.96), Color(red: 0.42, green: 0.18, blue: 0.78)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: Capsule()
            )
            .overlay(Capsule().stroke(Color.white.opacity(0.28), lineWidth: 3))
        }
        .buttonStyle(LandingButtonStyle())
    }

    private func letsPlayButton(width: CGFloat) -> some View {
        Button(action: onLetsPlay) {
            HStack(spacing: 9) {
                Text("Let's Play!")
                Image(systemName: "gamecontroller.fill")
            }
            .font(.system(size: 18, weight: .heavy, design: .rounded))
            .foregroundStyle(.white)
            .frame(width: width, height: 54)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.68, green: 0.38, blue: 1.0), Color(red: 0.42, green: 0.2, blue: 0.82)],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                in: Capsule()
            )
            .overlay(Capsule().stroke(Color.white.opacity(0.32), lineWidth: 3))
            .shadow(color: Color.purple.opacity(0.45), radius: 16, x: 0, y: 10)
        }
        .buttonStyle(LandingButtonStyle())
    }

    private func mascotView(width: CGFloat) -> some View {
        ZStack {
            Ellipse()
                .fill(Color.purple.opacity(0.34))
                .frame(width: width * 1.1, height: width * 0.62)
                .blur(radius: 24)
                .offset(y: width * 0.24)
                .blendMode(.screen)

            bundledImage("maskot")
                .resizable()
                .scaledToFit()
                .frame(width: width)
                .shadow(color: .black.opacity(0.32), radius: 18, x: 0, y: 12)
        }
    }

    private func goToNextPage() {
        withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
            currentPage = min(currentPage + 1, pages.count - 1)
        }
    }

    private func bundledImage(_ name: String) -> Image {
        if let uiImage = UIImage(named: name) {
            return Image(uiImage: uiImage)
        }
        return Image(name)
    }
}

#Preview {
    LandingPage()
}
