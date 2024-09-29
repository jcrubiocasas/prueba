//
//  NetworkModel.swift
//  KCDragonBall
//
//  Created by Adrián Silva on 23/9/24.
//

import Foundation

final class NetworkModel {
    static let shared = NetworkModel()
    
    //https://dragonball.keepcoding.education
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dragonball.keepcoding.education"
        return components
    }
    
    var token: String?
    private var heroes: [Hero] = []
    private var transformations: [Transformation] = []
    private let client: APIClientProtocol
    
    // Instancia de AudioPlayer como propiedad de la clase
    private let audioPlayer = AudioPlayer()
    
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    // Método para iniciar la reproduccion de música
    func playMusic() {
        audioPlayer.playMusic()
    }
    // Método para detener la reproduccion de música
    func stopMusic() {
        audioPlayer.stopMusic()
    }
    
    func login(
        user: String,
        password: String,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        //https://dragonball.keepcoding.education
        var components = baseComponents
        components.path = "/api/auth/login"
        
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        // Este string se creara con el siguiente formato:
        // (user):(password)
        // adri4silva@gmail.com:abcdef
        let loginString = String(format: "%@:%@", user, password)
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.noData))
            return
        }
        // Encryptamos los datos que acabamos de crear
        // Utilizamos un algoritmo de encriptacion para no pasarle
        // el usuario y la contraseña en texto plano.
        let base64LoginString = loginData.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        client.jwt(request) { [weak self] result in
            switch result {
                case let .success(token):
                    self?.token = token
                case .failure:
                    break
            }
            completion(result)
        }
    }
    
    func getHeroes(
        completion: @escaping (Result<[Hero], NetworkError>) -> Void
    ) {
        //https://dragonball.keepcoding.education
        var components = baseComponents
        components.path = "/api/heros/all"
        
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        guard let serializedBody = try? JSONSerialization.data(withJSONObject: ["name": ""]) else {
            completion(.failure(.unknown))
            return
        }
        
        guard let token else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = serializedBody
        
        client.request(request, using: [Hero].self, completion: completion)
    }
    
    func getTransformations(
        for hero: Hero,
        completion: @escaping (Result<[Transformation], NetworkError>) -> Void
    ) {
        var components = baseComponents
        components.path = "/api/heros/tranformations"
        
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        guard let serializedBody = try? JSONSerialization.data(withJSONObject: ["id": hero.id]) else {
            completion(.failure(.unknown))
            return
        }
        
        guard let token else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = serializedBody
        
        client.request(request, using: [Transformation].self, completion: completion)
    }
}
