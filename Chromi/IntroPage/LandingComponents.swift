//
//  LandingComponents.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 15/07/26.
//

import SwiftUI

struct LandingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .brightness(configuration.isPressed ? 0.08 : 0)
            .shadow(color: Color.purple.opacity(configuration.isPressed ? 0.65 : 0.35), radius: configuration.isPressed ? 20 : 12, x: 0, y: configuration.isPressed ? 4 : 8)
            .animation(.spring(response: 0.22, dampingFraction: 0.52), value: configuration.isPressed)
    }
}

struct LandingSparkleCorners: View {
    var body: some View {
        VStack {
            HStack {
                sparkle
                Spacer()
                sparkle
            }
            Spacer()
            HStack {
                sparkle
                Spacer()
                sparkle
            }
        }
    }

    private var sparkle: some View {
        Text("✦")
            .font(.system(size: 26, weight: .black))
            .foregroundStyle(Color(red: 1.0, green: 0.83, blue: 0.26))
            .shadow(color: .yellow.opacity(0.45), radius: 8, x: 0, y: 0)
    }
}

struct LandingSparkleField: View {
    let count: Int

    var body: some View {
        TimelineView(.animation) { timeline in
            GeometryReader { geometry in
                let time = timeline.date.timeIntervalSinceReferenceDate

                ZStack {
                    ForEach(0..<count, id: \.self) { index in
                        let x = fractional(Double(index) * 0.283 + 0.08)
                        let y = fractional(Double(index) * 0.419 + 0.12)
                        let baseSize = CGFloat(6 + (index % 5) * 3)
                        let speed = 0.7 + Double(index % 6) * 0.12
                        let phase = sin((time + Double(index) * 0.24) * speed * .pi)
                        let pulse = (phase + 1) * 0.5
                        let driftX = CGFloat(phase) * 16
                        let driftY = CGFloat(cos((time * 0.8) + Double(index) * 0.37)) * 7
                        let rotation = Angle.degrees(Double(phase) * 24 + Double(index % 8) * 6)
                        let scale = 0.72 + pulse * 0.52
                        let opacity = 0.22 + pulse * 0.52
                        let glow = 6 + pulse * 10

                        LandingStarShape()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white,
                                        index.isMultiple(of: 3) ? Color.yellow.opacity(0.96) : Color(red: 1.0, green: 0.88, blue: 0.28)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: baseSize, height: baseSize)
                            .scaleEffect(scale)
                            .rotationEffect(rotation)
                            .position(x: geometry.size.width * x + driftX, y: geometry.size.height * y + driftY)
                            .opacity(opacity)
                            .shadow(color: Color.yellow.opacity(opacity), radius: glow, x: 0, y: 0)
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func fractional(_ value: Double) -> Double {
        value - floor(value)
    }
}

struct LandingStarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let points = 8
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.36
        let adjustment = outerRadius * 0.08

        var path = Path()

        for index in 0..<(points * 2) {
            let isOuter = index.isMultiple(of: 2)
            let radius = isOuter ? outerRadius : innerRadius
            let angle = CGFloat(index) * .pi / CGFloat(points) - .pi / 2
            let point = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )

            if index == 0 {
                path.move(to: point)
            } else {
                let previousAngle = CGFloat(index - 1) * .pi / CGFloat(points) - .pi / 2
                let controlRadius = isOuter ? radius - adjustment : radius + adjustment
                let controlPoint = CGPoint(
                    x: center.x + cos(previousAngle + .pi / CGFloat(points)) * controlRadius,
                    y: center.y + sin(previousAngle + .pi / CGFloat(points)) * controlRadius
                )
                path.addQuadCurve(to: point, control: controlPoint)
            }
        }

        path.closeSubpath()
        return path
    }
}
