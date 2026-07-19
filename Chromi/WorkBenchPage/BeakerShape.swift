//
//  BeakerShape.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 19/07/26.
//

import SwiftUI

struct BeakerShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let neckWidth = rect.width * 0.38
        let neckMinX = rect.midX - neckWidth * 0.5
        let neckMaxX = rect.midX + neckWidth * 0.5
        let neckBottomY = rect.minY + rect.height * 0.38
        let baseInset = rect.width * 0.08

        path.move(to: CGPoint(x: neckMinX, y: rect.minY))
        path.addLine(to: CGPoint(x: neckMaxX, y: rect.minY))
        path.addLine(to: CGPoint(x: neckMaxX, y: neckBottomY))
        path.addLine(to: CGPoint(x: rect.maxX - baseInset, y: rect.maxY - 14))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - 24, y: rect.maxY),
            control: CGPoint(x: rect.maxX - baseInset, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: rect.minX + 24, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + baseInset, y: rect.maxY - 14),
            control: CGPoint(x: rect.minX + baseInset, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: neckMinX, y: neckBottomY))
        path.closeSubpath()

        return path
    }
}
