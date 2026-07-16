//
//  BackgroundMusicPlayer.swift
//  Chromi
//
//  Created by Codex on 15/07/26.
//

import AVFoundation
import Foundation

@MainActor
final class BackgroundMusicPlayer {
    static let shared = BackgroundMusicPlayer()

    private var audioPlayer: AVAudioPlayer?
    private var currentResourceName: String?

    private init() {}

    func playLoop(named resourceName: String, fileExtension: String = "mp3", volume: Float = 0.45) {
        if currentResourceName == resourceName, audioPlayer?.isPlaying == true {
            return
        }

        guard let url = Bundle.main.url(forResource: resourceName, withExtension: fileExtension) else {
            print("Audio file not found: \(resourceName).\(fileExtension)")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)

            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.volume = volume
            player.prepareToPlay()
            player.play()

            audioPlayer = player
            currentResourceName = resourceName
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        currentResourceName = nil
    }
}
