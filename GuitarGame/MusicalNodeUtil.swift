//
//  MusicalNodeUtil.swift
//  GuitarGame
//
//  Created by arun venkatesh on 9/4/14.
//  Copyright (c) 2014 Arun Venkatesh. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation


class MusicalNodeUtil {
    
    func createMusicalNode(nodeName: String) -> SKSpriteNode{
        
        let musicalNode = SKSpriteNode(imageNamed: "quarter_note")
        musicalNode.name = nodeName
        musicalNode.size = CGSizeMake(30, 40)
        
        // Give the node sprite a physics body
        musicalNode.physicsBody = SKPhysicsBody(circleOfRadius: musicalNode.size.width / 2)
        musicalNode.physicsBody.dynamic = true
        musicalNode.physicsBody.affectedByGravity = false;
        musicalNode.physicsBody.usesPreciseCollisionDetection = true
        
        return musicalNode
    }
    
    func createSoundForNode(stringCombination: String) -> AVAudioPlayer{
        var fileName = "A"
        
        if(stringCombination == "touch01"){
            fileName = "A"
        }else if(stringCombination == "touch02"){
            fileName = "B"
        }else if(stringCombination == "touch03"){
            fileName = "D"
        }else if(stringCombination == "touch04"){
            fileName = "E"
        }else if(stringCombination == "touch05"){
            fileName = "G"
        }

        
        var error: NSError?
        let backgroundMusicURL = NSBundle.mainBundle().URLForResource(fileName, withExtension: "mp3")
        var backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error: &error)
        backgroundMusicPlayer.numberOfLoops = 0
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        
        return backgroundMusicPlayer
    }
    
}