import AVFoundation

final class MockAVAudioPlayer: AVAudioPlayer {

    struct Mock {
        var playCalled = false
        var pauseCalled = false
        var stopCalled = false
        var prepareToPlayCalled = false
    }

    var mock = Mock()

    override init() {
        guard let path =  Bundle.module.path(forResource: "Sample", ofType: "mp3") else {
            fatalError("MockAVAudioPlayer invalid path")
        }
        guard let url = URL(string: path) else {
            fatalError("MockAVAudioPlayer invalid path url")
        }
        do {
            try super.init(contentsOf: url, fileTypeHint: nil)
        } catch {
            fatalError("MockAVAudioPlayer error \(error)")
        }
    }

    override func play() -> Bool {
        mock.playCalled = true
        return true
    }

    override func pause() {
        mock.pauseCalled = true
    }

    override func stop() {
        mock.stopCalled = true
    }

    override func prepareToPlay() -> Bool {
        mock.prepareToPlayCalled = true
        return true
    }
}
