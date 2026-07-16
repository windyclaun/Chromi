//
//  HomePageEffects.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 16/07/26.
//

import SwiftUI

struct Sparkle {
    let x: Double
    let y: Double
    let size: CGFloat
    let delay: Double
    let speed: Double
}

struct AnimatedStartButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .brightness(configuration.isPressed ? 0.08 : 0)
            .shadow(color: Color.yellow.opacity(configuration.isPressed ? 0.75 : 0.5), radius: configuration.isPressed ? 28 : 18, x: 0, y: 0)
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0.2 : 0.36), radius: 0, x: 0, y: configuration.isPressed ? 4 : 9)
            .animation(.spring(response: 0.24, dampingFraction: 0.48), value: configuration.isPressed)
    }
}

struct SparkleHalo: View {
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
        let rect = CGRect(x: center.x - sparkle.size * scale / 2, y: center.y - sparkle.size * scale / 2, width: sparkle.size * scale, height: sparkle.size * scale)

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

struct SparkleField: View {
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

    private func fractional(_ value: Double) -> Double { value - floor(value) }
}

struct StarShape: Shape {
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

            if index == 0 { path.move(to: point) }
            else { path.addLine(to: point) }
        }
        path.closeSubpath()
        return path
    }
}
