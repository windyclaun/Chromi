//
//  ContentView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 14/07/26.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var showLandingPage = false

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height

            ZStack {
                bundledImage("bg_homepage.jpeg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .ignoresSafeArea()

                RadialGradient(
                    colors: [Color.yellow.opacity(0.18), Color.clear],
                    center: .center,
                    startRadius: 20,
                    endRadius: min(geometry.size.width, geometry.size.height) * 0.55
                )
                .blendMode(.screen)
                .ignoresSafeArea()

                SparkleField(count: isLandscape ? 18 : 14)
                    .ignoresSafeArea()

                if isLandscape {
                    landscapeContent(in: geometry.size)
                } else {
                    portraitContent(in: geometry.size)
                }
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showLandingPage) {
            LandingPage {
                showLandingPage = false
            }
        }
    }

    private func landscapeContent(in size: CGSize) -> some View {
        HStack(spacing: 18) {
            Spacer(minLength: 12)

            ZStack {
                glowBlob(color: .purple, width: min(size.width * 0.34, 390), height: min(size.width * 0.28, 320))

                SparkleHalo(width: min(size.width * 0.34, 390), height: min(size.width * 0.32, 360))

                bundledImage("maskot")
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

                bundledImage("maskot")
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

    private func glowBlob(color: Color, width: CGFloat, height: CGFloat) -> some View {
        Ellipse()
            .fill(color.opacity(0.28))
            .frame(width: width, height: height)
            .blur(radius: 34)
            .blendMode(.screen)
    }

    private func bundledImage(_ name: String) -> Image {
        if let image = UIImage(named: name) {
            return Image(uiImage: image)
        }

        return Image(name)
    }

    private func startButton(width: CGFloat) -> some View {
        Button(action: startGame) {
            HStack(spacing: 10) {
                Image(systemName: "play.fill")
                    .font(.system(size: 25, weight: .bold))

                Text("START")
                    .font(.system(size: 35, weight: .heavy, design: .rounded))
            }
            .foregroundStyle(Color(red: 0.24, green: 0.1, blue: 0.55))
            .frame(width: width, height: 78)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 1.0, green: 0.92, blue: 0.08),
                        Color(red: 0.92, green: 0.66, blue: 0.09)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.75), lineWidth: 5)
            )
            .overlay(alignment: .topLeading) {
                Capsule()
                    .fill(Color.white.opacity(0.28))
                    .frame(height: 22)
                    .padding(.horizontal, 18)
                    .padding(.top, 8)
            }
        }
        .buttonStyle(AnimatedStartButtonStyle())
    }

    private func startGame() {
        showLandingPage = true
    }
}

private struct AnimatedStartButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .brightness(configuration.isPressed ? 0.08 : 0)
            .shadow(color: Color.yellow.opacity(configuration.isPressed ? 0.75 : 0.5), radius: configuration.isPressed ? 28 : 18, x: 0, y: 0)
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0.2 : 0.36), radius: 0, x: 0, y: configuration.isPressed ? 4 : 9)
            .animation(.spring(response: 0.24, dampingFraction: 0.48), value: configuration.isPressed)
    }
}

private struct SparkleHalo: View {
    let width: CGFloat
    let height: CGFloat

    private let sparkles: [Sparkle] = [
        Sparkle(x: 0.08, y: 0.2, size: 18, delay: 0.0, speed: 1.4),
        Sparkle(x: 0.86, y: 0.14, size: 13, delay: 0.4, speed: 1.7),
        Sparkle(x: 0.18, y: 0.82, size: 12, delay: 0.9, speed: 1.5),
        Sparkle(x: 0.92, y: 0.72, size: 17, delay: 1.2, speed: 1.8),
        Sparkle(x: 0.52, y: 0.02, size: 10, delay: 1.6, speed: 1.3)
    ]

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate

                for sparkle in sparkles {
                    drawSparkle(sparkle, time: time, size: size, context: &context)
                }
            }
        }
        .frame(width: width, height: height)
        .allowsHitTesting(false)
    }

    private func drawSparkle(_ sparkle: Sparkle, time: TimeInterval, size: CGSize, context: inout GraphicsContext) {
        let phase = sin((time + sparkle.delay) * sparkle.speed * .pi)
        let scale = 0.75 + (phase + 1) * 0.22
        let opacity = 0.45 + (phase + 1) * 0.25
        let rotation = Angle.radians((time + sparkle.delay) * sparkle.speed)
        let center = CGPoint(x: size.width * sparkle.x, y: size.height * sparkle.y)
        let rect = CGRect(
            x: center.x - sparkle.size * scale / 2,
            y: center.y - sparkle.size * scale / 2,
            width: sparkle.size * scale,
            height: sparkle.size * scale
        )

        context.opacity = opacity
        context.translateBy(x: center.x, y: center.y)
        context.rotate(by: rotation)
        context.translateBy(x: -center.x, y: -center.y)
        context.fill(StarShape().path(in: rect), with: .color(Color.yellow))
        context.opacity = opacity * 0.55
        context.stroke(StarShape().path(in: rect.insetBy(dx: -2, dy: -2)), with: .color(Color.white), lineWidth: 1.2)
        context.transform = .identity
    }
}

private struct SparkleField: View {
    let count: Int

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate

                for index in 0..<count {
                    let sparkle = Sparkle(
                        x: fractional(Double(index) * 0.271 + 0.12),
                        y: fractional(Double(index) * 0.413 + 0.18),
                        size: CGFloat(7 + (index % 4) * 4),
                        delay: Double(index) * 0.31,
                        speed: 0.7 + Double(index % 5) * 0.12
                    )

                    let drift = CGFloat(sin((time + sparkle.delay) * sparkle.speed)) * 14
                    let opacity = 0.18 + (sin((time + sparkle.delay) * sparkle.speed * .pi) + 1) * 0.2
                    let center = CGPoint(x: size.width * sparkle.x + drift, y: size.height * sparkle.y - drift * 0.4)
                    let rect = CGRect(x: center.x - sparkle.size / 2, y: center.y - sparkle.size / 2, width: sparkle.size, height: sparkle.size)

                    context.opacity = opacity
                    context.fill(StarShape().path(in: rect), with: .color(index.isMultiple(of: 3) ? Color.white : Color.yellow))
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func fractional(_ value: Double) -> Double {
        value - floor(value)
    }
}

private struct Sparkle {
    let x: Double
    let y: Double
    let size: CGFloat
    let delay: Double
    let speed: Double
}

private struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let points = 8
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.28

        for index in 0..<(points * 2) {
            let radius = index.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = CGFloat(index) * .pi / CGFloat(points) - .pi / 2
            let point = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )

            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()
        return path
    }
}

#Preview {
    ContentView()
}
