//
//  AVAudioPlayer+Mock.swift
//  SwiftyMusicTests
//
//  Created by Dominik Ringler on 05/03/2020.
//  Copyright © 2020 Dominik. All rights reserved.
//

import AVFoundation

private final class TestBundle { }
extension AVAudioPlayer {
    
    static func mock() -> AVAudioPlayer {
        let bundle = Bundle(for: TestBundle.self)
        let path = bundle.path(forResource: "Sample", ofType: "mp3")!
        return try! AVAudioPlayer(contentsOf: URL(string: path)!)
    }
}
