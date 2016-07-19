//
//  GameScene.swift
//  MusicHelper
//
//  Created by Dominik on 14/01/2016.
//  Copyright (c) 2016 Dominik. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, MusicControls {
    
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    var touchCounter = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        myLabel.text = "Touch to pause"
        myLabel.fontSize = 40
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
        
        playMusic(playerURL: MusicURL.game.rawValue)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        touchCounter += 1
        
        if touchCounter == 1 {
            myLabel.text = "Touch to resume"
            pauseMusic() // play new game music
        }
        if touchCounter == 2 {
            myLabel.text = "Touch to stop and play menu"
            resumeMusic()
        }
        if touchCounter == 3 {
            myLabel.text = "Touch to pause"
            touchCounter = 0
            stopMusic()
            playMusic(playerURL: MusicURL.menu.rawValue)
        }
    }
}