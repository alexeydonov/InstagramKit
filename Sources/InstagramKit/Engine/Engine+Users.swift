//
//  File.swift
//  
//
//  Created by Alexey Donov on 15.03.2020.
//

import Foundation

extension Instagram.Engine {

    func getUserDetails(userId: String, completion: @escaping (Result<Instagram.User, Error>) -> Void) {
        let endpoint = Constant.URL.baseURL
            .appendingPathComponent("users")
            .appendingPathComponent(userId)

        sendRequest(to: endpoint, method: .get, expecting: Instagram.User.self, completion: completion)
    }

}
