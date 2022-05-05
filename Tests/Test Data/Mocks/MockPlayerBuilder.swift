import Foundation
import AVFoundation
@testable import SwiftyMusic

final class MockPlayerBuilder {
    struct Stub {
        var build: (String, AVAudioPlayerDelegate?) -> AVAudioPlayer? = { (_, _) in nil }
    }
    
    var stub = Stub()
}

extension MockPlayerBuilder: SwiftyMusicPlayerBuilderType {
    func build(withFileName fileName: String, delegate: AVAudioPlayerDelegate) -> AVAudioPlayer? {
        stub.build(fileName, delegate)
    }
}
