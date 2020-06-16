//
//  File.swift
//  
//
//  Created by Alexey Donov on 15.03.2020.
//

import Foundation

public extension Instagram.Engine {
    
    func authorizationURL() -> URL {
        return authorizationURLForScopes([.userProfile])
    }

    func authorizationURLForScopes(_ scopes: Set<Instagram.Scope>) -> URL {
        let parameters = authorizationParametersWithScopes(scopes)

        var components = URLComponents(url: Constant.URL.authorizationURL, resolvingAgainstBaseURL: false)!
        var items: [URLQueryItem] = []
        for (key, value) in parameters {
            items.append(URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
        }
        components.queryItems = items

        return components.url!
    }

    func receivedCode(from url: URL) -> String? {
        return codeFromURL(url, appRedirectURL: appRedirectURL!)
    }

    struct ShortTokenHolder: Decodable {
        var token: String
        var userId: Int

        enum CodingKeys: String, CodingKey {
            case token = "access_token"
            case userId = "user_id"
        }
    }

    func exchangeCodeForShortToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: Constant.URL.shortTokenURL)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "client_id=\(appClientID!)&client_secret=\(appClientSecret!)&code=\(code)&grant_type=authorization_code&redirect_uri=\(appRedirectURL!.absoluteString)".data(using: .utf8)
        request.httpMethod = Method.post.rawValue

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            do {
                guard let data = data else {
                    completion(.failure(Instagram.Error.noToken))
                    return
                }

                let holder = try JSONDecoder().decode(ShortTokenHolder.self, from: data)
                completion(.success(holder.token))
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }

    struct LongTokenHolder: Decodable {
        var token: String
        var type: String
        var expiresIn: Int

        enum CodingKeys: String, CodingKey {
            case token = "access_token"
            case type = "token_type"
            case expiresIn = "expires_in"
        }
    }

    func exchangeShortTokenForLongToken(_ shortToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        var components = URLComponents(url: Constant.URL.longTokenURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "ig_exchange_token"),
            URLQueryItem(name: "client_secret", value: appClientSecret),
            URLQueryItem(name: "access_token", value: shortToken)
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = Method.get.rawValue

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            do {
                guard let data = data else {
                    completion(.failure(Instagram.Error.noToken))
                    return
                }

                let holder = try JSONDecoder().decode(LongTokenHolder.self, from: data)
                completion(.success(holder.token))
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
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
