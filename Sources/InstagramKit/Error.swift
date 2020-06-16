//
//  File.swift
//  
//
//  Created by Alexey Donov on 15.03.2020.
//

import Foundation

extension Instagram {

    public enum Error: Swift.Error {
        case authenticationFailed
        case noToken
    }

    enum PaginationError: Swift.Error {
        case emptyPaginationInfo
    }
    
}
