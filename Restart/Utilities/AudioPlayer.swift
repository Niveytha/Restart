//
//  AudioPlayer.swift
//  Restart
//
//  Created by Niveytha Waran on 5/12/21.
//

import Foundation
import AVFoundation // full-featured framework for working with time-based audiovisual media

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {   // sound - file name, type - file extension
    if let path = Bundle.main.path(forResource: sound, ofType: type) {  // path property returns full pathname for the resource
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Could not play the sound file.")
        }
    }
}
