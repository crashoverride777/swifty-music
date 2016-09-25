//
//  GameViewController.swift
//  MusicHelper
//
//  Created by Dominik on 14/01/2016.
//  Copyright (c) 2016 Dominik. All rights reserved.
//

import UIKit
import SpriteKit

/// Music file names
extension Music.FileName {
    static let menu = Music.FileName(rawValue: "MenuMusic")
    static let game = Music.FileName(rawValue: "GameMusic")
    
    static var all: [Music.FileName] = [.menu, .game]
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        Music.shared.setup(forFileNames: Music.FileName.all)

        guard let skView = self.view as? SKView else { return }
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
