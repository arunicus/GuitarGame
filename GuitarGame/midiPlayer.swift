//
//  midiPlayer.swift
//  GuitarGame
//
//  Created by William Shea on 9/13/14.
//  Copyright (c) 2014 Arun Venkatesh. All rights reserved.
//
//
//  MidiPlayer.swift
//  AvFoundationFrobs
//
//  Created by William Shea on 9/7/14.
//

import Foundation
import AVFoundation


enum midiNotes:UInt8 {
    
    case C  = 0
    case CS = 1
    case D  = 2
    case DS = 3
    case E  = 4
    case F  = 5
    case FS = 6
    case G  = 7
    case GS = 8
    case A  = 9
    case AS = 10
    case B  = 11
    
}

enum midiIstrument:UInt8 {
    case Acoustic_Grand_Piano = 1
    case Bright_Acoustic_Piano = 2
    case Acoustic_Guitar_Steel = 26
}

class MidiPlayer {
    
    
    
    var sampler:AVAudioUnitSampler
    var engine:AVAudioEngine
    var soundbank:NSURL!
    var playerNode:AVAudioPlayerNode
    var mixer:AVAudioMixerNode
    
    let melodicBank:UInt8 = UInt8(kAUSampler_DefaultMelodicBankMSB)
    
    init(){
        var error: NSError?
        //let audioFile = AVAudioFile(forReading: fileURL, error: &error)
        //        let audioFile = AVAudioFile(forReading: fileURL, commonFormat: .PCMFormatFloat32, interleaved: false, error: &error)
        if let e = error {
            println(e.localizedDescription)
        }
        
        engine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        engine.attachNode(playerNode)
        mixer = engine.mainMixerNode
        // for the midi functionality
        sampler = AVAudioUnitSampler()
        engine.attachNode(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        soundbank = NSBundle.mainBundle().URLForResource("GeneralUser GS SoftSynth v1.44", withExtension: "sf2")
        
        if !engine.startAndReturnError(&error) {
            println("error couldn't start engine")
            if let e = error {
                println("error \(e.localizedDescription)")
            }
        }
        
        loadInstrument(35)
        
        
        
    }
    
    func loadInstrument(var instrument:UInt8){
        
        var error:NSError?
        if !sampler.loadSoundBankInstrumentAtURL(soundbank, program: instrument ,
            bankMSB: melodicBank, bankLSB: 0, error: &error) {
                println("could not load soundbank")
        }
        if let e = error {
            println("error \(e.localizedDescription)")
        }
        self.sampler.sendProgramChange(instrument, bankMSB: melodicBank, bankLSB: 0, onChannel: 0)
        
        
    }
    
    func playNote(var octave:UInt8, var note:UInt8) {
        var midiNote = (octave * 12) + note
        self.sampler.startNote(65, withVelocity: 64, onChannel: 0)
    }
}