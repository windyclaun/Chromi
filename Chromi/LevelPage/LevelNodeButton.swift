//
//  LevelNodeButton.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 15/07/26.
//

import SwiftUI

struct LevelNodeButton: View {
    let level: LevelNode
    let position: CGPoint
    let onSelect: (LevelNode) -> Void
    @State private var isFloating = false

    var body: some View {
        Button {
            if level.isUnlocked {
                SoundEffectPlayer.shared.play(named: "clickLevel", fileExtension: "wav")
                onSelect(level)
            }
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    NodeSparkleField(isUnlocked: level.isUnlocked)
                        .frame(width: 136, height: 136)

                    if level.isUnlocked {
                        unlockedNode
                    } else {
                        lockedNode
                    }
                }
                .frame(width: 136, height: 136)
                .offset(y: isFloating ? -3 : 3)
                .rotationEffect(.degrees(isFloating ? 1.6 : -1.6))
                .animation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true), value: isFloating)
                .onAppear {
                    isFloating = true
                }

                Text(level.title)
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.white, Color(red: 1.0, green: 0.94, blue: 0.62)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.68)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.14), in: Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.22), lineWidth: 1))
                    .shadow(color: Color.purple.opacity(0.55), radius: 5, x: 0, y: 2)
            }
            .frame(width: 150, height: 150)
        }
        .buttonStyle(LevelButtonStyle())
        .disabled(!level.isUnlocked)
        .position(position)
    }

    private var unlockedNode: some View {
        ZStack {
            Circle()
                .fill(unlockedOuterGradient)
                .frame(width: 102, height: 102)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.82), lineWidth: 3)
                )
                .shadow(color: glowColor, radius: 26, x: 0, y: 0)
                .shadow(color: Color.black.opacity(0.26), radius: 10, x: 0, y: 8)

            Circle()
                .fill(unlockedInnerGradient)
                .frame(width: 78, height: 78)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.34), lineWidth: 2)
                )

            Text("\(level.id)")
                .font(.system(size: 38, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 0.98, green: 0.9, blue: 1.0),
                            Color(red: 0.78, green: 0.28, blue: 1.0),
                            Color(red: 0.34, green: 0.06, blue: 0.62)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    Text("\(level.id)")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundStyle(Color(red: 0.18, green: 0.02, blue: 0.36).opacity(0.24))
                        .offset(x: 1.6, y: 2.2)
                )
                .shadow(color: Color.white.opacity(0.72), radius: 2, x: 0, y: 1)
                .shadow(color: Color(red: 0.52, green: 0.0, blue: 0.9).opacity(0.48), radius: 6, x: 0, y: 3)
                .rotationEffect(.degrees(level.id.isMultiple(of: 2) ? -6 : 4))
                .offset(y: 4)

            Circle()
                .fill(Color.white.opacity(0.22))
                .frame(width: 18, height: 18)
                .blur(radius: 2)
                .offset(x: -18, y: -22)
        }
    }

    private var lockedNode: some View {
        ZStack {
            Circle()
                .fill(lockedOuterGradient)
                .frame(width: 102, height: 102)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.82), lineWidth: 3)
                )
                .shadow(color: glowColor, radius: 16, x: 0, y: 0)
                .shadow(color: Color.black.opacity(0.26), radius: 10, x: 0, y: 8)

            Circle()
                .fill(lockedInnerGradient)
                .frame(width: 78, height: 78)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )

            VStack(spacing: 4) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 28, weight: .black))
                    .foregroundStyle(Color.white.opacity(0.94))
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)

                Text("\(level.id)")
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.white, Color(red: 1.0, green: 0.9, blue: 0.55)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
            }
            .offset(y: 8)

            Circle()
                .fill(Color.white.opacity(0.18))
                .frame(width: 16, height: 16)
                .blur(radius: 2)
                .offset(x: -16, y: -18)
        }
    }

    // MARK: - Helper Styling Colors
    private var unlockedOuterGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.82, blue: 0.24),
                Color(red: 0.94, green: 0.42, blue: 0.16),
                Color(red: 0.74, green: 0.32, blue: 1.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var lockedOuterGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.48),
                Color.gray.opacity(0.72),
                Color(red: 0.22, green: 0.18, blue: 0.32)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var unlockedInnerGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.58),
                Color(red: 1.0, green: 0.9, blue: 0.45).opacity(0.6)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var lockedInnerGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.24),
                Color.gray.opacity(0.38)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var glowColor: Color {
        level.isUnlocked ? Color(red: 1.0, green: 0.78, blue: 0.24).opacity(0.58) : Color.black.opacity(0.2)
    }

}

private struct NodeSparkleField: View {
    let isUnlocked: Bool

    private let sparkles: [NodeSparkle] = [
        NodeSparkle(x: 0.16, y: 0.22, size: 14, delay: 0.0, speed: 1.25),
        NodeSparkle(x: 0.84, y: 0.18, size: 12, delay: 0.5, speed: 1.55),
        NodeSparkle(x: 0.10, y: 0.76, size: 11, delay: 0.9, speed: 1.45),
        NodeSparkle(x: 0.82, y: 0.82, size: 13, delay: 1.3, speed: 1.65),
        NodeSparkle(x: 0.50, y: 0.04, size: 10, delay: 1.6, speed: 1.2)
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
        .allowsHitTesting(false)
    }

    private func drawSparkle(_ sparkle: NodeSparkle, time: TimeInterval, size: CGSize, context: inout GraphicsContext) {
        let phase = sin((time + sparkle.delay) * sparkle.speed * .pi)
        let scale = 0.8 + (phase + 1) * 0.18
        let opacity = isUnlocked ? 0.45 + (phase + 1) * 0.22 : 0.2 + (phase + 1) * 0.1
        let center = CGPoint(x: size.width * sparkle.x, y: size.height * sparkle.y)
        let rect = CGRect(
            x: center.x - sparkle.size * scale / 2,
            y: center.y - sparkle.size * scale / 2,
            width: sparkle.size * scale,
            height: sparkle.size * scale
        )

        context.opacity = opacity
        context.fill(NodeStarShape().path(in: rect), with: .color(isUnlocked ? Color.yellow : Color.white))
    }
}

private struct NodeSparkle {
    let x: Double
    let y: Double
    let size: CGFloat
    let delay: Double
    let speed: Double
}

private struct NodeStarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let points = 8
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.36

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
