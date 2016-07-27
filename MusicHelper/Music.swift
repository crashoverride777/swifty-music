
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

//    v2.0.1

/*
    Abstract:
    A protocol extension and singleton class to manage music.
*/

import AVFoundation

/// Last played
private var lastPlayed = ""

/// Check mute state
private let mutedKey = "MusicMuteState"
public var musicIsMuted: Bool {
    get { return NSUserDefaults.standardUserDefaults().boolForKey(mutedKey) }
    set { NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: mutedKey) }
}

// MARK: - Music Controls

public protocol Music { }
public extension Music {

    /// Setup with urls
    public func setupMusicPlayers(withURLs urls: [String]) {
        MusicManager.sharedInstance.setupPlayers(withURLs: urls)
    }
    
    /// Play
    func playMusic(playerURL url: String) {
        guard !MusicManager.sharedInstance.all.isEmpty else { return }
        guard let avPlayer = MusicManager.sharedInstance.all[url] else { return }
        pauseMusic()
        avPlayer.play()
        
        for (url, player) in MusicManager.sharedInstance.all where player == avPlayer {
            lastPlayed = url
            break
        }
    }
    
    /// Pause
    func pauseMusic() {
        guard !MusicManager.sharedInstance.all.isEmpty else { return }
        for (_, player) in MusicManager.sharedInstance.all {
            player.pause()
        }
    }
    
    /// Resume
    func resumeMusic() {
        guard !MusicManager.sharedInstance.all.isEmpty else { return }
        for (url, player) in MusicManager.sharedInstance.all where url == lastPlayed {
            player.play()
            break
        }
    }
    
    /// Stop
    func stopMusic() {
        guard !MusicManager.sharedInstance.all.isEmpty else { return }
        for (_, player) in MusicManager.sharedInstance.all {
            player.stop()
            player.currentTime = 0
            player.prepareToPlay()
        }
    }
    
    /// Mute
    func muteMusic() {
        guard !MusicManager.sharedInstance.all.isEmpty else { return }
        musicIsMuted = true
        
        for (_ , player) in MusicManager.sharedInstance.all {
            player.volume = 0
        }
    }
    
    /// Unmute
    func unmuteMusic() {
        guard !MusicManager.sharedInstance.all.isEmpty else { return }
        musicIsMuted = false
        
        for (_, player) in MusicManager.sharedInstance.all {
            player.volume = 1
        }
    }
}

// MARK: - Music Manager

class MusicManager: NSObject {

    // MARK: - Static Properties
    
    /// Shared instance
    private static let sharedInstance = MusicManager()
    
    // MARK: - Properties
    
    /// All players
    private var all = [String: AVAudioPlayer]()
}

/// Setup
private extension MusicManager {

    func setupPlayers(withURLs urls: [String]) {
        for url in urls {
            if let player = preparePlayer(withURL: url) {
                all.updateValue(player, forKey: url)
            }
        }
    }
    
    func preparePlayer(withURL playerURL: String) -> AVAudioPlayer? {
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
            
            if musicIsMuted {
                avPlayer.volume = 0
            }
            
            return avPlayer
        }
            
        catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
}

/// AVAudioPlayerDelegate
extension MusicManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio player did finish playing")
        // finish means when music ended not when paused or stopped
        
        guard flag else { return }
 
        player.prepareToPlay()
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
}