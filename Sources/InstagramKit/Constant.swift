//
//  File.swift
//  
//
//  Created by Alexey Donov on 13.03.2020.
//

import Foundation

enum Constant {
    enum URL {
        static let baseURL = Foundation.URL(string: "https://graph.instagram.com/")!
        static let oauthURL = Foundation.URL(string: "https://api.instagram.com/oauth")!
        static let authorizationURL = oauthURL.appendingPathComponent("authorize")
        static let shortTokenURL = oauthURL.appendingPathComponent("access_token")
        static let longTokenURL = baseURL.appendingPathComponent("access_token")
    }

    enum Configuration {
        static let appClientId = "InstagramAppClientId"
        static let appClientSecret = "InstagramAppClientSecret"
        static let appRedirectURL = "InstagramAppRedirectURL"
        static let baseURL = "InstagramKitBaseUrl"
        static let authorizationURL = "InstagramKitAuthorizationUrl"
    }
}
