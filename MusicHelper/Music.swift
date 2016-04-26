
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

//    v1.3

import AVFoundation

/// URLs
private struct URL {
    static let avPlayer1 = "AngryFlappiesMenuMusic"
    static let avPlayer2 = "AngryFlappiesGameMusic"
}

/// Music singleton class
class Music: NSObject {
    
    // MARK: - Static Properties
    
    /// Shared instance
    static let sharedInstance = Music()
    
    // MARK: - Properties
    
    /// Players
    private var avPlayer1: AVAudioPlayer?
    private var avPlayer2: AVAudioPlayer?
    
    private var allPlayers: [AVAudioPlayer?] = []
    
    /// Last played
    private var lastPlayed = -1
   
    /// Is muted
    private let mutedKey = "MusicMuteState"
    var isMuted: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey(mutedKey) }
        set { NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: mutedKey) }
    }
    
    // MARK: - Init
    private override init() {
        super.init()
        
        avPlayer1 = preparePlayer(url: URL.avPlayer1)
        avPlayer2 = preparePlayer(url: URL.avPlayer2)
        
        allPlayers = [avPlayer1, avPlayer2]
        
        if isMuted {
            mute()
        }
    }
    
    // MARK: - User Methods
    
    /// Play
    func playMenu() {
        play(avPlayer1)
    }
    
    func playGame() {
        play(avPlayer2)
    }
    
    /// Pause
    func pause() {
        for player in allPlayers {
            player?.pause()
        }
    }
    
    /// Resume
    func resume() {
        for (index, player) in allPlayers.enumerate() {
            if index == lastPlayed {
                player?.play()
                return
            }
        }
    }
    
    /// Stop
    func stop() {
        for player in allPlayers {
            player?.stop()
            player?.currentTime = 0
            player?.prepareToPlay()
        }
    }
    
    /// Mute
    func mute() {
        for player in allPlayers {
            player?.volume = 0
        }
        
        isMuted = true
    }
    
    /// Unmute
    func unmute() {
        for player in allPlayers {
            player?.volume = 1
        }
        
        isMuted = false
    }
    
    // MARK: - Private Methods
    
    /// Playing
    private func play(avPlayer: AVAudioPlayer?) {
        guard let avPlayer = avPlayer else { return }
        
        pause()
        avPlayer.play()
        
        for (index, _) in allPlayers.enumerate() {
            if allPlayers[index] == avPlayer {
                lastPlayed = index
                return
            }
        }
    }
}

// MARK: - Delegates
extension Music: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("Audio player did finish playing")
            // finish means when music ended and is not looped, not when you pause or stop it
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Prepare Player
private extension Music {
    
    func preparePlayer(url playerURL: String) -> AVAudioPlayer? {
        var avPlayer: AVAudioPlayer?
        
        do {
            if let url = NSBundle.mainBundle().URLForResource(playerURL, withExtension: "mp3") {
                avPlayer = try AVAudioPlayer(contentsOfURL: url)
                avPlayer?.delegate = self
                avPlayer?.numberOfLoops = -1
                avPlayer?.prepareToPlay()
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return avPlayer
    }
}