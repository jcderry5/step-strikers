//
//  Audio.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 3/30/23.
//

import Foundation
import AVFoundation

var backgroundMusic: AVAudioPlayer!

func playBackgroundAudio(fileName: String){
    let fileURL = Bundle.main.url(forResource: fileName, withExtension: nil, subdirectory: "/Audio Files")
    
    guard backgroundMusic == nil || backgroundMusic.url != fileURL else {
        // Inside here = already playing this music
        return
    }
    
    if backgroundMusic != nil {
        // Inside here = playing some other type of music
        backgroundMusic.stop()
        print("Justed stopped the current music from playing")
    }
    
    do {
        backgroundMusic = try AVAudioPlayer(contentsOf: fileURL!)
        backgroundMusic.play()
    } catch {
        print("Audio name I tried to play: \(fileName)")
        print("ERROR: Audio didn't play sad.")
    }
}
