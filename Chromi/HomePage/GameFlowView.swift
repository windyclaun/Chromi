//
//  GameFlowVie.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 16/07/26.
//

import SwiftUI

struct GameFlowView: View {
    enum Stage: Equatable {
        case intro
        case level
        case coloring
    }

    @AppStorage("chromi.highestUnlockedLevelID") private var highestUnlockedLevelID: Int = 1
    @State private var stage: Stage = .intro
    @State private var selectedLevel: LevelNode?
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            ColoringPage(
                modelName: modelName(for: selectedLevel),
                onBack: {
                    withAnimation(.easeInOut(duration: 0.42)) {
                        stage = .level
                    }
                },
                onMenu: {
                    onDismiss()
                },
                onNextLevel: {
                    advanceToNextLevel()
                },
                onLevelCompleted: {
                    markCurrentLevelCompleted()
                },
            )
            .opacity(stage == .coloring ? 1 : 0)
            .allowsHitTesting(stage == .coloring)

            LevelPage(
                onBack: onDismiss,
                onSelectLevel: { level in
                    selectedLevel = level
                    withAnimation(.easeInOut(duration: 0.42)) {
                        stage = .coloring
                    }
                },
                unlockedLevelID: highestUnlockedLevelID
            )
            .opacity(stage == .level ? 1 : 0)
            .allowsHitTesting(stage == .level)

            LandingPage {
                withAnimation(.easeInOut(duration: 0.42)) {
                    stage = .level
                }
            }
            .opacity(stage == .intro ? 1 : 0)
            .allowsHitTesting(stage == .intro)
        }
        .background(Color.black.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.42), value: stage)
        .onAppear {
            playMusic(for: stage)
        }
        .onChange(of: stage) { _, newStage in
            playMusic(for: newStage)
        }
    }

    private func playMusic(for stage: Stage) {
        switch stage {
        case .intro:
            BackgroundMusicPlayer.shared.playLoop(named: "HomePageSound")
        case .level, .coloring:
            BackgroundMusicPlayer.shared.playLoop(named: "LevelPageSound")
        }
    }

    private func modelName(for level: LevelNode?) -> String {
        switch level?.id {
        case 1:
            return "Orange"
        case 2:
            return "Pear"
        case 3:
            return "Apple"
        case 4:
            return "Avocado"
        case 5:
            return "Eggplkant"
        case 6:
            return "Orange1"
        case 7:
            return "Lemon1"
        default:
            return "Orange"
        }
    }

    private func advanceToNextLevel() {
        guard let currentLevel = selectedLevel else { return }
        let nextLevel = LevelNode.previewLevels(unlockedLevelID: highestUnlockedLevelID).first { $0.id == currentLevel.id + 1 }

        if let nextLevel {
            selectedLevel = nextLevel
            withAnimation(.easeInOut(duration: 0.42)) {
                stage = .coloring
            }
        } else {
            withAnimation(.easeInOut(duration: 0.42)) {
                stage = .level
            }
        }
    }

    private func markCurrentLevelCompleted() {
        guard let currentLevel = selectedLevel else { return }
        let nextUnlockedLevel = min(currentLevel.id + 1, LevelNode.maxLevelID)
        highestUnlockedLevelID = max(highestUnlockedLevelID, nextUnlockedLevel)
    }
}
