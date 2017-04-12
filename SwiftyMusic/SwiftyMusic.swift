//    The MIT License (MIT)
//
//    Copyright (c) 2016-2017 Dominik Ringler
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

/**
 SwiftyMusic
 
 A singleton class to play music with AVAudioPlayer.
 */
public class SwiftyMusic: NSObject {
    
    /// File Names
    public struct FileName: RawRepresentable {
        public var rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        fileprivate static let none = FileName(rawValue: "None")
    }
    
    // MARK: - Static Properties
    
    /// Shared instance
    public static let shared = SwiftyMusic()
    
    // MARK: - Properties
    
    /// Is muted
    public var isMuted: Bool {
        get { return UserDefaults.standard.bool(forKey: mutedKey) }
        set {
            UserDefaults.standard.set(newValue, forKey: mutedKey)
            guard !allPlayers.isEmpty else { return }
            allPlayers.forEach {
                $1.volume = newValue ? 0 : 1
            }
        }
    }
    
    /// Current playing
    public var currentlyPlaying: FileName {
        return currentlyPlayingFile
    }
    private var currentlyPlayingFile: FileName = .none
    
    /// All players
    private var allPlayers = [String: AVAudioPlayer]()
    
    /// Is paused
    private var isPaused = false
    
    /// Muted key
    private let mutedKey = "MusicMuteState"
    
    /// Supported file extensions
    fileprivate let fileExtensions = ["mp3", "wav", "aac", "ac3", "m4a", "caf"]
    
    // MARK: - Init
    
    private override init() { }
    
    // MARK: - Setup
    
    /// Setup music players
    ///
    /// Supported file formates: mp3, wav, aac, ac3, m4a, caf
    ///
    /// - parameter urls: An array of url strings for the music players to prepare.
    public func setup(withFileNames fileNames: [FileName]) {
        fileNames.forEach {
            guard let player = prepare(forFileName: $0) else { return }
            allPlayers[$0.rawValue] = player
        }
    }
    
    // MARK: - Play
    
    /// Play music
    ///
    /// - parameter fileName: The player fileName string of the music file to play.
    public func play(_ fileName: FileName) {
        guard !allPlayers.isEmpty, currentlyPlaying != fileName, let avPlayer = allPlayers[fileName.rawValue] else { return }
        
        currentlyPlayingFile = fileName
        
        guard !isPaused else { return }
        
        allPlayers.forEach {
            $1.pause()
            guard isMuted else { return }
            $1.volume = 0
        }
        
        avPlayer.play()
    }
    
    // MARK: - Pause and Resume
    
    /// Pause music
    public func pause() {
        isPaused = true
        
        guard !allPlayers.isEmpty else { return }
        allPlayers.forEach {
            $1.pause()
        }
    }
    
    /// Resume music
    public func resume() {
        isPaused = false
        resetVolume()
        
        guard !allPlayers.isEmpty else { return }
        allPlayers.forEach {
            guard $0 == currentlyPlaying.rawValue && !$1.isPlaying else { return }
            $1.play()
        }
    }
    
    // MARK: - Adjust volume
    
    /// Set volume to a level
    public func setVolume(to value: Float) {
        guard !isMuted, !allPlayers.isEmpty else { return }
        allPlayers.forEach {
            $1.volume = value
        }
    }
    
    /// Reset volume
    public func resetVolume() {
        guard !isMuted, !allPlayers.isEmpty else { return }
        allPlayers.forEach {
            $1.volume = 1
        }
    }
    
    // MARK: - Stop and Reset
    
    /// Stop music and reset all players
    public func stopAndResetAll() {
        currentlyPlayingFile = .none
        
        guard !allPlayers.isEmpty else { return }
        allPlayers.forEach {
            $1.stop()
            $1.currentTime = 0
            $1.volume = 1
            $1.prepareToPlay()
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
    func prepare(forFileName fileName: FileName) -> AVAudioPlayer? {
        guard let url = getURL(forFileName: fileName) else { return nil }
        
        do {
            let avPlayer = try AVAudioPlayer(contentsOf: url)
            avPlayer.delegate = self
            avPlayer.volume = isMuted ? 0 : 1
            avPlayer.numberOfLoops = -1
            avPlayer.prepareToPlay()
            return avPlayer
        }
            
        catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Get file url
    func getURL(forFileName fileName: FileName) -> URL? {
        for fileExtension in fileExtensions {
            guard let url = Bundle.main.url(forResource: fileName.rawValue, withExtension: fileExtension) else { continue }
            return url
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
