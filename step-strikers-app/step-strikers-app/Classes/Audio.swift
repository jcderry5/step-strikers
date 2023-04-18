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
let nonCombatBattleMusicFile: String = "Woodland Fantasy"
let partyMenuMusicFile: String = "Haply"
let battleMusicFile: String = "Brirfing_theme"
let registrationMusicFile: String = "Tavern"
let victoryBackgroundMusic: String = "Victory"
let defeatBackgroundMusic: String = "defeat"
// Sound Effect Files
let fistWeaponEffect: String = "FistWeapon"
let metalWeaponEffect: String = "MetalWeapon"
let menuSelectEffect: String = "MenuSelect"
let turnStartedEffect: String = "TurnStarted"
let castSpellEffect:String = "CastSpell"
let natOneEffect: String = "Nat1"
let natTwentyEffect: String = "Nat20"
let sipEffect: String = "sip"
let slashingEffect: String = "slashing"
var volumeLevel: Float = 1.0

func playBackgroundAudio(fileName: String){
    let fileURL = Bundle.main.url(forResource: fileName, withExtension: "mp3")
    
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
            backgroundMusic.setVolume(volumeLevel, fadeDuration: 1)
            backgroundMusic.numberOfLoops = 10
        }
    } catch {
        print("Audio name I tried to play: \(fileName)")
        print("ERROR: Audio didn't play sad.")
    }
}

func playSoundEffect(fileName: String){
    let fileURL = Bundle.main.url(forResource: fileName, withExtension: "mp3")
    
    do {
        soundEffect = try AVAudioPlayer(contentsOf: fileURL!)
        soundEffect.play()
        soundEffect.setVolume(volumeLevel, fadeDuration: 1)
    } catch {
        print("Audio name I tried to play: \(fileName)")
        print("ERROR: Sound effect didn't play sad.")
    }
}

func changeVolume(newVolumeLevel: Float) {
    backgroundMusic.setVolume(newVolumeLevel, fadeDuration: 1)
    soundEffect.setVolume(newVolumeLevel, fadeDuration: 1)
    volumeLevel = newVolumeLevel
}
