//
//  InteractiveBallView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 22/07/26.
//

import SwiftUI

struct InteractiveBallView: View {
    var ball: PotionType
    @Binding var allBalls: [PotionType]
    @Binding var targets: [TargetDataType]
    let tableBounds: CGRect
    
    @State private var dragOffset: CGSize = .zero

    private let potionSize = WorkBenchPotionLayout.size

    var body: some View {
        potionContent
            .position(x: ball.position.x + potionSize / 2, y: ball.position.y + potionSize / 2)
            .offset(dragOffset)
    }

    @ViewBuilder
    private var potionContent: some View {
        let content = PotionImageView(colorName: ball.colorName)
            .frame(width: potionSize, height: potionSize)
            .opacity(ball.isUnlocked ? 1.0 : 0.34)
            .saturation(ball.isUnlocked ? 1.0 : 0.08)
            .overlay(alignment: .topTrailing) {
                if !ball.isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(.white)
                        .padding(7)
                        .background(Color.black.opacity(0.42), in: Circle())
                        .offset(x: -4, y: 4)
                }
            }
            .shadow(color: Color.black.opacity(ball.isUnlocked ? 0.24 : 0.12), radius: 8, x: 0, y: 5)

        if ball.isUnlocked {
            content.gesture(dragGesture)
        } else {
            content
        }
    }

    private var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .named("TableSpace"))
            .onChanged { gesture in
                let proposedPosition = CGPoint(
                    x: ball.position.x + gesture.translation.width,
                    y: ball.position.y + gesture.translation.height
                )
                let clampedPosition = clampedPotionPosition(proposedPosition)

                dragOffset = CGSize(
                    width: clampedPosition.x - ball.position.x,
                    height: clampedPosition.y - ball.position.y
                )
            }
            .onEnded { gesture in
                if let index = allBalls.firstIndex(where: { $0.id == ball.id }) {
                    let proposedPosition = CGPoint(
                        x: allBalls[index].position.x + gesture.translation.width,
                        y: allBalls[index].position.y + gesture.translation.height
                    )
                    let finalPosition = clampedPotionPosition(proposedPosition)

                    allBalls[index].position = finalPosition
                    dragOffset = .zero

                    if checkTargetDrop(at: finalPosition, currentBall: allBalls[index], currentIndex: index) {
                        return
                    }

                    checkBallMerge(for: allBalls[index], currentIndex: index)
                }
            }
    }

    private func clampedPotionPosition(_ position: CGPoint) -> CGPoint {
        CGPoint(
            x: min(max(position.x, tableBounds.minX), tableBounds.maxX - potionSize),
            y: min(max(position.y, tableBounds.minY), tableBounds.maxY - potionSize)
        )
    }
    
    private func checkTargetDrop(at dropPoint: CGPoint, currentBall: PotionType, currentIndex: Int) -> Bool {
        let ballCenter = CGPoint(x: dropPoint.x + potionSize / 2, y: dropPoint.y + potionSize / 2)
        
        for i in targets.indices {
            if targets[i].globalFrame.contains(ballCenter) {
                if targets[i].colorName == currentBall.colorName {
                    SoundEffectPlayer.shared.playColor(named: currentBall.colorName)
                    targets[i].isMatched = true
                    allBalls.remove(at: currentIndex)
                    return true
                }
            }
        }
        return false
    }
    
    private func checkBallMerge(for activeBall: PotionType, currentIndex: Int) {
        let mergeThreshold: CGFloat = 50.0

        for index in allBalls.indices {
            if index == currentIndex { continue }

            let targetBall = allBalls[index]
            guard targetBall.isUnlocked else { continue }

            let distance = sqrt(pow(activeBall.position.x - targetBall.position.x, 2) + pow(activeBall.position.y - targetBall.position.y, 2))
            guard distance < mergeThreshold else { continue }

            if let resultColor = mixedColor(activeBall.colorName, targetBall.colorName) {
                addMixedPotion(
                    colorName: resultColor,
                    from: currentIndex,
                    and: index
                )
                break
            }
        }
    }

    private func addMixedPotion(colorName: String, from firstIndex: Int, and secondIndex: Int) {
        if let lockedIndex = allBalls.firstIndex(where: { $0.colorName == colorName && !$0.isUnlocked }) {
            SoundEffectPlayer.shared.playColor(named: colorName)
            allBalls[lockedIndex].isUnlocked = true
            allBalls[firstIndex].position = allBalls[firstIndex].homePosition
            allBalls[secondIndex].position = allBalls[secondIndex].homePosition
            return
        }

        if allBalls.contains(where: { $0.colorName == colorName && $0.isUnlocked }) {
            allBalls[firstIndex].position = allBalls[firstIndex].homePosition
            allBalls[secondIndex].position = allBalls[secondIndex].homePosition
            return
        }

        let firstHome = allBalls[firstIndex].homePosition
        let secondHome = allBalls[secondIndex].homePosition
        let resultPosition = CGPoint(
            x: (firstHome.x + secondHome.x) / 2,
            y: (firstHome.y + secondHome.y) / 2
        )

        SoundEffectPlayer.shared.playColor(named: colorName)
        allBalls[firstIndex].position = firstHome
        allBalls[secondIndex].position = secondHome
        allBalls.append(PotionType(colorName: colorName, isUnlocked: true, position: resultPosition, homePosition: resultPosition))
    }

    private func mixedColor(_ colorA: String, _ colorB: String) -> String? {
        let pair = Set([colorA, colorB])

        switch pair {
        case Set(["red", "blue"]):
            return "purple"
        case Set(["red", "yellow"]):
            return "orange"
        case Set(["blue", "yellow"]):
            return "green"
        case Set(["purple", "min_red"]):
            return "blue"
        case Set(["purple", "min_blue"]):
            return "red"
        case Set(["orange", "min_red"]):
            return "yellow"
        case Set(["orange", "min_yellow"]):
            return "red"
        case Set(["green", "min_blue"]):
            return "yellow"
        case Set(["green", "min_yellow"]):
            return "blue"
        default:
            if shouldBecomeBrown(colorA, colorB) {
                return "brown"
            }
            return nil
        }
    }

    private func shouldBecomeBrown(_ colorA: String, _ colorB: String) -> Bool {
        let normalColors = Set(PotionAssetCatalog.primaryColorNames + PotionAssetCatalog.secondaryColorNames.filter { $0 != "brown" })
        return normalColors.contains(colorA) && normalColors.contains(colorB)
    }
}
