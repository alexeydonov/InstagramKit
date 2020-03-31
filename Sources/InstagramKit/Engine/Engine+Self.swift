//
//  File.swift
//  
//
//  Created by Alexey Donov on 15.03.2020.
//

import Foundation

extension Instagram.Engine {

    public func getSelfUserDetails(completion: @escaping (Result<Instagram.User, Error>) -> Void) {
        getUserDetails(userId: "self", completion: completion)
    }
    
}
