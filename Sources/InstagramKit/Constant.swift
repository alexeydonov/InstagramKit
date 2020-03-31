//
//  File.swift
//  
//
//  Created by Alexey Donov on 13.03.2020.
//

import Foundation

enum Constant {
    enum URL {
        static let baseURL = Foundation.URL(string: "https://api.instagram.com/v1")!
        static let authorizationURL = Foundation.URL(string: "https://api.instagram.com/oauth/authorize")!
    }

    enum Configuration {
        static let appClientId = "InstagramAppClientId"
        static let appRedirectURL = "InstagramAppRedirectURL"
        static let baseURL = "InstagramKitBaseUrl"
        static let authorizationURL = "InstagramKitAuthorizationUrl"
    }
}
