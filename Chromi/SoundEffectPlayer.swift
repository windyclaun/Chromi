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

    func play(named resourceName: String, fileExtension: String) {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: fileExtension) else {
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
}
