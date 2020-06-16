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

    func stringForScopes(_ scopes: Set<Instagram.Scope>) -> String {
        return scopes.map { $0.rawValue }.joined(separator: ",")
    }

    func authorizationParametersWithScopes(_ scopes: Set<Instagram.Scope>) -> [String : String] {
        let scopeString = stringForScopes(scopes)

        return [
            "client_id" : appClientID!,
            "redirect_uri" : appRedirectURL!.absoluteString,
            "response_type" : "code",
            "scope" : scopeString
        ]
    }

    func codeFromURL(_ url: URL, appRedirectURL: URL) -> String? {
        guard appRedirectURL.scheme == url.scheme, appRedirectURL.host == url.host,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems,
            let codeItem = queryItems.first(where: { $0.name == "code" }) else {
            return nil
        }

        return codeItem.value
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
                        let entity = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(entity))
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
