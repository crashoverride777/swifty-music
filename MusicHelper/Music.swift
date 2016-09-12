
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

//    v2.1

/*
    Abstract:
    A protocol extension and singleton class to manage music.
*/

import AVFoundation

/// Last played
private var lastPlayed = ""

/// Check mute state
private let mutedKey = "MusicMuteState"
private var muted: Bool {
    get { return UserDefaults.standard.bool(forKey: mutedKey) }
    set { UserDefaults.standard.set(newValue, forKey: mutedKey) }
}

// MARK: - Music Controls

public protocol Music { }
public extension Music {

    /// Check music mute state
    var musicIsMuted: Bool {
        return muted
    }
    
    /// Setup with urls
    public func setupMusicPlayers(withURLs urls: [String]) {
        MusicManager.shared.setupPlayers(withURLs: urls)
    }
    
    /// Play
    func playMusic(playerURL url: String) {
        guard !MusicManager.shared.all.isEmpty else { return }
        guard let avPlayer = MusicManager.shared.all[url] else { return }
        pauseMusic()
        avPlayer.play()
        
        for (url, player) in MusicManager.shared.all where player == avPlayer {
            lastPlayed = url
            break
        }
    }
    
    /// Pause
    func pauseMusic() {
        guard !MusicManager.shared.all.isEmpty else { return }
        for (_, player) in MusicManager.shared.all {
            player.pause()
        }
    }
    
    /// Resume
    func resumeMusic() {
        guard !MusicManager.shared.all.isEmpty else { return }
        for (url, player) in MusicManager.shared.all where url == lastPlayed {
            player.play()
            break
        }
    }
    
    /// Stop
    func stopMusic() {
        guard !MusicManager.shared.all.isEmpty else { return }
        for (_, player) in MusicManager.shared.all {
            player.stop()
            player.currentTime = 0
            player.prepareToPlay()
        }
    }
    
    /// Mute
    func muteMusic() {
        guard !MusicManager.shared.all.isEmpty else { return }
        muted = true
        
        for (_ , player) in MusicManager.shared.all {
            player.volume = 0
        }
    }
    
    /// Unmute
    func unmuteMusic() {
        guard !MusicManager.shared.all.isEmpty else { return }
        muted = false
        
        for (_, player) in MusicManager.shared.all {
            player.volume = 1
        }
    }
}

// MARK: - Music Manager

final class MusicManager: NSObject {

    // MARK: - Static Properties
    
    /// Shared instance
    fileprivate static let shared = MusicManager()
    
    // MARK: - Properties
    
    /// All players
    fileprivate var all = [String: AVAudioPlayer]()
    
    // MARK: - Init
    
    private override init() {
        super.init()
    }
}

/// Setup
private extension MusicManager {

    /// Setup music players
    ///
    /// - parameter withURLs: An array of url strings for the music players to prepare.
    func setupPlayers(withURLs urls: [String]) {
        for url in urls {
            if let player = preparePlayer(withURL: url) {
                all.updateValue(player, forKey: url)
            }
        }
    }
    
    /// Prepare AVPlayer
    ///
    /// - parameter withURL: Prepare the avplayer with the url string.
    /// - returns: Optional AVAudioPlayer.
    func preparePlayer(withURL playerURL: String) -> AVAudioPlayer? {
        var url: URL?
        
        if let urlMP3 = Bundle.main.url(forResource: playerURL, withExtension: "mp3") {
            url = urlMP3
        }
        
        if let urlWAV = Bundle.main.url(forResource: playerURL, withExtension: "wav") {
            url = urlWAV
        }
        
        guard let validURL = url else { return nil }
        
        do {
            let avPlayer = try AVAudioPlayer(contentsOf: validURL)
            avPlayer.delegate = self
            avPlayer.numberOfLoops = -1
            avPlayer.prepareToPlay()
            
            if muted {
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
    
    /// Did finish
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio player did finish playing")
        // finish means when music ended not when paused or stopped
        
        guard flag else { return }
 
        player.prepareToPlay()
    }
    
    /// Decoding error
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
}
