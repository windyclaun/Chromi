//
//  ColoringWorkbenchView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 16/07/26.
//

import SwiftUI

enum WorkbenchReaction {
    case smile
    case happy
    case sad

    var assetName: String {
        switch self {
        case .smile:
            return "reactionsmile"
        case .happy:
            return "reactionhappy"
        case .sad:
            return "reactionsad"
        }
    }
}

struct ColoringWorkbenchView: View {
    let size: CGSize
    let isLandscape: Bool
    @Binding var isWorkbenchRaised: Bool
    var reaction: WorkbenchReaction = .smile
    var onOpenWorkbench: () -> Void

    @GestureState private var workbenchDrag: CGFloat = 0
    @State private var reactionBounce = false
    @State private var shinePhase = false

    var body: some View {
        let cardHeight = min(size.height * (isLandscape ? 0.58 : 0.54), isLandscape ? 460 : 560)
        let visibleHeight = isLandscape ? 128.0 : 142.0
        let hiddenOffset = cardHeight - visibleHeight
        let raisedOffset: CGFloat = isWorkbenchRaised ? 0 : hiddenOffset
        let interactiveOffset = max(0, min(hiddenOffset, raisedOffset + workbenchDrag))

        return workbenchCard(height: cardHeight)
        .frame(width: size.width + 4, height: cardHeight)
        .offset(y: interactiveOffset)
        .animation(.spring(response: 0.36, dampingFraction: 0.82), value: isWorkbenchRaised)
        .onAppear {
            reactionBounce = true
            shinePhase = true
        }
        .gesture(workbenchGesture(hiddenOffset: hiddenOffset))
        .onTapGesture {
            toggleWorkbench()
        }
    }

