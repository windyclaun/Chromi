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

    private static var didResetProgressForDebugSession = false

    @AppStorage("chromi.highestUnlockedLevelID") private var highestUnlockedLevelID: Int = 1
    @AppStorage("chromi.hasSeenIntro") private var hasSeenIntro: Bool = false
    @State private var stage: Stage
    @State private var selectedLevel: LevelNode?
    let onDismiss: () -> Void

    init(onDismiss: @escaping () -> Void) {
        #if DEBUG
        if !Self.didResetProgressForDebugSession {
            UserDefaults.standard.set(1, forKey: "chromi.highestUnlockedLevelID")
            UserDefaults.standard.set(false, forKey: "chromi.hasSeenIntro")
            Self.didResetProgressForDebugSession = true
        }
        #endif

        let hasSeenIntro = UserDefaults.standard.bool(forKey: "chromi.hasSeenIntro")
        self._stage = State(initialValue: hasSeenIntro ? .level : .intro)
        self.onDismiss = onDismiss
    }

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

            if stage == .intro {
                LandingPage {
                    hasSeenIntro = true
                    SoundEffectPlayer.shared.stopIntro()
                    withAnimation(.easeInOut(duration: 0.42)) {
                        stage = .level
                    }
                }
                .transition(.opacity)
            }
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
            SoundEffectPlayer.shared.stopIntro()
            BackgroundMusicPlayer.shared.playLoop(named: "LevelPageSound")
        }
    }

    private func modelName(for level: LevelNode?) -> String {
        switch level?.id {
        case 1:
            return "Apple"
        case 2:
            return "Watermelon"
        case 3:
            return "Orange"
        case 4:
            return "Eggplant"
        case 5:
            return "Lemon1"
        case 6:
            return "Coconut"
        case 7:
            return "Avocado"
        case 8, 9, 10:
            return "Apple"
        default:
            return "Apple"
        }
    }

    private func advanceToNextLevel() {
        guard let currentLevel = selectedLevel else { return }
        let effectiveUnlockedLevelID = max(highestUnlockedLevelID, min(currentLevel.id + 1, LevelNode.maxLevelID))
        let nextLevel = LevelNode.previewLevels(unlockedLevelID: effectiveUnlockedLevelID).first { $0.id == currentLevel.id + 1 }

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
