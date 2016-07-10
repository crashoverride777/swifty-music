
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

//    v1.4

import AVFoundation

public class Music: NSObject {
    
    // MARK: - Static Properties
    
    /// Shared instance
    public static let sharedInstance = Music()
    
    // MARK: - Properties
    
    /// All players
    private var allPlayers = [String: AVAudioPlayer]()
    
    /// Last played
    private var lastPlayed = ""
    
    /// Check mute state
    private let mutedKey = "MusicMuteState"
    public var isMuted: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey(mutedKey) }
        set { NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: mutedKey) }
    }
    
    // MARK: - Init
    private override init() {
        super.init()
    }
    
    // MARK: - User Methods
    
    /// SetUp
    public func setUp(urls urls: [String]) {
        for url in urls {
            if let player = prepare(withURL: url) {
                allPlayers.updateValue(player, forKey: url)
            }
        }
        
        if isMuted {
            mute()
        }
    }
    
    /// Play
    public func play(playerURL url: String) {
        guard let avPlayer = allPlayers[url] else { return }
        pause()
        avPlayer.play()
        
        for (url, player) in allPlayers where player == avPlayer {
            lastPlayed = url
            break
        }
    }
    
    /// Pause
    public func pause() {
        for (_, player) in allPlayers {
            player.pause()
        }
    }
    
    /// Resume
    public func resume() {
        for (url, player) in allPlayers where url == lastPlayed {
            player.play()
            break
        }
    }
    
    /// Stop
    public func stop() {
        for (_, player) in allPlayers {
            player.stop()
            player.currentTime = 0
            player.prepareToPlay()
        }
    }
    
    /// Mute
    public func mute() {
        for (_ , player) in allPlayers {
            player.volume = 0
        }
        
        isMuted = true
    }
    
    /// Unmute
    public func unmute() {
        for (_, player) in allPlayers {
            player.volume = 1
        }
        
        isMuted = false
    }
}

// MARK: - Delegates
extension Music: AVAudioPlayerDelegate {
    
    public func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio player did finish playing")
        // finish means when music ended not when paused or stopped
    }
    
    public func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Prepare Audio Player

private extension Music {
    
    func prepare(withURL playerURL: String) -> AVAudioPlayer? {
        var url: NSURL?
        
        if let urlMP3 = NSBundle.mainBundle().URLForResource(playerURL, withExtension: "mp3") {
            url = urlMP3
        }
        
        if let urlWAV = NSBundle.mainBundle().URLForResource(playerURL, withExtension: "wav") {
            url = urlWAV
        }
        
        guard let validURL = url else { return nil }
        
        do {
            let avPlayer = try AVAudioPlayer(contentsOfURL: validURL)
            avPlayer.delegate = self
            avPlayer.numberOfLoops = -1
            avPlayer.prepareToPlay()
            return avPlayer
        }
            
        catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
}