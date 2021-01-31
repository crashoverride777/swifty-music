//
//  MockPlayerBuilder.swift
//  SwiftyMusicTests
//
//  Created by Dominik Ringler on 05/03/2020.
//  Copyright © 2020 Dominik. All rights reserved.
//

import Foundation
import AVFoundation
@testable import SwiftyMusic

final class MockPlayerBuilder {
    struct Stub {
        var build: (String, AVAudioPlayerDelegate?) -> AVAudioPlayer? = { (_, _) in nil }
    }
    
    var stub = Stub()
}

extension MockPlayerBuilder: SwiftyMusicPlayerBuilderType {
    
    func build(forFileName fileName: String, delegate: AVAudioPlayerDelegate) -> AVAudioPlayer? {
        stub.build(fileName, delegate)
    }
}
