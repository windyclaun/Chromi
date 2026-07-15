//
//  LevelNodeButton.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 15/07/26.
//

import SwiftUI

struct LevelNodeButton: View {
    let level: LevelNode
    let position: CGPoint
    let onSelect: (LevelNode) -> Void

    var body: some View {
        Button {
            if level.isUnlocked {
                onSelect(level)
            }
        } label: {
            VStack(spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(level.isUnlocked ? unlockedGradient : lockedGradient)
                        .frame(width: 92, height: 92)
                        .overlay(Circle().stroke(Color.white.opacity(0.6), lineWidth: 3))
                        .shadow(color: glowColor, radius: level.isUnlocked ? 24 : 12, x: 0, y: 0)
                        .shadow(color: Color.black.opacity(0.28), radius: 12, x: 0, y: 9)

                    if level.isUnlocked {
                        Image(systemName: level.fruitIcon)
                            .font(.system(size: 44, weight: .black))
                            .foregroundStyle(fruitColor)
                            .shadow(color: .white.opacity(0.45), radius: 8, x: 0, y: 0)
                            .frame(width: 92, height: 92)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 30, weight: .black))
                            .foregroundStyle(Color.white.opacity(0.82))
                            .frame(width: 92, height: 92)
                    }

                    Text("\(level.id)")
                        .font(.system(size: 15, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(width: 29, height: 29)
                        .background(level.isUnlocked ? Color(red: 0.38, green: 0.16, blue: 0.78) : Color.gray, in: Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.82), lineWidth: 2))
                        .offset(x: 4, y: -4)
                }

                Text(level.title)
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                    .shadow(color: Color.purple.opacity(0.75), radius: 4, x: 0, y: 2)
            }
            .frame(width: 126, height: 138)
        }
        .buttonStyle(LevelButtonStyle())
        .disabled(!level.isUnlocked)
        .position(position)
    }

    // MARK: - Helper Styling Colors
    private var unlockedGradient: LinearGradient {
        LinearGradient(colors: [Color(red: 1.0, green: 0.82, blue: 0.24), Color(red: 0.94, green: 0.42, blue: 0.16), Color(red: 0.74, green: 0.32, blue: 1.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private var lockedGradient: LinearGradient {
        LinearGradient(colors: [Color.white.opacity(0.46), Color.gray.opacity(0.72), Color(red: 0.22, green: 0.18, blue: 0.32)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private var glowColor: Color {
        level.isUnlocked ? Color(red: 1.0, green: 0.78, blue: 0.24).opacity(0.58) : Color.black.opacity(0.2)
    }

    private var fruitColor: Color {
        switch level.id {
        case 1: return Color(red: 1.0, green: 0.91, blue: 0.22)
        case 2: return Color(red: 1.0, green: 0.51, blue: 0.11)
        default: return Color(red: 0.76, green: 0.34, blue: 1.0)
        }
    }
}
