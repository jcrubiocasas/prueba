//
//  APIClient.swift
//  KCDragonBall
//
//  Created by Adrián Silva on 23/9/24.
//

import Foundation



protocol APIClientProtocol {
    func jwt(
        _ request: URLRequest,
        completion: @escaping (Result<String, NetworkError>) -> Void
    )
    func request<T: Codable>(
        _ request: URLRequest,
        using: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

struct APIClient: APIClientProtocol {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(
        _ request: URLRequest,
        using: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            let result: Result<T, NetworkError>
            
            defer {
                completion(result)
            }
            
            guard error == nil else {
                result = .failure(.unknown)
                return
            }
            
            guard let data else {
                result = .failure(.noData)
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            guard statusCode == 200 else {
                result = .failure(.statusCode(code: statusCode))
                return
            }
            
            guard let model = try? JSONDecoder().decode(using, from: data) else {
                result = .failure(.decodingFailed)
                return
            }
            
            result = .success(model)
        }
        
        task.resume()
    }
    
    func jwt(
        _ request: URLRequest,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            let result: Result<String, NetworkError>
            
            defer {
                completion(result)
            }
            
            guard error == nil else {
                result = .failure(.unknown)
                return
            }
            
            guard let data else {
                result = .failure(.noData)
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            guard statusCode == 200 else {
                result = .failure(.statusCode(code: statusCode))
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                result = .failure(.decodingFailed)
                return
            }
            
            result = .success(token)
        }
        
        task.resume()
    }
}
