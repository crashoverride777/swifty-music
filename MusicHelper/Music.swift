
//  Created by Dominik on 14/1/2016.

//    The MIT License (MIT)
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

//    v1.2

import AVFoundation

/// URLs
private struct URL {
    static let avPlayer1 = "AngryFlappiesMenuMusic"
    static let avPlayer2 = "AngryFlappiesGameMusic"
    static let avPlayerExtension = "mp3"
}

/// Last played
private enum LastPlayed {
    case Nothing
    case AVPlayer1
    case AVPlayer2
}

/// Music singleton class
class Music: NSObject {
    
    // MARK: - Static Properties
    
    /// Shared instance
    static let sharedInstance = Music()
    
    // MARK: - Properties
    
    var error: NSError?
    
    /// Players
    private var avPlayer1: AVAudioPlayer?
    private var avPlayer2: AVAudioPlayer?
    
    /// Last played
    private var lastPlayed = LastPlayed.Nothing
    
    /// Muted key
    private let mutedKey = "MusicMuteState"
    
    /// Is muted
    var isMuted: Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(mutedKey)
    }
    
    // MARK: - Init
    private override init() {
        super.init()
        prepareAVPlayer1()
        prepareAVPlayer2()
        
        if isMuted {
            mute()
        }
    }
    
    // MARK: - User Methods
    
    /// Play
    func playMenu() {
        guard playing(avPlayer1) else { return }
        lastPlayed = .AVPlayer1
    }
    
    func playGame() {
        guard playing(avPlayer2) else { return }
        lastPlayed = .AVPlayer2
    }
    
    /// Pause
    func pause() {
        avPlayer1?.pause()
        avPlayer2?.pause()
    }
    
    /// Resume
    func resume() {
        switch lastPlayed {
        case .AVPlayer1:
            avPlayer1?.play()
        case .AVPlayer2:
            avPlayer2?.play()
        case .Nothing:
            break
        }
    }
    
    /// Stop
    func stop() {
        avPlayer1?.stop()
        avPlayer1?.currentTime = 0
        avPlayer1?.prepareToPlay()
        
        avPlayer2?.stop()
        avPlayer2?.currentTime = 0
        avPlayer2?.prepareToPlay()
    }
    
    /// Mute
    func mute() {
        avPlayer1?.volume = 0
        avPlayer2?.volume = 0
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: mutedKey)
    }
    
    /// Unmute
    func unmute() {
        avPlayer1?.volume = 1
        avPlayer2?.volume = 1
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: mutedKey)
    }
    
    // MARK: - Private Methods
    
    /// Play
    private func playing(avPlayer: AVAudioPlayer?) -> Bool {
        guard let avPlayer = avPlayer else { return false }
        pause()
        avPlayer.play()
        return true
    }
    
    /// Prepare player 1
    private func prepareAVPlayer1() {
        
        do {
            guard let avPlayer1URL = NSBundle.mainBundle().URLForResource(URL.avPlayer1, withExtension: URL.avPlayerExtension) else { return }
            avPlayer1 = try AVAudioPlayer(contentsOfURL: avPlayer1URL)
            avPlayer1?.delegate = self
            avPlayer1?.numberOfLoops = -1
            avPlayer1?.prepareToPlay()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    /// Prepare player 2
    private func prepareAVPlayer2() {
        
        do {
            guard let avPlayer2URL = NSBundle.mainBundle().URLForResource(URL.avPlayer2, withExtension: URL.avPlayerExtension) else { return }
            avPlayer2 = try AVAudioPlayer(contentsOfURL: avPlayer2URL)
            avPlayer2?.delegate = self
            avPlayer2?.numberOfLoops = -1
            avPlayer2?.prepareToPlay()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Delegates
extension Music: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio player did finish playing")
        // finish means when music ended and is not looped, not when you pause or stop it
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
}