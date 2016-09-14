
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

//    v3.0

import AVFoundation

/**
 Music
 
 Singleton class used music playback.
 */
public class Music: NSObject {
    
    // MARK: - Static Properties
    
    /// Shared instance
    public static let shared = Music()
    
    // MARK: - Properties
    
    /// File names
    public struct FileName: RawRepresentable {
        public var rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    /// Check music mute state
    public var isMuted: Bool {
        return muted
    }
    
    /// Mute state
    private let mutedKey = "MusicMuteState"
    private var muted: Bool {
        get { return UserDefaults.standard.bool(forKey: mutedKey) }
        set { UserDefaults.standard.set(newValue, forKey: mutedKey) }
    }
    
    /// All players
    private var all = [String: AVAudioPlayer]()
    
    /// Last played
    private var lastPlayed = ""
    
    // MARK: - Init
    
    /// Private singleton init
    private override init() {
        super.init()
    }
    
    // MARK: - Methods
    
    /**
     Setup music players
     
     - parameter urls: An array of url strings for the music players to prepare.
     */
    public func setup(forFileNames fileNames: [Music.FileName]) {
        for fileName in fileNames {
            if let player = prepare(forFileName: fileName.rawValue) {
                all.updateValue(player, forKey: fileName.rawValue)
            }
        }
    }
    
    /**
     Play music
     
     - parameter fileName: The player fileName string of the music file to play.
     */
    public func play(_ fileName: Music.FileName) {
        guard !all.isEmpty else { return }
        guard let avPlayer = all[fileName.rawValue] else { return }
        pause()
        avPlayer.play()
        
        for (url, player) in all where player == avPlayer {
            lastPlayed = url
            break
        }
    }
    
    /// Pause music
    public func pause() {
        guard !all.isEmpty else { return }
        for (_, player) in all {
            player.pause()
        }
    }
    
    /// Resume music
    public func resume() {
        guard !all.isEmpty else { return }
        for (url, player) in all where url == lastPlayed {
            player.play()
            break
        }
    }
    
    /// Stop music
    public func stop() {
        guard !all.isEmpty else { return }
        for (_, player) in all {
            player.stop()
            player.currentTime = 0
            player.prepareToPlay()
        }
    }
    
    /// Mute music
    public func mute() {
        guard !all.isEmpty else { return }
        muted = true
        
        for (_ , player) in all {
            player.volume = 0
        }
    }
    
    /// Unmute music
    public func unmute() {
        guard !all.isEmpty else { return }
        muted = false
        
        for (_, player) in all {
            player.volume = 1
        }
    }
}

// MARK: - Prepare

/// Prepare
private extension Music {
    
    /**
     Prepare AVPlayer
     
     - parameter playerURL: Prepare the avplayer with the url string.
     - returns: Optional AVAudioPlayer.
     */
    func prepare(forFileName fileName: String) -> AVAudioPlayer? {
        var url: URL?
        
        if let urlMP3 = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            url = urlMP3
        }
        
        if let urlWAV = Bundle.main.url(forResource: fileName, withExtension: "wav") {
            url = urlWAV
        }
        
        guard let validURL = url else { return nil }
        
        do {
            let avPlayer = try AVAudioPlayer(contentsOf: validURL)
            avPlayer.delegate = self
            avPlayer.numberOfLoops = -1
            avPlayer.prepareToPlay()
            
            if isMuted {
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

// MARK: - Delegates

/// AVAudioPlayerDelegate
extension Music: AVAudioPlayerDelegate {
    
    /// Did finish
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio player did finish playing")
        // finish means when music ended not when paused or stopped
        
        guard flag else { return }
        
        player.prepareToPlay()
    }
    
    /// Decoding error
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
}
