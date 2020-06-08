//
//  API.swift
//  
//
//  Created by Connor Ricks on 6/4/20.
//

import Foundation

// MARK: - API

protocol API {
    associatedtype ServerErrorType: Decodable
    static var headers: [String: String]? { get }
    static func clientError(from serverError: ServerErrorType) -> Error
}

// MARK: - Generic Request & Decode

extension API {
    typealias RequestCompletion<T: Decodable> = (Result<T, Error>) -> Void
    
    static func fetch<T: Decodable>(url: URL,
                               responseType: T.Type,
                               additionalHeaders: [String: String]? = nil,
                               completion: @escaping RequestCompletion<T>) {
        performRequest(url: url,
                       body: nil,
                       responseType: responseType,
                       additionalHeaders: additionalHeaders,
                       completion: completion)
    }
    
    /// Internal request implementation
    private static func performRequest<T: Decodable>(url: URL,
                                              body: Data?,
                                              responseType: T.Type,
                                              additionalHeaders: [String: String]? = nil,
                                              completion: @escaping RequestCompletion<T>) {
        var request = URLRequest(url: url)
        
        // Headers
        var requestHeaders = headers ?? [:]
        if let additionalHeaders = additionalHeaders {
            requestHeaders.merge(additionalHeaders, uniquingKeysWith: { $1 })
        }
        request.allHTTPHeaderFields = requestHeaders
        
        // Body
        if let body = body {
            request.httpBody = body
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error  in
            if let error = error {
                completion(.failure(Error(message: error.localizedDescription)))
            }
            
            guard let data = data else {
                completion(.failure(Error.noData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(Error.noResponse))
                return
            }
            
            if response.statusCode < 200 || response.statusCode > 399 {
                switch self.decode(ServerErrorType.self, from: data) {
                case .success(let error):
                    completion(.failure(self.clientError(from: error)))
                case .failure:
                    let codeDescription = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                    completion(.failure(Error(message: "\(response.statusCode) - \(codeDescription)")))
                }
            } else {
                switch self.decode(responseType, from: data) {
                case .success(let object):
                    completion(.success(object))
                case .failure(let decodingError):
                    completion(.failure(Error(message: decodingError.localizedDescription)))
                }
            }
        }
        task.resume()
    }
    
    private static func decode<T: Decodable>(_ type: T.Type, from data:  Data) -> Result<T, Error> {
        do  {
            let object = try JSONDecoder().decode(type.self, from: data)
            return .success(object)
        } catch {
            return .failure(Error(message: error.localizedDescription))
        }
    }
}
