//
//  File.swift
//  
//
//  Created by Alexey Donov on 15.03.2020.
//

import Foundation

public extension Instagram.Engine {

    func getSelfUserDetails(completion: @escaping (Result<Instagram.User, Error>) -> Void) {
        let endpoint = Constant.URL.baseURL
            .appendingPathComponent("me")

        sendRequest(to: endpoint, method: .get, parameters: ["fields" : "id,username"], expecting: Instagram.User.self, completion: completion)
    }
    
}
