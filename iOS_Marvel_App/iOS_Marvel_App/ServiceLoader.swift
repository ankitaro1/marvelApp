//
//  ServiceLoader.swift
//  iOS_MediaPlayer_App
//
//  Created by Ankit Sharma on 20/10/23.
//

import Foundation

protocol ServiceProvider {
    func handleGetNetworkCall<T: Decodable>(responseModel: T.Type,
                                            requestURL: URLRequest,
                                            successCallBack: @escaping (T)-> Void,
                                            errorCallBack: @escaping (Error) -> Void)
}

class ServiceDataSource: ServiceProvider {
    
    func handleGetNetworkCall<T>(responseModel: T.Type,
                                 requestURL: URLRequest,
                                 successCallBack: @escaping (T) -> Void,
                                 errorCallBack: @escaping (Error) -> Void) where T : Decodable {
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let data = data,
               let response  = response as? HTTPURLResponse,
               error == nil, response.statusCode == 200 {
                let jsonDecoder = JSONDecoder()
                do {
                    let response = try jsonDecoder.decode(responseModel, from: data)
                    successCallBack(response)
                } catch (let error) {
                   errorCallBack(error)
                }
            } else {
                if let error = error {
                    errorCallBack(error)
                }
            }
        }.resume()
    }
    
    
}
