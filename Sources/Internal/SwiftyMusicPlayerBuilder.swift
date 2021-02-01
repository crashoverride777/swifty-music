//    The MIT License (MIT)
//
//    Copyright (c) 2016-2021 Dominik Ringler
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import AVFoundation

protocol SwiftyMusicPlayerBuilderType: AnyObject {
    func build(withFileName fileName: String, delegate: AVAudioPlayerDelegate) -> AVAudioPlayer?
}

final class SwiftyMusicPlayerBuilder {
    private let bundle: Bundle
    private let fileExtensions = ["mp3", "wav", "aac", "ac3", "m4a", "caf"]
    
    init(bundle: Bundle) {
        self.bundle = bundle
    }
}

extension SwiftyMusicPlayerBuilder: SwiftyMusicPlayerBuilderType {
    
    func build(withFileName fileName: String, delegate: AVAudioPlayerDelegate) -> AVAudioPlayer? {
        guard let url = fileExtensions.compactMap({ bundle.url(forResource: fileName, withExtension: $0) }).first else {
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
