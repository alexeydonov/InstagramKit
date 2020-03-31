//
//  File.swift
//  
//
//  Created by Alexey Donov on 15.03.2020.
//

import Foundation

extension Instagram {

    public struct Scope: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        static let basic = Scope([])
        static let comments = Scope(rawValue: 1<<1)
        static let relationships = Scope(rawValue: 1<<2)
        static let likes = Scope(rawValue: 1<<3)
        static let publicContent = Scope(rawValue: 1<<4)
        static let followerList = Scope(rawValue: 1<<5)
    }

}
