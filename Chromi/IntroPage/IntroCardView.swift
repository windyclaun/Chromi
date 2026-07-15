//
//  IntroCardView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 15/07/26.
//

import SwiftUI

struct IntroCardView: View {
    let pages: [IntroPage]
    @Binding var currentPage: Int
    @Binding var pageTransitionDirection: Int
    var onLetsPlay: () -> Void

    @State private var dragOffset: CGFloat = 0
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        let page = pages[currentPage]
        let isLastPage = currentPage == pages.count - 1

        ZStack {
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(Color(red: 1.0, green: 0.97, blue: 0.88))
                .shadow(color: Color.yellow.opacity(0.56), radius: 26, x: 0, y: 0)
                .shadow(color: Color.purple.opacity(0.28), radius: 28, x: 0, y: 12)
                .shadow(color: Color.black.opacity(0.24), radius: 18, x: 0, y: 14)
                .overlay(
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.yellow, Color(red: 1.0, green: 0.75, blue: 0.23), Color.purple.opacity(0.55)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 5
                        )
                )

            LandingSparkleField(count: 12)
                .clipShape(RoundedRectangle(cornerRadius: 34, style: .continuous))
                .opacity(0.95)

            LandingSparkleCorners()
                .padding(18)

            VStack(spacing: 16) {
                VStack(spacing: 16) {
                    fruitStoryView(page: page)
                        .frame(height: height * 0.24)

                    Text(page.accent)
                        .font(.system(size: width > 420 ? 50 : 40))
                        .scaleEffect(isLastPage ? 1.1 : 1.0)
                        .shadow(color: .yellow.opacity(0.55), radius: 12, x: 0, y: 0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: currentPage)

                    VStack(spacing: 8) {
                        Text(page.title)
                            .font(.system(size: width > 420 ? 21 : 18, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(red: 0.18, green: 0.08, blue: 0.45))
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                            .minimumScaleFactor(0.66)

                        Text(page.detail)
                            .font(.system(size: width > 420 ? 16 : 14, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(red: 0.42, green: 0.3, blue: 0.68))
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                            .minimumScaleFactor(0.66)
                    }
                    .padding(.horizontal, width * 0.1)
                }
                .id(currentPage)
                .transition(pageContentTransition)

                pageDots

                if isLastPage {
                    letsPlayButton(width: min(width * 0.5, 250))
                } else {
                    navigationButtons(nextWidth: min(width * 0.42, 220))
                }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 24)
        }
        .frame(width: width, height: height)
        .offset(x: dragOffset * 0.16)
        .rotationEffect(.degrees(Double(dragOffset / width) * 2.4))
        .contentShape(RoundedRectangle(cornerRadius: 34, style: .continuous))
        .gesture(cardDragGesture)
        .animation(.spring(response: 0.42, dampingFraction: 0.82), value: currentPage)
        .animation(.interactiveSpring(response: 0.24, dampingFraction: 0.84), value: dragOffset)
    }

    // MARK: - Subviews & Logics
    private var pageContentTransition: AnyTransition {
        let travel = CGFloat(pageTransitionDirection) * 28
        return .asymmetric(
            insertion: .offset(x: travel).combined(with: .opacity).combined(with: .scale(scale: 0.98)),
            removal: .offset(x: -travel).combined(with: .opacity).combined(with: .scale(scale: 0.98))
        )
    }

    private func fruitStoryView(page: IntroPage) -> some View {
        HStack(spacing: 28) {
            FruitIcon(systemName: page.leftFruit, isColored: false)
            Image(systemName: "sparkles").font(.system(size: 19, weight: .heavy)).foregroundStyle(Color.yellow).offset(y: -18)
            Image(systemName: "arrow.right")
                .font(.system(size: 34, weight: .heavy))
                .foregroundStyle(Color(red: 0.45, green: 0.22, blue: 0.82))
                .symbolEffect(.pulse, value: currentPage)
                .shadow(color: Color.purple.opacity(0.28), radius: 8, x: 0, y: 4)
            Image(systemName: "sparkles").font(.system(size: 17, weight: .heavy)).foregroundStyle(Color.yellow.opacity(0.9)).offset(y: 18)
            FruitIcon(systemName: page.rightFruit, isColored: page.isColored)
        }
    }

