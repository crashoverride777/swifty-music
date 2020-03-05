//
//  SwiftyMusicFileName.swift
//  SwiftyMusic
//
//  Created by Dominik Ringler on 05/03/2020.
//  Copyright © 2020 Dominik. All rights reserved.
//

import Foundation

public struct SwiftyMusicFileName: RawRepresentable, Equatable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

extension SwiftyMusicFileName {
    static let none = SwiftyMusicFileName("None")
}
