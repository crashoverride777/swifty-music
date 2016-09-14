//
//  GameScene.swift
//  MusicHelper
//
//  Created by Dominik on 14/01/2016.
//  Copyright (c) 2016 Dominik. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    var touchCounter = 0
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        myLabel.text = "Touch to pause"
        myLabel.fontSize = 40
        myLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        self.addChild(myLabel)
        
        Music.shared.play(.game)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        touchCounter += 1
        
        if touchCounter == 1 {
            myLabel.text = "Touch to resume"
            Music.shared.pause() // play new game music
        }
        if touchCounter == 2 {
            myLabel.text = "Touch to stop and play menu"
            Music.shared.resume()
        }
        if touchCounter == 3 {
            myLabel.text = "Touch to pause"
            touchCounter = 0
            Music.shared.stop()
            Music.shared.play(.menu)
        }
    }
}
