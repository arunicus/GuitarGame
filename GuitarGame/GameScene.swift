//
//  GameScene.swift
//  GuitarGame
//
//  Created by Arun Venkatesh on 8/24/14.
//  Copyright (c) 2014 Arun Venkatesh. All rights reserved.
//

import SpriteKit
import AVFoundation


let string1 = SKShapeNode()
let string2 = SKShapeNode()
let string3 = SKShapeNode()
let string4 = SKShapeNode()
let string5 = SKShapeNode()
let string6 = SKShapeNode()
private var backgroundMusicPlayer: AVAudioPlayer!


class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "guitar.png")
        background.position = CGPointMake(self.size.width/2-30, self.size.height/2)
        background.size = CGSize(width: self.size.width-100, height: self.size.height)
        self.addChild(background)
        
        let lineToDraw = CGPathCreateMutable()
        CGPathMoveToPoint(lineToDraw, nil, 35, 0)
        CGPathAddLineToPoint(lineToDraw, nil, 35, self.size.height)
        string1.path = lineToDraw
        string1.strokeColor = SKColor.redColor()
        string1.lineWidth = 10
        string1.name = "String 1"
        self.addChild(string1)
        
        let lineToDraw2 = CGPathCreateMutable()
        CGPathMoveToPoint(lineToDraw2, nil, 73, 0)
        CGPathAddLineToPoint(lineToDraw2, nil, 73, self.size.height)
        string2.path = lineToDraw2
        string2.strokeColor = SKColor.redColor()
        string2.lineWidth = 10
        string2.name = "String 2"
        self.addChild(string2)
        
        let lineToDraw3 = CGPathCreateMutable()
        CGPathMoveToPoint(lineToDraw3, nil, 112, 0)
        CGPathAddLineToPoint(lineToDraw3, nil, 112, self.size.height)
        string3.path = lineToDraw3
        string3.strokeColor = SKColor.redColor()
        string3.lineWidth = 10
        string3.name = "String 3"
        self.addChild(string3)
        
        let lineToDraw4 = CGPathCreateMutable()
        CGPathMoveToPoint(lineToDraw4, nil, 149, 0)
        CGPathAddLineToPoint(lineToDraw4, nil, 149, self.size.height)
        string4.path = lineToDraw4
        string4.strokeColor = SKColor.redColor()
        string4.lineWidth = 10
        string4.name = "String 4"
        self.addChild(string4)
        
        let lineToDraw5 = CGPathCreateMutable()
        CGPathMoveToPoint(lineToDraw5, nil, 188, 0)
        CGPathAddLineToPoint(lineToDraw5, nil, 188, self.size.height)
        string5.path = lineToDraw5
        string5.strokeColor = SKColor.redColor()
        string5.lineWidth = 10
        string5.name = "String 5"
        self.addChild(string5)
        
        let lineToDraw6 = CGPathCreateMutable()
        CGPathMoveToPoint(lineToDraw6, nil, 226, 0)
        CGPathAddLineToPoint(lineToDraw6, nil, 226, self.size.height)
        string6.path = lineToDraw6
        string6.strokeColor = SKColor.redColor()
        string6.lineWidth = 10
        string6.name = "String 6"
        self.addChild(string6)
    }
    
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if(backgroundMusicPlayer != nil){
            backgroundMusicPlayer.stop()
        }
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            println(location)
            var stringCombination:String = "";
            
            switch  location.x{
                case 25...45:
                    stringCombination = "s1"
                    println("String 1")
                case 63...82:
                    stringCombination = "s2"
                    println("String 2")
                case 102...123:
                    stringCombination = "s3"
                    println("String 3")
                case 140...159:
                    stringCombination = "s4"
                    println("String 4")
                case 180...198:
                    stringCombination = "s5"
                    println("String 5")
                case 216...236:
                    stringCombination = "s6"
                    println("String 6")
                default:
                    println("none")
                
            }
            if(stringCombination == ""){
                return
            }
            
            switch  location.y{
                case 35...70:
                    stringCombination =  stringCombination + "l1"
                    println("Level 1")
                case 80...125:
                    stringCombination =  stringCombination + "l2"
                    println("Level 2")
                case 135...180:
                    stringCombination =  stringCombination + "l3"
                    println("Level 3")
                case 190...235:
                    stringCombination =  stringCombination + "l4"
                    println("Level 4")
                case 245...290:
                    stringCombination =  stringCombination + "l5"
                    println("Level 5")
                case 300...348:
                    stringCombination =  stringCombination + "l6"
                    println("Level 6")
                case 355...410:
                    stringCombination =  stringCombination + "l7"
                    println("Level 7")
                case 420...480:
                    stringCombination =  stringCombination + "l8"
                    println("Level 8")
                case 487...555:
                    stringCombination =  stringCombination + "l9"
                    println("Level 9")
                default:
                    println("none")
                    return
            }
            println(stringCombination)
            var fileName = "A"
            
            if(stringCombination == "s4l8"){
                fileName = "A"
            }else if(stringCombination == "s2l8"){
                fileName = "B"
            }else if(stringCombination == "s5l7"){
                fileName = "D"
            }else if(stringCombination == "s3l8"){
                fileName = "E"
            }else if(stringCombination == "s1l7"){
                fileName = "G"
            }
            
            var error: NSError?
            let backgroundMusicURL = NSBundle.mainBundle().URLForResource(fileName, withExtension: "mp3")
            backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error: &error)
            backgroundMusicPlayer.numberOfLoops = 0
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        }
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
