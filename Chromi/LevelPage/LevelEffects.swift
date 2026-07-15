//
//  LevelEffects.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 15/07/26.
//

import SwiftUI

struct LevelButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .brightness(configuration.isPressed ? 0.08 : 0)
            .animation(.spring(response: 0.24, dampingFraction: 0.56), value: configuration.isPressed)
    }
}

struct MagicEffectsField: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate

                for index in 0..<16 {
                    let x = fractional(Double(index) * 0.293 + 0.11)
                    let y = fractional(Double(index) * 0.417 + 0.08)
                    let phase = CGFloat((sin(time * (0.55 + Double(index % 5) * 0.06) + Double(index)) + 1) / 2)
                    let drift = CGFloat(sin(time * 0.38 + Double(index))) * 10
                    let center = CGPoint(x: size.width * x + drift, y: size.height * y - drift * 0.24)
                    let starSize = CGFloat(4 + (index % 4) * 2) + phase * 2
                    let rect = CGRect(x: center.x - starSize / 2, y: center.y - starSize / 2, width: starSize, height: starSize)

                    context.opacity = 0.08 + phase * 0.14
                    context.fill(LandingStarShape().path(in: rect), with: .color(index.isMultiple(of: 4) ? Color.white : Color(red: 1.0, green: 0.82, blue: 0.24)))
                }

                for index in 0..<7 {
                    let phase = time * (0.18 + Double(index) * 0.03) + Double(index)
                    let x = size.width * (0.14 + CGFloat(index) * 0.12) + CGFloat(sin(phase * 1.4)) * 22
                    let y = size.height * (0.18 + CGFloat(index % 4) * 0.17) + CGFloat(cos(phase)) * 18
                    let radius = 10 + CGFloat(index % 3) * 6
                    let rect = CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)

                    context.opacity = 0.08 + CGFloat((sin(phase * 2) + 1) / 2) * 0.14
                    context.fill(Ellipse().path(in: rect), with: .color(index.isMultiple(of: 2) ? Color.white : Color(red: 1.0, green: 0.85, blue: 0.32)))
                }

                let cometPaths: [(CGFloat, CGFloat, CGFloat)] = [
                    (0.08, 0.22, 0.0),
                    (0.76, 0.64, 1.8)
                ]

                for comet in cometPaths {
                    let travel = CGFloat((time * 0.16 + Double(comet.2)).truncatingRemainder(dividingBy: 1.0))
                    let x = size.width * (comet.0 + travel * 0.18)
                    let y = size.height * (comet.1 + sin(time * 0.4 + Double(comet.2)) * 0.04)
                    let tail = Path { path in
                        path.move(to: CGPoint(x: x - 56, y: y + 18))
                        path.addQuadCurve(to: CGPoint(x: x - 26, y: y + 6), control: CGPoint(x: x, y: y))
                    }

                    context.stroke(tail, with: .color(Color(red: 1.0, green: 0.84, blue: 0.22).opacity(0.28)), style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    context.stroke(tail, with: .color(Color.white.opacity(0.34)), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    context.fill(Ellipse().path(in: CGRect(x: x - 7, y: y - 7, width: 14, height: 14)), with: .color(.white))
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func fractional(_ value: Double) -> Double { value - floor(value) }
}
