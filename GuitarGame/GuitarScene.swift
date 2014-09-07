//
//  GuitarScene.swift
//  GuitarGame
//
//  Created by Arun Venkatesh on 8/24/14.
//  Copyright (c) 2014 Arun Venkatesh. All rights reserved.
//

import SpriteKit
import AVFoundation




class GuitarScene: SKScene {
    var player : SKSpriteNode
    var anchor : SKSpriteNode
    var playArea : SKSpriteNode
    var top:CGFloat = 0
    var bottom:CGFloat = 0
    var distanceBetweenStrings:CGFloat = 45
    var distanceBetweenNodes:CGFloat = 60
    var musicArray: NSMutableArray = NSMutableArray()
    var notesToBeplayedArray: NSMutableArray = NSMutableArray()
    var lastUpdateTimeInterval: CFTimeInterval = 0
    var gameSpeed:Int = 1
    var currentNodesPlayed:Int = 0
    var increaseLevelNodesPlayed:Int = 10
    var deltaValue:CFTimeInterval = 4.0
    var failCount:Int = 0
    var musicStaffUtil = MusicalNodeUtil()
    var missedCountLabel = SKLabelNode();
    var gameLevelLabel = SKLabelNode();
    var nodesPlayedLabel = SKLabelNode();
    var playing:Bool = true
    var restartbutton   = UIButton.buttonWithType(UIButtonType.System) as UIButton
    var fretColor = UIColor(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1)
    var silver = UIColor(red: 239.0/255.0, green: 215.0/255.0, blue: 239.0/255.0, alpha: 1)
    var gold = UIColor(red: 245.0/255.0, green: 215.0/255.0, blue: 0/255.0, alpha: 1)


    
    required init(coder aDecoder: NSCoder)  {
        player = SKSpriteNode()
        anchor = SKSpriteNode()
        playArea = SKSpriteNode()
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        player = SKSpriteNode()
        anchor = SKSpriteNode()
        playArea = SKSpriteNode()
        
        super.init(size: size)
    }
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        startGame()
    }
    
    func startGame(){
        self.removeAllChildren()
        resetGameState()
        // Physics border around screen
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.backgroundColor = UIColor.whiteColor()
        top = self.frame.size.height - 200
        bottom = self.frame.size.height/2-200
        println(top)
        createGuiteBackGround()
        createNodes()
        createStrings(6)
        createTouchArea()
        createMusicalChord()
        playSound("aa")
        createGameStatus()
        //updateClock()

    }
    
    func resetGameState(){
        
        top = 0
        bottom = 0
        distanceBetweenStrings = 45
        distanceBetweenNodes = 60
        musicArray = NSMutableArray()
        notesToBeplayedArray = NSMutableArray()
        lastUpdateTimeInterval = 0
        gameSpeed = 1
        currentNodesPlayed = 0
        increaseLevelNodesPlayed = 10
        deltaValue = 4.0
        failCount = 0
        musicStaffUtil = MusicalNodeUtil()
        missedCountLabel = SKLabelNode();
        gameLevelLabel = SKLabelNode();
        nodesPlayedLabel = SKLabelNode();
        playing = true

    }
    
    func createGuiteBackGround(){
        var guitBgrnd = SKSpriteNode(imageNamed: "woodbackgrd.jpg")
        guitBgrnd.size = CGSizeMake((distanceBetweenStrings * 5) + CGFloat(20.0), top + 5)
        guitBgrnd.position = CGPoint(x: (self.frame.size.width/2 - 3) , y: top - guitBgrnd.size.height / 2 + 5)
        //self.addChild(guitBgrnd)
    }
    
    func createMusicalChord(){
        
        self.playArea = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: 40, height: 80))
        self.playArea.position.x = 60
        self.playArea.position.y = top  + (4 * 20)
        
        self.addChild(self.playArea)
        
        
        for i in 0...4
        {
            var topNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: self.frame.size.width, height: 1))
            topNode.position = CGPoint(x: (self.frame.size.width/2) , y: top + 20 + ( CGFloat(i+1) * 20))
            self.addChild(topNode)
        }
        let treble = SKSpriteNode(imageNamed: "Treble-clef")
        treble.size = CGSizeMake(30, 80)
        
        treble.position.x = 15
        treble.position.y = top  + (4 * 20)
        
        
        self.addChild(treble)
        
    }
    
    func updateClock() {
        var actionwait = SKAction.waitForDuration(2.0)
        var actionrun = SKAction.runBlock({
            self.fireMusicalNode()
        })
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([actionwait,actionrun])))
    }
    
    func createTouchArea(){
        for j in 1...6{
            for i in 0...6
            {
                var touchNode = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 40, height: 40))
                touchNode.position = CGPoint(x: CGFloat(j) * distanceBetweenStrings , y: top - (CGFloat(i + 1) * distanceBetweenNodes/2.0) - (CGFloat(i) * (distanceBetweenNodes/2.0)))
                touchNode.name = "touch" + String(i) +  String(j)
                self.addChild(touchNode)
            }
        }
        
    }
    func createNodes(){
        
        for i in 0...6
        {
            var topNode = SKSpriteNode(color: silver, size: CGSize(width: (distanceBetweenStrings * 5) + CGFloat(20.0), height: 4))
            topNode.position = CGPoint(x: distanceBetweenStrings + (topNode.size.width/2) - 10.0 , y: top - (CGFloat(i) * distanceBetweenNodes))
            self.addChild(topNode)
        }
        
    }
    
    func createStrings(numberOfString: Int){
        for i in 1...numberOfString
        {
            var stringWidth:CGFloat = CGFloat(i) * distanceBetweenStrings
            
            // Physics border around screen
            self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
            
            // Static Body
            self.anchor = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 5, height: 5))
            self.anchor.position = CGPoint(x: stringWidth, y: top + 20)
            self.anchor.physicsBody = SKPhysicsBody(rectangleOfSize: anchor.frame.size)
            self.anchor.physicsBody!.dynamic = false
            
            self.addChild(self.anchor)
            
            // Dynamic Body
            self.player = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 5, height: 5))
            self.player.position = CGPoint(x: stringWidth, y: bottom)
            self.player.physicsBody = SKPhysicsBody(rectangleOfSize: player.frame.size)
            self.player.physicsBody!.mass = 999999
            self.player.physicsBody!.dynamic = true
            self.addChild(self.player)
            if(i  < 5){
                addRope(30, topNode: self.anchor, bottomNode: self.player , widthStr: 0.65 * CGFloat(numberOfString - i + 1) , strColor: UIColor.redColor() )
            }
            else{
                addRope(30, topNode: self.anchor, bottomNode: self.player , widthStr: 1 * CGFloat(numberOfString - i + 1) , strColor: UIColor.greenColor())
            }
            
        }
        
    }
    
    func addRope(numberOfAttaches: Int,topNode: SKSpriteNode,bottomNode: SKSpriteNode , widthStr: CGFloat , strColor: UIColor){
        var previousNode = topNode
        var joinHeight = 10.0
        
        for i in 1...numberOfAttaches
        {
            
            var ropePiece = SKSpriteNode(color: strColor, size: CGSize(width: widthStr, height: 16))
            ropePiece.name = "rope"
            var yPoint = previousNode.position.y - 10.0
            ropePiece.position = CGPoint(x: previousNode.position.x , y: yPoint)
            ropePiece.physicsBody = SKPhysicsBody(rectangleOfSize: ropePiece.size)
            self.addChild(ropePiece)
          
            
            var pin = SKPhysicsJointPin.jointWithBodyA(previousNode.physicsBody, bodyB: ropePiece.physicsBody, anchor: CGPoint(x: CGRectGetMidX(ropePiece.frame), y: CGRectGetMidY(ropePiece.frame)))
            self.physicsWorld.addJoint(pin)
            
            previousNode = ropePiece
            
        }
        
        var pin = SKPhysicsJointPin.jointWithBodyA(previousNode.physicsBody, bodyB: bottomNode.physicsBody, anchor: CGPoint(x: CGRectGetMidX(bottomNode.frame), y: CGRectGetMidY(bottomNode.frame)))
        self.physicsWorld.addJoint(pin)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        musicArray = NSMutableArray()
        for touch: AnyObject in touches {
            
            let location: CGPoint! = touch.locationInNode(self)
            let nodeAtPoint = self.nodeAtPoint(location)
            println(nodeAtPoint)
            if (nodeAtPoint.name != nil) {
                playSound(nodeAtPoint.name!)
                let nodeall = self.nodesAtPoint(nodeAtPoint.position)
                println(nodeall)
                let ropeNode = self.nodesAtPoint(nodeAtPoint.position)[0] as SKSpriteNode
                println(ropeNode)
                if( ropeNode.name == "rope" )
                {
                    ropeNode.physicsBody!.applyImpulse(CGVector(1,0))
                }
                
                if(notesToBeplayedArray.count > 0)
                {
                    var musicNode = notesToBeplayedArray.objectAtIndex(0) as SKSpriteNode
                    //println(notesToBeplayedArray.objectAtIndex(0))
                    //println(self.playArea.frame.contains(musicNode.position))
                    
                    if(self.playArea.frame.contains(musicNode.position))
                    {
                        musicNode.removeAllActions()
                        self.notesToBeplayedArray.removeObject(musicNode)
                        musicNode.removeFromParent()
                        currentNodesPlayed = currentNodesPlayed + 1
                        if(currentNodesPlayed >= increaseLevelNodesPlayed)
                        {
                            currentNodesPlayed = 0
                            gameSpeed = gameSpeed + 1
                            self.gameLevelLabel.text = "Level : " + String(gameSpeed)
                            
                            if(deltaValue > 1 )
                            {
                                deltaValue = deltaValue - 1
                            }
                            
                            if(deltaValue < 1)
                            {
                                deltaValue = 1
                            }
                        }
                        self.nodesPlayedLabel.text = "Played : " + String(currentNodesPlayed)
                    }else if(musicNode.position.x > (self.playArea.position.x + self.playArea.frame.width))
                    {
                        println("BEFOREEEE")
                    }
                }
            } else {
                println("NULL")
            }
            
        }
        
        //[body.physicsBody applyImpulse:CGVectorMake(100, 0)];
    }
    
    func playSound(stringCombination :String){
        
        musicArray.addObject(musicStaffUtil.createSoundForNode(stringCombination))

    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
//        for touch: AnyObject in touches {
//            
//            let location: CGPoint! = touch.locationInNode(self)
//            
//            let nodeAtPoint = self.nodeAtPoint(location)
//            
//            if (nodeAtPoint.name != nil) {
//                println("NODE FOUND: \(nodeAtPoint.name)")
//                playSound(nodeAtPoint.name)
//                println("NODE FOUND: \(self.nodesAtPoint(nodeAtPoint.position)[0])")
//                let ropeNode = self.nodesAtPoint(nodeAtPoint.position)[0] as SKSpriteNode
//                if( ropeNode.name == "rope" )
//                {
//                    println(notesToBeplayedArray.objectAtIndex(0))
//                    ropeNode.physicsBody.applyForce(CGVector(5,0))
//                    //ropeNode.physicsBody.applyImpulse(CGVector(2,0))
//                }
//            } else {
//                println("NULL")
//            }
//            
//        }

    }
    
    
    func fireMusicalNode()
    {
        let musicalNode = musicStaffUtil.createMusicalNode("A#")
        musicalNode.position.x = self.size.width
        musicalNode.position.y = self.size.height - 120
        
        addChild(musicalNode)
        notesToBeplayedArray.addObject(musicalNode)
        
        // Calculate the node's speed and final destination
        let musicalNodeSpeed: CGFloat = 60
        let musicalNodeMoveTime = size.width / musicalNodeSpeed
        
        // Send the missile on its way
        let actionMove = SKAction.moveTo(CGPointMake(self.playArea.position.x - musicalNode.frame.width/2, musicalNode.position.y), duration: NSTimeInterval(musicalNodeMoveTime))
        let actionMoveDone = SKAction.removeFromParent()
        var actionrun = SKAction.runBlock({
            self.notesToBeplayedArray.removeObject(musicalNode)
            self.failCount++
            self.missedCountLabel.text = "Missed : " + String(self.failCount)
            if(self.failCount >= 3){
                self.removeAllChildren()
                self.playing = false
                var guitBgrnd = SKSpriteNode(imageNamed: "gameover1.png")
                guitBgrnd.size = self.size
                guitBgrnd.position = CGPoint(x: self.frame.size.width/2 , y: guitBgrnd.size.height / 2)
                self.addChild(guitBgrnd)
                
                self.restartbutton.frame = CGRectMake(100, 300, 100, 50)
                self.restartbutton.backgroundColor = UIColor.blackColor()
                self.restartbutton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                self.restartbutton.setTitle("Restart Game", forState: UIControlState.Normal)
                self.restartbutton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                
                self.view!.addSubview(self.restartbutton)
            }
        })
        musicalNode.runAction(SKAction.sequence([actionMove, actionrun , actionMoveDone]))
    }
    
    func buttonAction(sender:UIButton!)
    {
        println("Button tapped")
        self.restartbutton.removeFromSuperview()
        startGame()
    }
    
    func createGameStatus(){
        self.missedCountLabel.text = "Missed : 0"
        self.missedCountLabel.fontSize = 15
        self.missedCountLabel.fontName = "Courier"
        self.missedCountLabel.fontColor = UIColor.blueColor()
        self.missedCountLabel.position = CGPoint(x: 50,y: self.size.height - 20)
        self.addChild(self.missedCountLabel)
        
        self.gameLevelLabel.text = "Level  : 1"
        self.gameLevelLabel.fontSize = 15
        self.gameLevelLabel.fontName = "Courier"
        self.gameLevelLabel.fontColor = UIColor.blueColor()
        self.gameLevelLabel.position = CGPoint(x: 50,y: self.size.height - 35)
        self.addChild(self.gameLevelLabel)
        
        self.nodesPlayedLabel.text = "Played : 0"
        self.nodesPlayedLabel.fontSize = 15
        self.nodesPlayedLabel.fontName = "Courier"
        self.nodesPlayedLabel.fontColor = UIColor.blueColor()
        self.nodesPlayedLabel.position = CGPoint(x: 50,y: self.size.height - 50)
        self.addChild(self.nodesPlayedLabel)

    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(playing == true)
        {
            var delta: CFTimeInterval = currentTime - lastUpdateTimeInterval
    
            if (delta > deltaValue) {
                delta = 0;
                fireMusicalNode()
                lastUpdateTimeInterval = currentTime;
            }
        }
    }
}
