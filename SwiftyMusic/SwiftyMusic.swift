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
        public let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        
        fileprivate static let none = FileName("None")
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
            allPlayers.forEach {
                $1.volume = newValue ? 0 : 1
            }
        }
    }
    
    /// Currently playing
    public var currentlyPlaying: FileName {
        return _currentlyPlaying
    }
    
    private var _currentlyPlaying: FileName = .none
    
    /// All av audio players
    private var allPlayers = [String: AVAudioPlayer]()
    
    /// Is paused
    private var isPaused = false
    
    /// Key
    private let mutedKey = "MusicMuteState"
    
    /// File extensions
    fileprivate let fileExtensions = ["mp3", "wav", "aac", "ac3", "m4a", "caf"]
    
    // MARK: - Init
    
    /// Init
    private override init() { }
    
    // MARK: - Setup
    
    /// Setup music players
    ///
    /// Supported file formats: mp3, wav, aac, ac3, m4a, caf
    ///
    /// - parameter fileNames: An array of file names to prepare.
    public func setup(withFileNames fileNames: [FileName]) {
        fileNames.forEach {
            guard let player = prepare(withFileName: $0) else { return }
            allPlayers[$0.rawValue] = player
        }
    }
    
    // MARK: - Play
    
    /// Play music
    ///
    /// - parameter fileName: The player fileName of the music file to play.
    public func play(_ fileName: FileName) {
        guard currentlyPlaying != fileName, let avPlayer = allPlayers[fileName.rawValue] else { return }
        
        _currentlyPlaying = fileName
        
        guard !isPaused else { return }
        
        allPlayers.forEach {
            $1.pause()
        }
        
        avPlayer.volume = isMuted ? 0 : 1
        avPlayer.play()
    }
    
    // MARK: - Adjust volume
    
    /// Set volume to a level
    public func setVolume(to value: Float) {
        guard !isMuted else { return }
        
        allPlayers.forEach {
            $1.volume = value
        }
    }
    
    /// Reset volume
    public func resetVolume() {
        setVolume(to: 1)
    }
    
    // MARK: - Pause / Resume
    
    /// Pause music
    public func pause() {
        isPaused = true
        
        allPlayers.forEach {
            $1.pause()
        }
    }
    
    /// Resume music
    public func resume() {
        isPaused = false
        
        allPlayers.forEach {
            guard $0 == currentlyPlaying.rawValue && !$1.isPlaying else { return }
            $1.play()
        }
    }
    
    // MARK: - Stop
    
    /// Stop and reset all music
    public func stopAndResetAll() {
        _currentlyPlaying = .none
        
        allPlayers.forEach {
            $1.stop()
            $1.currentTime = 0
            setDefaultProperties(forPlayer: $1)
        }
    }
}


// MARK: - AVAudioPlayerDelegate

/// AVAudioPlayerDelegate
extension SwiftyMusic: AVAudioPlayerDelegate {
    
    /// Did finish
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio player did finish playing")
        // finish means when music ended not when paused or stopped
        guard flag else { return }
        setDefaultProperties(forPlayer: player)
    }
    
    /// Decoding error
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Private

private extension SwiftyMusic {
    
    /// Prepare AVPlayer
    func prepare(withFileName fileName: FileName) -> AVAudioPlayer? {
        guard let url = getURL(forFileName: fileName) else { return nil }
        
        do {
            let avPlayer = try AVAudioPlayer(contentsOf: url)
            avPlayer.delegate = self
            setDefaultProperties(forPlayer: avPlayer)
            return avPlayer
        }
            
        catch let error {
            print(error)
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
    
    /// Set player default properties
    func setDefaultProperties(forPlayer avPlayer: AVAudioPlayer) {
        avPlayer.volume = isMuted ? 0 : 1
        avPlayer.numberOfLoops = -1
        avPlayer.prepareToPlay()
    }
    
    /// Print
    /// Overrides the default print method so it print statements only show when in DEBUG mode
    func print(_ items: Any...) {
        #if DEBUG
            Swift.print(items)
        #endif
    }
}
