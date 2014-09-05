//
//  GuitarString.swift
//  GuitarGame
//
//  Created by arun venkatesh on 8/25/14.
//  Copyright (c) 2014 Arun Venkatesh. All rights reserved.
//

import SpriteKit

class Rope : SKNode {
    
    var ropeTexture : String
    var node1 : SKNode
    var node2 : SKNode
    var parentScene : SKScene
    
    init(parentScene scene : SKScene, node node1 : SKNode, node node2 : SKNode, texture tex : String) {
        
        self.ropeTexture = tex
        self.node1 = node1
        self.node2 = node2
        self.parentScene = scene
        
        super.init()
        self.name = "rope"
        
        self.createRope()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createRope() {
        // Calculate distance & angle
        var deltaX = (node2.position.x - node1.position.x)
        var deltaY = (node2.position.y - (node1.position.y  + (node1.frame.size.height / 2)))
        var total = deltaX * deltaX + deltaY * deltaY
        var distance = sqrtf(Float(total))
//        var points = Int(distance / (SKSpriteNode(imageNamed: "rope.png").size.height - 1.0));
        var points = Int(distance / 10);
//        points -= 1;
        var pointX = CGFloat(Float(deltaX)/Float(points))
        var pointY = CGFloat(Float(deltaY)/Float(points))
        var vector = CGPoint(x: pointX, y: pointY)
        var previousNode : SKSpriteNode?
        
        for i in 0...points {
            var x = self.node1.position.x
            var y = self.node1.position.y + (self.node1.frame.size.height / 2)
            
            y += vector.y * CGFloat(i)
            x += vector.x * CGFloat(i)
            
            var ropePiece = SKSpriteNode(imageNamed: self.ropeTexture)
            ropePiece.size = CGSizeMake(5, 10)
            ropePiece.name = "rope"
            ropePiece.position = CGPoint(x: x, y: y)
            
            ropePiece.physicsBody = SKPhysicsBody(rectangleOfSize: ropePiece.size)
            ropePiece.physicsBody!.collisionBitMask = 2
            ropePiece.physicsBody!.categoryBitMask = 2
            ropePiece.physicsBody!.contactTestBitMask = 2
            
            self.parentScene.addChild(ropePiece)
            
            if let pNode = previousNode {
                var pin = SKPhysicsJointPin.jointWithBodyA(pNode.physicsBody, bodyB: ropePiece.physicsBody, anchor: CGPoint(x: CGRectGetMidX(ropePiece.frame), y: CGRectGetMidY(ropePiece.frame)))
                self.parentScene.physicsWorld.addJoint(pin)
            } else {
                if i == 0 {
                    var pin = SKPhysicsJointPin.jointWithBodyA(self.node1.physicsBody, bodyB: ropePiece.physicsBody, anchor: CGPoint(x: CGRectGetMidX(self.node1.frame), y: CGRectGetMinY(self.node1.frame)))
                    self.parentScene.physicsWorld.addJoint(pin)
                }
            }
            
            previousNode = ropePiece
        }
        
        if let pNode = previousNode {
            var pin = SKPhysicsJointPin.jointWithBodyA(self.node2.physicsBody, bodyB: pNode.physicsBody, anchor: CGPoint(x: CGRectGetMidX(pNode.frame), y: CGRectGetMinY(pNode.frame)))
            self.parentScene.physicsWorld.addJoint(pin)
        }
    }
    
    func destroyRope() {
        self.parentScene.enumerateChildNodesWithName("rope", usingBlock: { node, stop in
            node.removeFromParent()
        })
    }
}



