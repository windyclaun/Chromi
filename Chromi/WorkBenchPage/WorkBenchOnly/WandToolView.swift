//
//  WandToolView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 22/07/26.
//

import SwiftUI

struct WandToolView: View {
    let isUnlocked: Bool
    let onProgress: (CGFloat) -> Void
    let onCast: () -> Void

    @State private var dragOffset: CGSize = .zero
    @State private var isCasting = false

    var body: some View {
        VStack(spacing: 8) {
            Text(isUnlocked ? "Magic Wand" : "Locked")
                .font(.system(size: 13, weight: .black, design: .rounded))
                .foregroundStyle(.white.opacity(isUnlocked ? 0.96 : 0.72))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.2), in: Capsule())

            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(isUnlocked ? 0.18 : 0.09))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(isUnlocked ? 0.42 : 0.18), lineWidth: 2)
                    )

                wandImage

                if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 32, weight: .black))
                        .foregroundStyle(.white)
                        .padding(18)
                        .background(Color.black.opacity(0.36), in: Circle())
                }
            }
        }
    }

    private var wandGesture: some Gesture {
        DragGesture(minimumDistance: 6)
            .onChanged { value in
                let limitedX = min(max(value.translation.width, -360), 42)
                let limitedY = min(max(value.translation.height, -520), 28)
                let upwardProgress = abs(min(limitedY, 0)) / 430
                let leftProgress = abs(min(limitedX, 0)) / 300
                let progress = min(max((upwardProgress * 0.74) + (leftProgress * 0.26), 0), 1)
                dragOffset = CGSize(width: limitedX, height: limitedY)
                isCasting = progress > 0.22
                onProgress(progress)
            }
            .onEnded { value in
                let didCast = value.translation.height < -380 || (value.translation.height < -280 && value.translation.width < -180)
                withAnimation(.spring(response: 0.34, dampingFraction: 0.72)) {
                    dragOffset = .zero
                    isCasting = false
                }

                if didCast {
                    SoundEffectPlayer.shared.play(named: "mixkit-fairy-magic-sparkle-871", fileExtension: "wav")
                    onProgress(1)
                    onCast()
                } else {
                    onProgress(0)
                }
            }
    }

    @ViewBuilder
    private var wandImage: some View {
        let image = loadBundledImage("tongkat.png")
            .resizable()
            .scaledToFit()
            .frame(width: 130, height: 174)
            .rotationEffect(.degrees(isCasting ? -34 : -10))
            .offset(dragOffset)
            .opacity(isUnlocked ? 1.0 : 0.38)
            .saturation(isUnlocked ? 1.0 : 0.0)
            .shadow(color: Color.yellow.opacity(isUnlocked ? 0.55 : 0.0), radius: 16, x: 0, y: 0)

        if isUnlocked {
            image.gesture(wandGesture)
        } else {
            image
        }
    }
}