    private func workbenchCard(height: CGFloat) -> some View {
        VStack(spacing: 0) {
            topTableLip

            VStack(spacing: isLandscape ? 18 : 22) {
                HStack(alignment: .top, spacing: isLandscape ? 34 : 22) {
                    colorShelf
                        .frame(maxWidth: isLandscape ? 360 : 190, alignment: .leading)

                    potionMixingArea
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                Spacer(minLength: 0)

                Capsule()
                    .fill(Color.white.opacity(0.26))
                    .frame(width: 94, height: 6)
                    .padding(.bottom, 12)
            }
            .padding(.top, isLandscape ? 28 : 34)
            .padding(.horizontal, isLandscape ? 76 : 30)
        }
        .frame(height: height)
        .background(tableGradient, in: UnevenRoundedRectangle(cornerRadii: .init(topLeading: 38, bottomLeading: 0, bottomTrailing: 0, topTrailing: 38), style: .continuous))
        .overlay(
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 38, bottomLeading: 0, bottomTrailing: 0, topTrailing: 38), style: .continuous)
                .stroke(borderGradient, lineWidth: 3)
        )
        .overlay(alignment: .top) {
            tableHighlight
        }
        .shadow(color: Color.black.opacity(0.32), radius: 24, x: 0, y: -8)
        .shadow(color: Color(red: 0.85, green: 0.43, blue: 0.05).opacity(0.24), radius: 20, x: 0, y: -3)
    }

    private var topTableLip: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.98, green: 0.64, blue: 0.16),
                            Color(red: 0.67, green: 0.31, blue: 0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 64)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.white.opacity(0.28), lineWidth: 2)
                )

            HStack(spacing: 10) {
                Spacer()

                Image(systemName: isWorkbenchRaised ? "chevron.down" : "chevron.up")
                    .font(.system(size: 19, weight: .black))

                loadBundledImage(reaction.assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: isLandscape ? 88 : 76, height: isLandscape ? 58 : 50)
                    .rotationEffect(.degrees(reactionBounce ? 2 : -2))
                    .scaleEffect(reactionBounce ? 1.03 : 0.97)
                    .animation(.easeInOut(duration: 1.25).repeatForever(autoreverses: true), value: reactionBounce)

                Spacer()
            }
            .foregroundStyle(Color.white)
            .shadow(color: Color(red: 0.28, green: 0.08, blue: 0.02).opacity(0.35), radius: 4, x: 0, y: 2)
        }
        .padding(.top, 16)
        .padding(.horizontal, isLandscape ? 36 : 18)
    }

    private var colorShelf: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Color Shelf")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundStyle(Color(red: 1.0, green: 0.9, blue: 0.28))
                .shadow(color: Color.black.opacity(0.22), radius: 2, x: 0, y: 1)

            let orbSize = isLandscape ? 58.0 : 42.0
            let orbSpacing = isLandscape ? 16.0 : 10.0

            LazyVGrid(columns: Array(repeating: GridItem(.fixed(orbSize), spacing: orbSpacing), count: 3), spacing: orbSpacing) {
                colorOrb(Color(red: 0.32, green: 0.54, blue: 1.0))
                colorOrb(Color(red: 1.0, green: 0.84, blue: 0.12))
                colorOrb(Color(red: 0.96, green: 0.24, blue: 0.34))
                colorOrb(Color(red: 0.25, green: 0.86, blue: 0.36))
                colorOrb(Color(red: 0.78, green: 0.32, blue: 1.0))
                colorOrb(Color(red: 1.0, green: 0.52, blue: 0.12))
                colorOrb(Color(red: 0.2, green: 0.86, blue: 0.9))
                colorOrb(Color(red: 1.0, green: 0.48, blue: 0.76))
                colorOrb(Color.white.opacity(0.9))
            }
            .padding(isLandscape ? 18 : 12)
            .background(Color(red: 0.52, green: 0.25, blue: 0.06).opacity(0.44), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color(red: 1.0, green: 0.76, blue: 0.22).opacity(0.35), lineWidth: 2)
            )
        }
    }

    private var potionMixingArea: some View {
        VStack(alignment: .trailing, spacing: 18) {
            Text("Magic Mix")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundStyle(Color(red: 1.0, green: 0.9, blue: 0.28))
                .shadow(color: Color.black.opacity(0.22), radius: 2, x: 0, y: 1)

            HStack(alignment: .bottom, spacing: isLandscape ? 26 : 18) {
                beaker(fill: Color(red: 1.0, green: 0.2, blue: 0.34), height: isLandscape ? 148 : 116)
                beaker(fill: Color(red: 0.25, green: 0.84, blue: 0.38), height: isLandscape ? 128 : 102)
            }
            .padding(isLandscape ? 22 : 12)
            .background(Color(red: 0.34, green: 0.12, blue: 0.38).opacity(0.22), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.16), lineWidth: 2)
            )
        }
    }

    private func colorOrb(_ color: Color) -> some View {
        let orbSize = isLandscape ? 58.0 : 42.0

        return Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color.white.opacity(0.92),
                        color,
                        color.opacity(0.64)
                    ],
                    center: .topLeading,
                    startRadius: 4,
                    endRadius: 38
                )
            )
            .frame(width: orbSize, height: orbSize)
            .overlay(Circle().stroke(Color.white.opacity(0.36), lineWidth: 2))
            .shadow(color: color.opacity(0.34), radius: 10, x: 0, y: 4)
    }

    private func beaker(fill: Color, height: CGFloat) -> some View {
        let beakerWidth = isLandscape ? 104.0 : 78.0

        return ZStack(alignment: .bottom) {
            BeakerShape()
                .fill(Color.white.opacity(0.12))
                .frame(width: beakerWidth, height: height)
                .overlay(BeakerShape().stroke(Color.white.opacity(0.72), lineWidth: 4))

            BeakerShape()
                .fill(
                    LinearGradient(
                        colors: [fill.opacity(0.78), fill.opacity(0.42)],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .frame(width: beakerWidth, height: height * 0.45)
                .mask(
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .frame(height: height * 0.42)
                    }
                )
                .padding(.bottom, 7)

            Circle()
                .fill(Color.white.opacity(shinePhase ? 0.42 : 0.18))
                .frame(width: 16, height: 16)
                .offset(x: -20, y: -height * 0.45)
                .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: shinePhase)
        }
    }

    private var tableHighlight: some View {
        LinearGradient(
            colors: [
                Color.white.opacity(0.18),
                Color.white.opacity(0.03),
                Color.clear
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 130)
        .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 34, bottomLeading: 0, bottomTrailing: 0, topTrailing: 34), style: .continuous))
    }

    private var tableGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.83, green: 0.45, blue: 0.06),
                Color(red: 0.58, green: 0.27, blue: 0.03),
                Color(red: 0.31, green: 0.12, blue: 0.36)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var borderGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.75, blue: 0.18),
                Color(red: 0.58, green: 0.24, blue: 0.94),
                Color(red: 0.12, green: 0.05, blue: 0.25)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func workbenchGesture(hiddenOffset: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 8)
            .updating($workbenchDrag) { value, state, _ in
                state = value.translation.height
            }
            .onEnded { value in
                let shouldRaise = value.translation.height < -36 || (isWorkbenchRaised && value.translation.height < 46)
                let shouldLower = value.translation.height > 36

                if shouldRaise != isWorkbenchRaised || shouldLower {
                    SoundEffectPlayer.shared.play(named: "ClickStartSound", fileExtension: "wav")
                }

                if shouldLower {
                    isWorkbenchRaised = false
                } else if shouldRaise {
                    isWorkbenchRaised = true
                    onOpenWorkbench()
                }
            }
    }

    private func toggleWorkbench() {
        let shouldRaise = !isWorkbenchRaised
        SoundEffectPlayer.shared.play(named: "ClickStartSound", fileExtension: "wav")
        withAnimation(.spring(response: 0.36, dampingFraction: 0.82)) {
            isWorkbenchRaised = shouldRaise
        }
        if shouldRaise {
            onOpenWorkbench()
        }
    }
}

private struct BeakerShape: Shape {
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
