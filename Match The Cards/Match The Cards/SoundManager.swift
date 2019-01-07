//
//  SoundManager.swift
//  Match The Cards
//
//  Created by Shreyash Annapureddy on 1/6/19.
//  Copyright © 2019 Shreyash Annapureddy. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect:SoundEffect) {
        var soundFileName = ""
        
        switch effect {
        case .flip:
            soundFileName = "cardflip"
        case .shuffle:
            soundFileName = "shuffle"
        case .match:
            soundFileName = "dingcorrect"
        case .nomatch:
            soundFileName = "dingwrong"
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't find sound file \(soundFileName) in the bundle")
            return
        }
        
        // Createa a URL object from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
            // Create audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            // Play the soundeffect
            audioPlayer?.play()
        } catch {
            /// Couldn't create audio player object
            print("Couldn't create the audio player object for sound file \(soundFileName)")
        }
    }
}
