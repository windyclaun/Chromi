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
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate

                for index in 0..<count {
                    let x = fractional(Double(index) * 0.283 + 0.08)
                    let y = fractional(Double(index) * 0.419 + 0.12)
                    let baseSize = CGFloat(5 + (index % 5) * 3)
                    let speed = 0.65 + Double(index % 6) * 0.1
                    let phase = sin((time + Double(index) * 0.24) * speed * .pi)
                    let drift = CGFloat(phase) * 13
                    let opacity = 0.18 + (phase + 1) * 0.2
                    let center = CGPoint(x: size.width * x + drift, y: size.height * y - drift * 0.34)
                    let rect = CGRect(x: center.x - baseSize / 2, y: center.y - baseSize / 2, width: baseSize, height: baseSize)

                    context.opacity = opacity
                    context.fill(LandingStarShape().path(in: rect), with: .color(index.isMultiple(of: 3) ? Color.white : Color.yellow))
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
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let points = 8
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.28

        for index in 0..<(points * 2) {
            let radius = index.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = CGFloat(index) * .pi / CGFloat(points) - .pi / 2
            let point = CGPoint(x: center.x + cos(angle) * radius, y: center.y + sin(angle) * radius)

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
