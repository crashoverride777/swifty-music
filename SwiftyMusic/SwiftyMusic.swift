
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

//    v4.0

import AVFoundation

/**
 SwiftyMusic
 
 A singleton class to play music with AVAudioPlayer.
 */
public class SwiftyMusic: NSObject {
    
    // MARK: - Static Properties
    
    /// Shared instance
    public static let shared = SwiftyMusic()
    
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
    
    /// Supported file extensions
    fileprivate var fileExtensions = ["mp3", "wav", "aac", "ac3", "m4a", "caf"]
    
    // MARK: - Init
    
    /// Private singleton init
    private override init() { }
    
    // MARK: - Methods
    
    /// Setup music players
    ///
    /// Supported file formates: mp3, wav, aac, ac3, m4a, caf
    ///
    /// - parameter urls: An array of url strings for the music players to prepare.
    public func setup(forFileNames fileNames: [FileName]) {
        for fileName in fileNames {
            if let player = prepare(forFileName: fileName.rawValue) {
                all.updateValue(player, forKey: fileName.rawValue)
            }
        }
    }
    
    /// Play music
    ///
    /// - parameter fileName: The player fileName string of the music file to play.
    public func play(_ fileName: FileName) {
        guard !all.isEmpty, let avPlayer = all[fileName.rawValue] else { return }
        pause()
        avPlayer.play()
        lastPlayed = fileName.rawValue
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
    
    /// Stop music and reset all players
    public func stopAndResetAll() {
        guard !all.isEmpty else { return }
        lastPlayed = ""
        
        for (_, player) in all {
            player.stop()
            player.currentTime = 0
            player.prepareToPlay()
        }
    }
}

// MARK: - Prepare

/// Prepare
private extension SwiftyMusic {
    
    /// Prepare AVPlayer
    ///
    /// - parameter playerURL: Prepare the avplayer with the url string.
    /// - returns: Optional AVAudioPlayer.
    func prepare(forFileName fileName: String) -> AVAudioPlayer? {
        guard let url = getURL(forFileName: fileName) else { return nil }
        
        do {
            let avPlayer = try AVAudioPlayer(contentsOf: url)
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
    
    /// Get file url
    func getURL(forFileName fileName: String) -> URL? {
        for fileExtension in fileExtensions {
            if let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
                return url
            }
        }
        
        return nil
    }
}

// MARK: - Delegates

/// AVAudioPlayerDelegate
extension SwiftyMusic: AVAudioPlayerDelegate {
    
    /// Did finish. Finish means when music ended not when calling stop
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio player did finish playing")
        
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
