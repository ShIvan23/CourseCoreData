//
//  APIManager.swift
//  Course2FinalTask
//
//  Created by Ivan on 03.12.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = (Data?, HTTPURLResponse?, Error?) -> Void

enum APIResult<T> {
    case success(T)
    case failure(ErrorManager)
}

protocol APIManager {
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    func fetch<T: Codable>(request: URLRequest, completionHandler: @escaping (APIResult<T>) -> Void)
}

extension APIManager {
    
    private var keychain: KeychainProtocol {
        return KeychainManager()
    }
    
    private var appDelegate: AppDelegate {
        return AppDelegate.shared
    }
    
    private func JSONTask(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            let error: ErrorManager
            guard let HTTPResponse = response as? HTTPURLResponse else {

                TabBarController.offlineMode = true
                error = .offlineMode
                completionHandler(nil, nil, error)
                return
            }
            
            switch HTTPResponse.statusCode {
            case 200:
                print("response = \(HTTPResponse.statusCode)")
                completionHandler(data, HTTPResponse, nil)
                
            case 401:
                error = .unauthorized
                keychain.deleteToken(userName: "user")
                DispatchQueue.main.async {
                    appDelegate.window?.rootViewController = AutorizationViewController()
                }
                completionHandler(nil, HTTPResponse, error)

            default:
                TabBarController.offlineMode = true
                error = .offlineMode
                completionHandler(nil, HTTPResponse, error)
            }
        }
        return dataTask
    }
    
    func fetch<T: Codable>(request: URLRequest, completionHandler: @escaping (APIResult<T>) -> Void) {
        
        let dataTask = JSONTask(request: request) { (data, _, error) in
            
            DispatchQueue.main.async {
                guard let data = data else {
                    if let error = error {
                        completionHandler(.failure(error as! ErrorManager))
                    }
                    
                    return
                }
                
                if data.isEmpty {
//                    Для logout, так как там нет JSON
                    let error = NSError()
                    completionHandler(.failure(error as! ErrorManager))
                }
                
                if let value = decodeJSON(type: T.self, from: data) {
                    completionHandler(.success(value))
                } else {
                    let error = NSError()
                    completionHandler(.failure(error as! ErrorManager))
                }
            }
        }
        dataTask.resume()
    }
    
    private func decodeJSON<T: Codable>(type: T.Type, from: Data?) -> T? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError.localizedDescription)
            return nil
        }
    }
}
