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

enum midiNoteForGuitarString:UInt8 {
    case E = 40
    case A = 45
    case D = 50
    case G = 55
    case B = 59
    case E2 = 64
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
        
        loadInstrument(26)
        
        
        
    }
    
    func stringToValue(input:String) -> midiNotes {
        switch input {
        case "C":
            return midiNotes.C
        case "CS":
            return midiNotes.CS
        case "D":
            return midiNotes.D
        case "DS":
            return midiNotes.DS
        case "E":
            return midiNotes.E
        case "F":
            return midiNotes.F
        case "FS":
            return midiNotes.FS
        case "G":
            return midiNotes.G
        case "GS":
            return midiNotes.GS
        case "A":
            return midiNotes.A
        case "AS":
            return midiNotes.AS
        case "B":
            return midiNotes.B
        default:
            return midiNotes.C
        }
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
    
    func playNoteOnString( var stringNumber:UInt8, var fretNumber:UInt8){
        // So we need to calculate the fret number
        var base:UInt8 = 0
        switch stringNumber {
        case 1:
            base = 40
        case 2:
            base = 45
        case 3:
            base = 50
        case 4:
            base = 55
        case 5:
            base = 59
        case 6:
            base = 64
            
        default:
            println("we dont support more than 6 strings")
        }
        
        var midiNote:UInt8 = base + fretNumber
        
        self.sampler.startNote(midiNote , withVelocity: 64, onChannel: 0)
        
    }
    
    func playNote(var octave:UInt8, var note:UInt8) {
        var midiNote = (octave * 12) + note
        self.sampler.startNote(midiNote, withVelocity: 60, onChannel: 0)
    }
}