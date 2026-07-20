//
//  SoundEffectPlayer.swift
//  Chromi
//
//  Created by Codex on 15/07/26.
//

import AVFoundation
import Foundation

@MainActor
final class SoundEffectPlayer {
    static let shared = SoundEffectPlayer()

    private var activePlayers: [AVAudioPlayer] = []

    private init() {}

    func play(named resourceName: String, fileExtension: String, subdirectory: String? = nil) {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: fileExtension, subdirectory: subdirectory) else {
            print("Sound effect not found: \(resourceName).\(fileExtension)")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)

            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = 0.85
            player.prepareToPlay()
            player.play()

            activePlayers.append(player)
            activePlayers.removeAll { !$0.isPlaying }
        } catch {
            print("Failed to play sound effect: \(error.localizedDescription)")
        }
    }

    func playColor(named colorName: String) {
        let normalizedColorName = colorName.replacingOccurrences(of: "min_", with: "")
        playFirstAvailable(
            named: normalizedColorName,
            fileExtension: "m4a",
            subdirectories: ["Colors", "AssetsSound/Colors", "Audio/AssetsSound/Colors", nil]
        )
    }

    private func playFirstAvailable(named resourceName: String, fileExtension: String, subdirectories: [String?]) {
        for subdirectory in subdirectories {
            if Bundle.main.url(forResource: resourceName, withExtension: fileExtension, subdirectory: subdirectory) != nil {
                play(named: resourceName, fileExtension: fileExtension, subdirectory: subdirectory)
                return
            }
        }

        print("Sound effect not found: \(resourceName).\(fileExtension)")
    }
}
