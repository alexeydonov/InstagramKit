//
//  File.swift
//  
//
//  Created by Alexey Donov on 15.03.2020.
//

import Foundation

extension Instagram.Engine {

    func emptyResponseHandler(for completion: @escaping (Result<Void, Error>) -> Void) -> ((Result<Instagram.EmptyResponse, Error>) -> Void) {
        return {
            switch $0 {
            case .success: completion(.success(()))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    func stringForScope(_ scope: Instagram.Scope) -> String {
        let typeStrings = ["basic", "comments", "relationships", "likes", "public_content", "follower_list"];

        var strings = [String]()
        typeStrings.enumerated().forEach { (idx, obj) in
            let enumBitValueToCheck = 1 << idx
            if scope.rawValue & enumBitValueToCheck != 0 {
                strings.append(obj)
            }
        }

        return strings.joined(separator: " ")
    }

    func authorizationParametersWithScope(_ scope: Instagram.Scope) -> [String : String] {
        let scopeString = stringForScope(scope)

        return [
            "client_id" : appClientID!,
            "redirect_url" : appRedirectURL!.absoluteString,
            "response_type" : "token",
            "scope" : scopeString
        ]
    }

    func validAccessTokenFromURL(_ url: URL, appRedirectURL: URL) throws -> Bool {
        let identicalURLSchemes = appRedirectURL.scheme == url.scheme
        let identicalURLHosts = appRedirectURL.host == url.host

        // For app:// base URL, the host is nil.
        let isAppURL = appRedirectURL.host == nil
        if !identicalURLSchemes || (!isAppURL && !identicalURLHosts) {
            return false
        }

        let formattedURL = url.fragment ?? url.query ?? ""

        let token = queryStringParametersFromString(formattedURL)["access_token"]
        let success = (token?.count ?? 0) > 0
        if success {
            accessToken = token
        }
        else {
            throw Instagram.Error.authenticationFailed
        }

        return success;
    }

    func queryStringParametersFromString(_ string: String) -> [String : String] {
        var result: [String : String] = [:]

        string.components(separatedBy: "&").forEach {
            let pairs = $0.components(separatedBy: "=")
            guard pairs.count == 2 else { return }

            var key = pairs[0].removingPercentEncoding!
            if key.hasPrefix("#") {
                key = key.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
            }

            let value = pairs[1].removingPercentEncoding!

            result[key] = value
        }

        return result
    }

    func dictionaryWithAccessTokenAndParameters(_ params: [String : String]) -> [String : String] {
        var result = params

        if let token = accessToken {
            result["access_token"] = token
        }
        else if let clientId = appClientID {
            result[""] = clientId
        }

        return result
    }

    func parametersFromCount(_ count: Int?, maxId: String?, andPaginationKey key: String) -> [String : String] {
        var result: [String : String] = [:]
        if let count = count {
            result["count"] = String(count)
        }
        if let maxId = maxId {
            result[key] = maxId
        }

        return result
    }

    fileprivate struct Container<Entity>: Decodable where Entity: Decodable {
        var data: Entity
    }

    enum Method: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }

    fileprivate func createRequest(to endpoint: URL, method: Method, parameters: [String : String]? = nil) throws -> URLRequest {
        let params = dictionaryWithAccessTokenAndParameters(parameters ?? [:])

        var request: URLRequest
        if method == .get {
            var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: false)!
            components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
            request = URLRequest(url: components.url!)
        }
        else {
            request = URLRequest(url: endpoint)
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        }
        request.httpMethod = method.rawValue

        return request
    }

    func sendRequest<T: Decodable>(to endpoint: URL, method: Method, parameters: [String : String]? = nil, expecting model: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let request = try createRequest(to: endpoint, method: method, parameters: parameters)

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                do {
                    if let data = data {
                        let container = try JSONDecoder().decode(Container<T>.self, from: data)
                        completion(.success(container.data))
                    }
                }
                catch {
                    completion(.failure(error))
                }
            }.resume()
        }
        catch {
            completion(.failure(error))
        }
    }

}