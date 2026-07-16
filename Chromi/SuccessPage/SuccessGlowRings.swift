//
//  SuccessGlowRings.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 16/07/26.
//

import SwiftUI

struct SuccessGlowRings: View {
    let size: CGFloat

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate

            ZStack {
                ForEach(0..<5, id: \.self) { index in
                    let progress = CGFloat((time * 0.55 + Double(index) * 0.18).truncatingRemainder(dividingBy: 1.0))
                    let scale = 0.7 + progress * 0.65
                    let opacity = 0.34 * (1 - progress)

                    RoundedRectangle(cornerRadius: size * 0.32, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(opacity),
                                    Color.yellow.opacity(opacity),
                                    Color.purple.opacity(opacity)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2.6
                        )
                        .frame(width: size * 1.04, height: size * 1.22)
                        .scaleEffect(scale)
                        .shadow(color: Color.yellow.opacity(opacity), radius: 12, x: 0, y: 0)
                }
            }
        }
        .allowsHitTesting(false)
    }
}
