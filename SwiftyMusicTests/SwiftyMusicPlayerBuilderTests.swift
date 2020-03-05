//
//  SwiftyMusicPlayerBuilderTests.swift
//  SwiftyMusicTests
//
//  Created by Dominik Ringler on 05/03/2020.
//  Copyright © 2020 Dominik. All rights reserved.
//

import XCTest
import AVFoundation
@testable import SwiftyMusic

class SwiftyMusicPlayerBuilderTests: XCTestCase {

    // MARK: - Properties
    
    private var bundle: Bundle!
    
    // MARK: - Life Cycle
    
    override func setUp() {
        super.setUp()
        bundle = Bundle(for: SwiftyMusicPlayerBuilderTests.self)
    }
    
    override func tearDown() {
        bundle = nil
        super.tearDown()
    }

    // MARK: - Tests
    
    func test() {
        
        let sut = makeSUT()
        let player = sut.build(forFileName: "Sample", delegate: self)
        player?.play()
        //player?.pause()
        XCTAssertTrue(player!.isPlaying)
        
    }
    
    func test_invalidURL_returnsNil() {
        let sut = makeSUT()
        let player = sut.build(forFileName: "invalid", delegate: self)
        XCTAssertNil(player)
    }
    
    func test_validURL_returnsPlayer() {
        let sut = makeSUT()
        let player = sut.build(forFileName: "Sample", delegate: self)
        XCTAssertNotNil(player)
    }
    
    func test_validURL_setsPlayerDelegate() {
        let sut = makeSUT()
        let player = sut.build(forFileName: "Sample", delegate: self)
        XCTAssertTrue(player?.delegate is SwiftyMusicPlayerBuilderTests)
    }
    
    func test_validURL_setsCorrectPlayerLoops() {
        let sut = makeSUT()
        let player = sut.build(forFileName: "Sample", delegate: self)
        XCTAssertEqual(player?.numberOfLoops, -1)
    }
}

// MARK: - AVAudioPlayerDelegate

extension SwiftyMusicPlayerBuilderTests: AVAudioPlayerDelegate {
    
}

// MARK: - Private Methods

private extension SwiftyMusicPlayerBuilderTests {
    
    func makeSUT() -> SwiftyMusicPlayerBuilder {
        SwiftyMusicPlayerBuilder(bundle: bundle)
    }
}