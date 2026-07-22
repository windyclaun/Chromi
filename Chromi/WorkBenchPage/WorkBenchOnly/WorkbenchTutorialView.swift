//
//  WorkbenchTutorialView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 22/07/26.
//

import SwiftUI

struct WorkbenchTutorialView: View {
    let modelName: String
    let balls: [PotionType]
    let targets: [TargetDataType]

    @State private var animate = false

    private enum TutorialMode {
        case mix
        case target
        case hidden
    }

    private var tutorialMode: TutorialMode {
        switch modelName {
        case "Apple":
            return balls.contains(where: { $0.colorName == "green" && $0.isUnlocked }) ? .target : .mix
        case "Lemon1", "Avocado":
            return balls.contains(where: { $0.colorName == "red" && $0.isUnlocked }) ? .hidden : .mix
        default:
            return .hidden
        }
    }

    private var mixSourceColor: String {
        modelName == "Lemon1" || modelName == "Avocado" ? "min_blue" : "blue"
    }

    private var mixDestinationColor: String {
        modelName == "Lemon1" || modelName == "Avocado" ? "purple" : "yellow"
    }

    private var targetPrompt: String {
        modelName == "Avocado" ? "Now drag Red to the target." : "Now drag Red to the target."
    }

    var body: some View {
        GeometryReader { geometry in
            let sourcePosition = position(for: mixSourceColor, in: geometry.size)
            let destinationPosition = position(for: mixDestinationColor, in: geometry.size)
            let redPosition = position(for: "red", in: geometry.size)
            let targetPosition = targets.first?.globalFrame.centerPoint ?? CGPoint(x: geometry.size.width * 0.68, y: geometry.size.height * 0.58)

            if tutorialMode != .hidden {
                ZStack {
                    tutorialBubble
                        .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.16)

                    switch tutorialMode {
                    case .mix:
                        tutorialArrow(from: sourcePosition, to: destinationPosition)
                        tutorialMarker(at: sourcePosition)
                        tutorialMarker(at: destinationPosition)

                        tutorialPointer(from: sourcePosition, to: destinationPosition)

                    case .target:
                        tutorialArrow(from: redPosition, to: targetPosition)

                        tutorialPointer(from: redPosition, to: targetPosition)

                    case .hidden:
                        EmptyView()
                    }
                }
            }
        }
        .onAppear {
            animate = true
        }
        .onChange(of: tutorialModeKey) { _, _ in
            animate = false
            DispatchQueue.main.async {
                animate = true
            }
        }
    }

    private var tutorialBubble: some View {
        VStack(spacing: 3) {
            Text("Tutorial")
                .font(.system(size: 13, weight: .black, design: .rounded))
            Text(tutorialCopy)
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(Color(red: 0.25, green: 0.08, blue: 0.58))
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.purple.opacity(0.25), lineWidth: 2)
        )
        .frame(width: 280)
        .shadow(color: Color.black.opacity(0.16), radius: 10, x: 0, y: 5)
    }

    private var tutorialCopy: String {
        switch tutorialMode {
        case .mix:
            if modelName == "Lemon1" || modelName == "Avocado" {
                return "Drag Minus Blue to Purple."
            }
            return "Drag Blue to Yellow."
        case .target:
            return targetPrompt
        case .hidden:
            return ""
        }
    }

    private var tutorialModeKey: String {
        switch tutorialMode {
        case .mix: return "mix"
        case .target: return "target"
        case .hidden: return "hidden"
        }
    }

    private func position(for colorName: String, in size: CGSize) -> CGPoint {
        if let ball = balls.first(where: { $0.colorName == colorName && $0.isUnlocked }) {
            return CGPoint(
                x: ball.position.x + WorkBenchPotionLayout.size / 2,
                y: ball.position.y + WorkBenchPotionLayout.size / 2
            )
        }

        return CGPoint(x: size.width * 0.18, y: size.height * 0.62)
    }

    private func tutorialArrow(from start: CGPoint, to end: CGPoint) -> some View {
        Image(systemName: "arrow.right")
            .font(.system(size: 26, weight: .black))
            .foregroundStyle(.white)
            .rotationEffect(.radians(Double(atan2(end.y - start.y, end.x - start.x))))
            .shadow(color: Color.black.opacity(0.35), radius: 5, x: 0, y: 2)
            .position(x: (start.x + end.x) / 2, y: (start.y + end.y) / 2)
    }

    private func tutorialMarker(at position: CGPoint) -> some View {
        Circle()
            .stroke(Color.white.opacity(0.84), lineWidth: 3)
            .frame(width: 76, height: 76)
            .scaleEffect(animate ? 1.14 : 0.92)
            .opacity(animate ? 0.4 : 0.9)
            .shadow(color: Color.white.opacity(0.55), radius: 10, x: 0, y: 0)
            .position(position)
            .animation(.easeInOut(duration: 0.95).repeatForever(autoreverses: true), value: animate)
    }

    private func tutorialPointer(from start: CGPoint, to end: CGPoint) -> some View {
        Image(systemName: "hand.point.up.left.fill")
            .font(.system(size: 34, weight: .black))
            .foregroundStyle(.white)
            .shadow(color: Color.black.opacity(0.34), radius: 6, x: 0, y: 3)
            .rotationEffect(.degrees(animate ? -8 : 4))
            .position(animate ? end : start)
            .offset(x: 24, y: 22)
            .animation(.easeInOut(duration: 0.95).repeatForever(autoreverses: true), value: animate)
    }
}

private extension CGRect {
    var centerPoint: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}
