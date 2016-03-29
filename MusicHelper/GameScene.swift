//
//  GameScene.swift
//  MusicHelper
//
//  Created by Dominik on 14/01/2016.
//  Copyright (c) 2016 Dominik. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var touchCounter = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Touch 3 times"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
        
        Music.sharedInstance.playGame()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        touchCounter += 1
        
        if touchCounter == 1 {
            Music.sharedInstance.pause() // play new game music
        }
        if touchCounter == 2 {
            Music.sharedInstance.resume()
        }
        if touchCounter == 3 {
            touchCounter = 0
            Music.sharedInstance.stop()
            Music.sharedInstance.playMenu()
        }
    }
}