//
//  EndingActionButtons.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 16/07/26.
//

import SwiftUI

struct EndingActionButtons: View {
    let isLandscape: Bool
    var onRestart: () -> Void
    var onNextLevel: () -> Void
    var onMenu: () -> Void

    var body: some View {
        HStack(spacing: isLandscape ? 18 : 12) {
            endingButton(title: "Restart", systemImage: "arrow.clockwise", colors: [Color(red: 1.0, green: 0.64, blue: 0.28), Color(red: 0.92, green: 0.38, blue: 0.12)], action: onRestart)
            endingButton(title: "Next Level", systemImage: "arrow.right", colors: [Color(red: 0.36, green: 0.92, blue: 0.48), Color(red: 0.15, green: 0.72, blue: 0.36)], action: onNextLevel)
            endingButton(title: "Menu", systemImage: "house.fill", colors: [Color(red: 0.42, green: 0.68, blue: 1.0), Color(red: 0.32, green: 0.48, blue: 0.9)], action: onMenu)
        }
        .frame(maxWidth: isLandscape ? 560 : 420)
    }

    private func endingButton(title: String, systemImage: String, colors: [Color], action: @escaping () -> Void) -> some View {
        Button {
            SoundEffectPlayer.shared.play(named: "ClickStartSound", fileExtension: "wav")
            action()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .black))
                Text(title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
            .font(.system(size: 18, weight: .black, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 56)
            .padding(.horizontal, 10)
            .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing), in: Capsule())
            .overlay(Capsule().stroke(Color.white.opacity(0.35), lineWidth: 3))
            .shadow(color: colors.last?.opacity(0.45) ?? Color.black.opacity(0.2), radius: 12, x: 0, y: 8)
        }
        .buttonStyle(LevelButtonStyle())
    }
}
