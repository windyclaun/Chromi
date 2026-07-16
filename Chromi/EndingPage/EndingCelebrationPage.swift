//
//  EndingCelebrationViews.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 16/07/26.
//

import SwiftUI

struct CelebrationEmojiField: View {
    let isLandscape: Bool

    private let items: [CelebrationEmoji] = [
        CelebrationEmoji(symbol: "🎉", x: 0.18, y: 0.24, size: 42, delay: 0.0, radius: 36),
        CelebrationEmoji(symbol: "🎊", x: 0.82, y: 0.24, size: 44, delay: 0.4, radius: 42),
        CelebrationEmoji(symbol: "🥳", x: 0.28, y: 0.54, size: 38, delay: 0.8, radius: 34),
        CelebrationEmoji(symbol: "🎉", x: 0.72, y: 0.55, size: 38, delay: 1.1, radius: 38),
        CelebrationEmoji(symbol: "🎊", x: 0.42, y: 0.18, size: 34, delay: 1.5, radius: 30),
        CelebrationEmoji(symbol: "✨", x: 0.58, y: 0.18, size: 34, delay: 1.8, radius: 28),
        CelebrationEmoji(symbol: "🎉", x: 0.12, y: 0.72, size: 34, delay: 2.0, radius: 34),
        CelebrationEmoji(symbol: "🎊", x: 0.88, y: 0.72, size: 34, delay: 2.4, radius: 34)
    ]

    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { timeline in
                let time = timeline.date.timeIntervalSinceReferenceDate

                ZStack {
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]
                        let phase = time * 1.25 + item.delay
                        let burst = CGFloat((sin(phase) + 1) / 2)
                        let x = item.x + cos(phase * 1.4) * 0.018
                        let y = item.y + sin(phase * 1.1) * 0.026

                        Text(item.symbol)
                            .font(.system(size: item.size + burst * 10))
                            .rotationEffect(.degrees(sin(phase) * 18))
                            .scaleEffect(0.88 + burst * 0.28)
                            .shadow(color: Color.yellow.opacity(0.5), radius: 10, x: 0, y: 0)
                            .position(x: geometry.size.width * x, y: geometry.size.height * y)
                            .opacity(0.72 + burst * 0.28)
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
}

struct CelebrationEmoji {
    let symbol: String
    let x: Double
    let y: Double
    let size: CGFloat
    let delay: Double
    let radius: CGFloat
}

struct EndingBlingField: View {
    let count: Int

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate

                for index in 0..<count {
                    let baseX = fractional(Double(index) * 0.297 + 0.08)
                    let baseY = fractional(Double(index) * 0.431 + 0.13)
                    let speed = 0.65 + Double(index % 6) * 0.08
                    let phase = sin(time * speed + Double(index) * 0.7)
                    let driftX = CGFloat(cos(time * speed + Double(index))) * CGFloat(8 + index % 5)
                    let driftY = CGFloat(sin(time * speed * 0.8 + Double(index))) * CGFloat(7 + index % 4)
                    let center = CGPoint(x: size.width * baseX + driftX, y: size.height * baseY + driftY)
                    let sparkleSize = CGFloat(5 + (index % 5) * 3) + CGFloat((phase + 1) * 1.8)
                    let rect = CGRect(x: center.x - sparkleSize / 2, y: center.y - sparkleSize / 2, width: sparkleSize, height: sparkleSize)

                    context.opacity = 0.18 + CGFloat((phase + 1) / 2) * 0.42
                    if index.isMultiple(of: 4) {
                        context.fill(Ellipse().path(in: rect), with: .color(Color(red: 0.55, green: 0.95, blue: 1.0)))
                    } else {
                        // Pastikan LandingStarShape() sudah terdefinisi di project Anda
                        context.fill(LandingStarShape().path(in: rect), with: .color(index.isMultiple(of: 2) ? Color.white : Color(red: 1.0, green: 0.84, blue: 0.24)))
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
