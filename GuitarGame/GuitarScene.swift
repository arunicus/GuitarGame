//
//  GuitarScene.swift
//  GuitarGame
//
//  Created by Arun Venkatesh on 8/24/14.
//  Copyright (c) 2014 Arun Venkatesh. All rights reserved.
//

// touch01 = F
//touch02 = A#


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
    var midiHelper:MidiPlayer = MidiPlayer()
    var lastUpdateTimeInterval: CFTimeInterval = 0
    var gameSpeed:Int = 1
    var currentNodesPlayed:Int = 0
    var increaseLevelNodesPlayed:Int = 10
    var deltaValue:CFTimeInterval = 4.0
    var failCount:Int = 0
    var musicStaffUtil = MusicalNodeUtil(fileName: "level1")
    var missedCountLabel = SKLabelNode();
    var gameLevelLabel = SKLabelNode();
    var nodesPlayedLabel = SKLabelNode();
    var playing:Bool = true
    var restartbutton   = UIButton.buttonWithType(UIButtonType.System) as UIButton
    var nextLevelbutton   = UIButton.buttonWithType(UIButtonType.System) as UIButton
    var fretColor = UIColor(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1)
    var silver = UIColor(red: 239.0/255.0, green: 215.0/255.0, blue: 239.0/255.0, alpha: 1)
    var gold = UIColor(red: 245.0/255.0, green: 215.0/255.0, blue: 0/255.0, alpha: 1)
    var nodeDictionary = [  "01":"F","02":"A#","03":"D#","04":"G#","05":"C","06":"F",
                            "11":"F#","12":"B","13":"E","14":"A","15":"C#","16":"F#",
                            "21":"G","22":"C","23":"F","24":"A#","25":"D","26":"G",
                            "31":"G#","32":"C#","33":"F#","34":"B","35":"D#","36":"G#",
                            "41":"A","42":"D","43":"G","44":"C","45":"E","46":"A",
                            "51":"A#","52":"D#","53":"G#","54":"C#","55":"F","56":"A#"]

    
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
        //addEmitterParticles()
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
        musicStaffUtil = MusicalNodeUtil(fileName: "level1")
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
        
        self.playArea = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: 40, height: 120))
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
    

    func createTouchArea(){
        for j in 1...6{
            for i in 0...6
            {
                var touchNode = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 40, height: 40))
                touchNode.position = CGPoint(x: CGFloat(j) * distanceBetweenStrings , y: top - (CGFloat(i + 1) * distanceBetweenNodes/2.0) - (CGFloat(i) * (distanceBetweenNodes/2.0)))
                touchNode.name = nodeDictionary[String(i) +  String(j)]
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
            let nodeAtPoint = self.nodeAtPoint(location) as SKSpriteNode
            if (nodeAtPoint.name != nil) {
                
                let nodeall = self.nodesAtPoint(nodeAtPoint.position)
                let ropeNode = self.nodesAtPoint(nodeAtPoint.position)[0] as SKSpriteNode
                if( ropeNode.name == "rope" )
                {
                    ropeNode.physicsBody!.applyImpulse(CGVector(1,0))
                }
                
                if(notesToBeplayedArray.count > 0)
                {
                    var musicNode = notesToBeplayedArray.objectAtIndex(0) as SKSpriteNode
                    println(nodeAtPoint.name!)
                    println(musicNode.name!)

                    if(nodeAtPoint.name! == musicNode.name!)
                    {
                        playSound(musicNode.name!)
                        nodeAtPoint.color = UIColor.clearColor();
                    }

                    //println(notesToBeplayedArray.objectAtIndex(0))
                    //println(self.playArea.frame.contains(musicNode.position))
                    
                    if(musicNode.position.x >= 40 && musicNode.position.x <= 80)
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
                        if(self.notesToBeplayedArray.count == 0  && !self.musicStaffUtil.containsMoreNode())
                        {
                            self.createSuccessStatusPag()
                        }
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
        midiHelper.playNote(midiHelper.stringToValue(stringCombination).toRaw() , note: 1)
        //musicArray.addObject(musicStaffUtil.createSoundForNode(stringCombination))

    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        //not implementing for now
    }
    
    func getYPositionforMusicalNote(nextNode: String) -> CGFloat
    {
        switch nextNode{
            case "G":
                return self.size.height - 62
            case "F":
                return self.size.height - 72
            case "E":
                return self.size.height - 82
            case "D":
                return self.size.height - 92
            case "C":
                return self.size.height - 102
            case "B":
                return self.size.height - 112
            case "A":
                return self.size.height - 122
            case "G":
                return self.size.height - 132
            case "F":
                return self.size.height - 142
            default:
                return self.size.height - 152
            
        }
    }
    
    
    func fireMusicalNode()
    {
        var nextNode = musicStaffUtil.getNextNode()
        let musicalNode = musicStaffUtil.createMusicalNode(nextNode)
        musicalNode.position.x = self.size.width
        musicalNode.position.y = self.getYPositionforMusicalNote(nextNode)
        
        addChild(musicalNode)
        addMusicalActions(musicalNode)
        notesToBeplayedArray.addObject(musicalNode)
        
        
    }
    
    func addMusicalActions(musicalNode: SKSpriteNode){
        
        // Calculate the node's speed and final destination
        let musicalNodeSpeed: CGFloat = 60
        let musicalNodeMoveTime = size.width / musicalNodeSpeed
        var highlisghNode = self.childNodeWithName(musicalNode.name!) as SKSpriteNode


        let highlightZone = SKAction.runBlock({
            highlisghNode.color = UIColor.cyanColor()
            highlisghNode.alpha = 0.5
        })
        
        
        let highlightZoneRemove = SKAction.runBlock({
            highlisghNode.color = UIColor.clearColor()
        })
        

        // Send the node on its way
        let actionMove = SKAction.moveTo(CGPointMake(self.playArea.position.x - musicalNode.frame.width/2, musicalNode.position.y), duration: NSTimeInterval(musicalNodeMoveTime))
        
        
        var actionrun = SKAction.runBlock({
            self.notesToBeplayedArray.removeObject(musicalNode)
            self.failCount++
            self.missedCountLabel.text = "Missed : " + String(self.failCount)
            if(self.failCount >= 3){
               self.gameEndState()
            }
        })
        
        let actionMoveDone = SKAction.removeFromParent()

        
        musicalNode.runAction(SKAction.sequence([highlightZone,actionMove, actionrun ,highlightZoneRemove, actionMoveDone]))

    }
    
    func restartButtonAction(sender:UIButton!)
    {
        self.restartbutton.removeFromSuperview()
        startGame()
    }
    
    func gameEndState(){
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
        self.restartbutton.addTarget(self, action: "restartButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view!.addSubview(self.restartbutton)
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
    
    func createSuccessStatusPag()
    {
        self.removeAllChildren()
        self.playing = false

        
        self.nextLevelbutton.frame = CGRectMake(100, 300, 100, 50)
        self.nextLevelbutton.backgroundColor = UIColor.blackColor()
        self.nextLevelbutton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.nextLevelbutton.setTitle("Next Level", forState: UIControlState.Normal)
        self.nextLevelbutton.addTarget(self, action: "nextLevelButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view!.addSubview(self.nextLevelbutton)
        
    }
    
    func nextLevelButton(sender:UIButton!)
    {
        println("Button tapped")
        self.nextLevelbutton.removeFromSuperview()
        startGame()
    }
    
    func addEmitterParticles(){
        
        let sparkEmmiter = particleEmitterWithName("trail")
        
        sparkEmmiter!.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 10)
        sparkEmmiter!.name = "sparkEmmitter"
        sparkEmmiter!.targetNode = self
        
        self.addChild(sparkEmmiter!)
    }
    
    func particleEmitterWithName(name : NSString) -> SKEmitterNode?
    {
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "sks")
        
        var sceneData = NSData.dataWithContentsOfFile(path!, options: .DataReadingMappedIfSafe, error: nil)
        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(SKEmitterNode.self, forClassName: "SKEditorScene")
        let node = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as SKEmitterNode?
        archiver.finishDecoding()
        return node
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(playing == true)
        {
            var delta: CFTimeInterval = currentTime - lastUpdateTimeInterval
    
            if (delta > deltaValue) {
                delta = 0;
                lastUpdateTimeInterval = currentTime;
                if(musicStaffUtil.containsMoreNode())
                {
                    fireMusicalNode()
                }
                else
                {
                    //game level is done
                }
            }
        }
    }
}
