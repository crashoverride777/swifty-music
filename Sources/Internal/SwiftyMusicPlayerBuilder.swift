//
//  SwiftyMusicPlayerBuilder.swift
//  SwiftyMusicTests
//
//  Created by Dominik Ringler on 05/03/2020.
//  Copyright © 2020 Dominik. All rights reserved.
//

import AVFoundation

protocol SwiftyMusicPlayerBuilderType: AnyObject {
    func build(forFileName fileName: String, delegate: AVAudioPlayerDelegate) -> AVAudioPlayer?
}

final class SwiftyMusicPlayerBuilder {
    private let bundle: Bundle
    private let fileExtensions = ["mp3", "wav", "aac", "ac3", "m4a", "caf"]
    
    init(bundle: Bundle) {
        self.bundle = bundle
    }
}

extension SwiftyMusicPlayerBuilder: SwiftyMusicPlayerBuilderType {
    
    func build(forFileName fileName: String, delegate: AVAudioPlayerDelegate) -> AVAudioPlayer? {
        let urls = fileExtensions.compactMap { bundle.url(forResource: fileName, withExtension: $0) }
        
        guard let url = urls.first else {
            return nil
        }
        
        do {
            let avPlayer = try AVAudioPlayer(contentsOf: url)
            avPlayer.delegate = delegate
            avPlayer.numberOfLoops = -1
            avPlayer.prepareToPlay()
            return avPlayer
        } catch {
            print("SwiftyMusicPlayerBuilder error \(error)")
            return nil
        }
    }
}
