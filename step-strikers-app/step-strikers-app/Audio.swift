//
//  Audio.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 3/30/23.
//

import Foundation
import AVFoundation

var backgroundMusic: AVAudioPlayer!
var soundEffect: AVAudioPlayer!

// Background Audio Files
let nonCombatBattleMusicFile: String = "Woodland Fantasy.mp3"
let partyMenuMusicFile: String = "Haply.mp3"
let battleMusicFile: String = "Brirfing_theme.mp3"
// Sound Effect Files
let menuSelectEffect: String = "MenuSelect.mp3"
let turnStartedEffect: String = "TurnStarted.mp3"
let castSpellEffect:String = "CastSpell.mp3"
let natOneEffect: String = "Nat1.mp3"
let natTwentyEffect: String = "Nat20.mp3"

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
        DispatchQueue.global().async {
            backgroundMusic.play()
        }
    } catch {
        print("Audio name I tried to play: \(fileName)")
        print("ERROR: Audio didn't play sad.")
    }
}

func playSoundEffect(fileName: String){
    let fileURL = Bundle.main.url(forResource: fileName, withExtension: nil, subdirectory: "/Audio Files")
    
    do {
        soundEffect = try AVAudioPlayer(contentsOf: fileURL!)
        soundEffect.play()
    } catch {
        print("Audio name I tried to play: \(fileName)")
        print("ERROR: Sound effect didn't play sad.")
    }
}
