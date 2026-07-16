//
//  ColoringPageComponents.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 16/07/26.
//

import SwiftUI
import UIKit

struct TrianglePointer: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

// Helper Global Function untuk menangani muatan berkas gambar UIImage agar aman dari crash nama ekstensi
func loadBundledImage(_ name: String) -> Image {
    if let image = UIImage(named: name) ?? UIImage(named: name.replacingOccurrences(of: ".png", with: "")) {
        return Image(uiImage: image)
    }
    return Image(name)
}
struct PauseOverlayView: View {
    let onMainMenu: () -> Void
    let onRestart: () -> Void
    let onResume: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(red: 0.09, green: 0.03, blue: 0.22).opacity(0.82)
                    .ignoresSafeArea()

                MagicEffectsField()
                    .opacity(0.58)
                    .blendMode(.screen)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Capsule()
                        .fill(Color(red: 0.88, green: 0.66, blue: 0.34))
                        .frame(width: 280, height: 34)
                        .shadow(color: Color.yellow.opacity(0.18), radius: 10, x: 0, y: 4)
                        .offset(y: 17)
                        .zIndex(1)

                    VStack(spacing: 16) {
                        HStack(spacing: 10) {
                            Image(systemName: "pause.fill")
                            Text("Pause")
                        }
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(Color(red: 0.34, green: 0.07, blue: 0.68))
                        .shadow(color: Color.purple.opacity(0.5), radius: 8, x: 0, y: 4)

                        Rectangle()
                            .fill(Color.white.opacity(0.16))
                            .frame(height: 2)
                            .padding(.horizontal, 28)

                        VStack(spacing: 14) {
                            pauseActionButton(
                                title: "Main Menu",
                                systemImage: "house.fill",
                                colors: [Color(red: 0.54, green: 0.72, blue: 1.0), Color(red: 0.35, green: 0.46, blue: 0.92)],
                                action: onMainMenu
                            )

                            pauseActionButton(
                                title: "Restart",
                                systemImage: "arrow.clockwise",
                                colors: [Color(red: 1.0, green: 0.72, blue: 0.38), Color(red: 0.96, green: 0.46, blue: 0.18)],
                                action: onRestart
                            )

                            pauseActionButton(
                                title: "Resume",
                                systemImage: "play.fill",
                                colors: [Color(red: 0.46, green: 0.94, blue: 0.52), Color(red: 0.18, green: 0.75, blue: 0.38)],
                                action: onResume
                            )
                        }
                        .padding(.horizontal, 44)
                    }
                    .padding(.top, 64)
                    .padding(.bottom, 30)
                    .background(
                        LinearGradient(
                            colors: [Color(red: 1.0, green: 0.96, blue: 0.8), Color(red: 0.92, green: 0.84, blue: 0.58)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        in: RoundedRectangle(cornerRadius: 34, style: .continuous)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 34, style: .continuous)
                            .stroke(Color(red: 0.72, green: 0.44, blue: 0.08), lineWidth: 5)
                    )
                    .shadow(color: Color.black.opacity(0.36), radius: 24, x: 0, y: 16)
                    .shadow(color: Color.purple.opacity(0.22), radius: 18, x: 0, y: 8)
                    .overlay(alignment: .bottom) {
                        Capsule()
                            .fill(Color(red: 0.88, green: 0.66, blue: 0.34))
                            .frame(width: 280, height: 34)
                            .offset(y: 17)
                    }
                    .overlay(alignment: .top) {
                        Capsule()
                            .fill(Color.white.opacity(0.22))
                            .frame(width: 150, height: 10)
                            .offset(y: 18)
                    }
                }
                .frame(width: min(geometry.size.width * 0.48, 390))
                .overlay {
                    sparklesOverlay
                }
            }
        }
    }

    private var sparklesOverlay: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate

                for index in 0..<10 {
                    let x = size.width * (0.16 + CGFloat(index % 5) * 0.18)
                    let y = size.height * (0.14 + CGFloat(index / 5) * 0.68)
                    let phase = sin(time * 1.3 + Double(index))
                    let sparkleSize = CGFloat(5 + (index % 3) * 2) + CGFloat((phase + 1) * 1.3)
                    let rect = CGRect(x: x, y: y, width: sparkleSize, height: sparkleSize)
                    context.opacity = 0.12 + CGFloat((phase + 1) / 2) * 0.18
                    context.fill(LandingStarShape().path(in: rect), with: .color(index.isMultiple(of: 2) ? Color.white : Color(red: 1.0, green: 0.9, blue: 0.38)))
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func pauseActionButton(title: String, systemImage: String, colors: [Color], action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 19, weight: .black))
                Text(title)
                    .font(.system(size: 24, weight: .black, design: .rounded))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 62)
            .background(
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing),
                in: Capsule()
            )
            .overlay(Capsule().stroke(Color.white.opacity(0.34), lineWidth: 3))
            .shadow(color: colors.last?.opacity(0.38) ?? Color.black.opacity(0.2), radius: 12, x: 0, y: 7)
        }
        .buttonStyle(LevelButtonStyle())
    }
}

