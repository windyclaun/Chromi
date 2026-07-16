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
    var onOpenWorkbench: () -> Void

    @GestureState private var workbenchDrag: CGFloat = 0

    var body: some View {
        let cardHeight = min(size.height * (isLandscape ? 0.34 : 0.38), isLandscape ? 250 : 320)
        let hiddenOffset = cardHeight - (isLandscape ? 78 : 88)
        let raisedOffset: CGFloat = isWorkbenchRaised ? 0 : hiddenOffset
        let interactiveOffset = max(0, min(hiddenOffset, raisedOffset + workbenchDrag))

        return VStack(spacing: 12) {
            Capsule()
                .fill(Color.white.opacity(0.46))
                .frame(width: 76, height: 6)
                .padding(.top, 10)

            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 42, height: 42)
                    Image(systemName: "paintbrush.pointed.fill")
                        .font(.system(size: 21, weight: .black))
                        .foregroundStyle(Color(red: 1.0, green: 0.86, blue: 0.2))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("Work Bench")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    Text("Tarik ke atas untuk mix warna")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.76))
                }

                Spacer()

                Image(systemName: isWorkbenchRaised ? "chevron.down" : "chevron.up")
                    .font(.system(size: 19, weight: .black))
                    .foregroundStyle(.white.opacity(0.92))
            }
            .padding(.horizontal, 26)

            if isWorkbenchRaised {
                VStack(spacing: 14) {
                    HStack(spacing: 12) {
                        colorPotion(name: "Blue", color: Color(red: 0.28, green: 0.52, blue: 1.0))
                        colorPotion(name: "Yellow", color: Color(red: 1.0, green: 0.84, blue: 0.12))
                        colorPotion(name: "Magic", color: Color(red: 0.74, green: 0.32, blue: 1.0))
                    }

                    Text("Area ini nanti jadi halaman mixing warna yang muncul dari bawah.")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.72))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            Spacer(minLength: 0)
        }
        .frame(width: min(size.width - 34, 760), height: cardHeight)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.55, blue: 0.08).opacity(0.96),
                    Color(red: 0.42, green: 0.12, blue: 0.72).opacity(0.98)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 28, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.28), lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.26), radius: 20, x: 0, y: -4)
        .offset(y: interactiveOffset)
        .animation(.spring(response: 0.34, dampingFraction: 0.84), value: isWorkbenchRaised)
        .gesture(
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
        )
        .onTapGesture {
            let shouldRaise = !isWorkbenchRaised
            SoundEffectPlayer.shared.play(named: "ClickStartSound", fileExtension: "wav")
            withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) {
                isWorkbenchRaised = shouldRaise
            }
            if shouldRaise {
                onOpenWorkbench()
            }
        }
    }

    private func colorPotion(name: String, color: Color) -> some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(color)
                .frame(width: 56, height: 64)
                .overlay(alignment: .top) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.white.opacity(0.28))
                        .frame(width: 42, height: 15)
                        .padding(.top, 5)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .stroke(Color.white.opacity(0.42), lineWidth: 2)
                )

            Text(name)
                .font(.system(size: 13, weight: .black, design: .rounded))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
    }
}
