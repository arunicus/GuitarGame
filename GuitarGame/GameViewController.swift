//
//  GameViewController.swift
//  GuitarGame
//
//  Created by Arun Venkatesh on 8/24/14.
//  Copyright (c) 2014 Arun Venkatesh. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = view as SKView
        skView.multipleTouchEnabled = false
 
        // Create and configure the scene.
        var scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
 
        // Present the scene.
        skView.presentScene(scene)
    
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
