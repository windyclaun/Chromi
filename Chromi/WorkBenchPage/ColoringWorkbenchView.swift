//
//  ColoringWorkbenchView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 16/07/26.
//

import SwiftUI

struct ColoringWorkbenchView: View {
    let size: CGSize
    let isLandscape: Bool
    @Binding var isWorkbenchRaised: Bool
    var reaction: WorkbenchReaction = .smile
    var onOpenWorkbench: () -> Void

    @GestureState private var workbenchDrag: CGFloat = 0
    @State private var reactionBounce = false
    @State internal var shinePhase = false // Internal agar bisa dibaca extension

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
