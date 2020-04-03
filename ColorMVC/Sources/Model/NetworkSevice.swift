//
//  NetworkSevice.swift
//  ColorMVVM
//
//  Created by Seokho on 2020/03/31.
//

import Foundation

class NetworkService {
    func fetchColors( completion: @escaping (Result<[Color],ApiProviderError>) -> Void )  {
        ApiProvider.request(.colors) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum ApiProviderError: Error {
    case parseError
    case unknownError
}

// MARK: - API Provider
fileprivate struct ApiProvider {
    static func request(_ type: ApiType, completion: @escaping (Result<[Color],ApiProviderError>) -> Void ) {
    
            let session: URLSession = URLSession(configuration: .default)
            session.dataTask(with: ApiURL.url(type)) { (data: Data?, response: URLResponse?, error: Error?)  in
                
                if let _ = error {
                    completion(.failure(ApiProviderError.unknownError))
                }
                
                guard let jsonData = data else {
                    completion(.failure(ApiProviderError.unknownError))
                    return
                }
                
                guard let model = JSONDecoder.decodeOptional(jsonData,type: [Color].self) else {
                    completion(.failure(ApiProviderError.parseError))
                    return
                }
                
                completion(.success(model))
            }.resume()
            
            
        
    }
}
