//
//  File.swift
//  
//
//  Created by Alexey Donov on 15.03.2020.
//

import Foundation

public extension Instagram.Engine {
    
    func authorizationURL() -> URL {
        return authorizationURLForScope(.basic)
    }

    func authorizationURLForScope(_ scope: Instagram.Scope) -> URL {
        let parameters = authorizationParametersWithScope(scope)

        var components = URLComponents(url: authorizationURL(), resolvingAgainstBaseURL: false)!
        var items: [URLQueryItem] = []
        for (key, value) in parameters {
            items.append(URLQueryItem(name: key, value: value))
        }
        components.queryItems = items

        return components.url!
    }

    func receivedValidAccessToken(from url: URL) throws -> Bool {
        return try validAccessTokenFromURL(url, appRedirectURL: appRedirectURL!)
    }

    func isSessionValid() -> Bool {
        return accessToken != nil
    }

    func logout() {
        let storage = HTTPCookieStorage.shared
        storage.cookies?.forEach {
            if $0.domain.contains("instagram.com") {
                storage.deleteCookie($0)
            }
        }

        accessToken = nil
    }

}
