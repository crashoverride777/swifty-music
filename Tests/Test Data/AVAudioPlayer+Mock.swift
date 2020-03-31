//
//  AVAudioPlayer+Mock.swift
//  SwiftyMusicTests
//
//  Created by Dominik Ringler on 05/03/2020.
//  Copyright © 2020 Dominik. All rights reserved.
//

import AVFoundation

extension AVAudioPlayer {
    
    static func mock() -> AVAudioPlayer {
        return try! AVAudioPlayer(contentsOf: URL(string: "Sample")!)
    }
}
