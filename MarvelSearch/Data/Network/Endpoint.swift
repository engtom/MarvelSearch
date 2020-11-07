//
//  Endpoint.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 02/11/20.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
}

protocol Requestable {
    associatedtype Response
    
    var method: HttpMethod { get set }
    var path: String { get set }
    var queryParameters: [String: String] { get set }
    
    func urlRequest() throws -> URLRequest
}

struct Endpoint<R: Decodable>: Requestable {
    
    typealias Response = R
    
    var method: HttpMethod = .get
    var path: String
    var queryParameters: [String: String] = [:]
    
    func urlRequest() throws -> URLRequest {
        
        let fullPath = AppConfig().baseUrl.appending(path)
        
        guard var urlComponents = URLComponents(string: fullPath) else { throw NetworkDataError.urlGeneration }
        var urlQueryIems = [URLQueryItem]()
        
        queryParameters.forEach {
            urlQueryIems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        urlComponents.queryItems = !urlQueryIems.isEmpty ? urlQueryIems : nil
        guard let url = urlComponents.url else { throw NetworkDataError.urlGeneration }
        
        return URLRequest(url: url)
        
    }
}
