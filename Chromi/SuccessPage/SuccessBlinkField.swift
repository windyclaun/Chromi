//
//  SuccessBlinkField.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 16/07/26.
//

import SwiftUI

struct SuccessBlinkField: View {
    let count: Int

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate

                for index in 0..<count {
                    let column = CGFloat((index * 37) % 100) / 100
                    let row = CGFloat((index * 61) % 100) / 100
                    let phase = sin(time * (1.2 + Double(index % 5) * 0.18) + Double(index))
                    let sparkleSize = CGFloat(4 + (index % 4) * 2) + CGFloat((phase + 1) * 1.6)
                    let rect = CGRect(
                        x: size.width * column,
                        y: size.height * row,
                        width: sparkleSize,
                        height: sparkleSize
                    )

                    context.opacity = 0.14 + CGFloat((phase + 1) / 2) * 0.42
                    context.fill(
                        LandingStarShape().path(in: rect),
                        with: .color(index.isMultiple(of: 3) ? Color.yellow : Color.white)
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}