    private var pageDots: some View {
        HStack(spacing: 9) {
            ForEach(pages.indices, id: \.self) { index in
                Button { moveToPage(index) } label: {
                    Capsule()
                        .fill(index == currentPage ? Color(red: 0.45, green: 0.2, blue: 0.82) : Color(red: 0.78, green: 0.62, blue: 1.0))
                        .frame(width: index == currentPage ? 30 : 10, height: 10)
                        .shadow(color: index == currentPage ? Color.purple.opacity(0.35) : .clear, radius: 6, x: 0, y: 0)
                }
                .buttonStyle(.plain)
                .animation(.spring(response: 0.28, dampingFraction: 0.72), value: currentPage)
            }
        }
    }

    private func navigationButtons(nextWidth: CGFloat) -> some View {
        HStack(spacing: 14) {
            if currentPage > 0 {
                Button(action: goToPreviousPage) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundStyle(Color(red: 0.38, green: 0.16, blue: 0.72))
                        .frame(width: 50, height: 50)
                        .background(Color.white.opacity(0.88), in: Circle())
                        .overlay(Circle().stroke(Color.purple.opacity(0.28), lineWidth: 3))
                }
                .buttonStyle(LandingButtonStyle())
                .transition(.scale.combined(with: .opacity))
            }
            nextButton(width: nextWidth)
        }
    }

    private func nextButton(width: CGFloat) -> some View {
        Button(action: {
            SoundEffectPlayer.shared.play(named: "ClickNextIntro", fileExtension: "mp3")
            goToNextPage()
        }) {
            ZStack {
                Capsule().fill(LinearGradient(colors: [Color(red: 1.0, green: 0.78, blue: 0.24), Color(red: 0.74, green: 0.32, blue: 1.0), Color(red: 0.42, green: 0.16, blue: 0.86)], startPoint: .topLeading, endPoint: .bottomTrailing))
                Capsule().fill(Color.white.opacity(0.26)).frame(height: 18).padding(.horizontal, 18).padding(.top, 7).frame(maxHeight: .infinity, alignment: .top)
                HStack(spacing: 10) {
                    Text("Next")
                    Image(systemName: "arrow.right.circle.fill").font(.system(size: 24, weight: .black))
                }
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
            }
            .frame(width: width, height: 58)
            .overlay(Capsule().stroke(Color.white.opacity(0.48), lineWidth: 3))
            .shadow(color: Color.purple.opacity(0.45), radius: 18, x: 0, y: 10)
        }
        .buttonStyle(LandingButtonStyle())
    }

    private func letsPlayButton(width: CGFloat) -> some View {
        Button(action: {
            SoundEffectPlayer.shared.play(named: "ClickStartSound", fileExtension: "wav")
            onLetsPlay()
        }) {
            HStack(spacing: 9) {
                Text("Let's Play!")
                Image(systemName: "gamecontroller.fill")
            }
            .font(.system(size: 18, weight: .heavy, design: .rounded))
            .foregroundStyle(.white)
            .frame(width: width, height: 56)
            .background(LinearGradient(colors: [Color(red: 1.0, green: 0.75, blue: 0.2), Color(red: 0.68, green: 0.38, blue: 1.0), Color(red: 0.42, green: 0.2, blue: 0.82)], startPoint: .topLeading, endPoint: .bottomTrailing), in: Capsule())
            .overlay(Capsule().stroke(Color.white.opacity(0.38), lineWidth: 3))
        }
        .buttonStyle(LandingButtonStyle())
    }

    private var cardDragGesture: some Gesture {
        DragGesture(minimumDistance: 18)
            .onChanged { value in dragOffset = value.translation.width }
            .onEnded { value in
                let threshold: CGFloat = 55
                if value.translation.width < -threshold { goToNextPage() }
                else if value.translation.width > threshold { goToPreviousPage() }
                dragOffset = 0
            }
    }

    private func goToNextPage() { moveToPage(min(currentPage + 1, pages.count - 1)) }
    private func goToPreviousPage() { moveToPage(max(currentPage - 1, 0)) }

    private func moveToPage(_ page: Int) {
        let targetPage = min(max(page, 0), pages.count - 1)
        guard targetPage != currentPage else { return }
        pageTransitionDirection = targetPage > currentPage ? 1 : -1
        withAnimation(.spring(response: 0.52, dampingFraction: 0.9, blendDuration: 0.08)) {
            currentPage = targetPage
        }
    }
}
