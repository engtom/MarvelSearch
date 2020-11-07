//
//  NetworkService.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 02/11/20.
//

import Foundation

enum NetworkDataError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
    case parsing(Error)
    case noResponse
}

protocol NetworkService {
    typealias CompletionHandler<T> = (Result<T, NetworkDataError>) -> Void
    
    func request<T: Decodable, E: Requestable>(endpoint: E, completion: @escaping CompletionHandler<T>) -> URLSessionTask? where E.Response == T
}

final class DefaultNetworkService: NetworkService {
    
    func request<T: Decodable, E: Requestable>(endpoint: E, completion: @escaping CompletionHandler<T>) -> URLSessionTask?  where E.Response == T {
        
        do {
            let urlRequest = try endpoint.urlRequest()
            
            let sesstionTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, requestError) in
                
                if let requestError = requestError {
                    var error: NetworkDataError
                    
                    if let response = response as? HTTPURLResponse {
                        error = .error(statusCode: response.statusCode, data: data)
                    }else{
                        error = self.resolve(error: requestError)
                    }
                    
                    completion(.failure(error))
                    
                }else{
                    
                    let result: Result<T, NetworkDataError> = self.decode(data: data)
                    
                    completion(result)
                }
                
            }
            
            return sesstionTask
        }catch{
            completion(.failure(.urlGeneration))
        }
        
        
        return nil
    }
    
    private func resolve(error: Error) -> NetworkDataError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
    
    private func decode<T: Decodable>(data: Data?) -> Result<T, NetworkDataError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let decoder = JSONDecoder()
            let result: T = try decoder.decode(T.self, from: data)
            return .success(result)
        }catch {
            return .failure(.parsing(error))
        }
    }
}
