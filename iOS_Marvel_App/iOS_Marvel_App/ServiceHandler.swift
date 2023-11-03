//
//  ServiceHandler.swift
//  iOS_Marvel_App
//
//  Created by Ankit Sharma on 31/10/23.
//

import Foundation

class ServiceHandler {
    
    private let baseURL = "https://gateway.marvel.com/"
    
    func getCharactersAPIURL() -> URL {
        var url = URL(string: baseURL + "v1/public/characters")!
        addServerRequiredParams(url: &url)
        return url
    }
    
    private func addServerRequiredParams(url: inout URL) {
        let ts = Date().timeIntervalSince1970
        let apiKeyItem = URLQueryItem(name: "apikey", value: "bdac5166b97d51aeb5b2709664ec32c8")
        let tsItem = URLQueryItem(name: "ts", value: "\(ts)")
        // hashValue = timeStamp + privateKey + publicKey
        let hashValue = "\(ts)" + "1bcd3ffa8d003b1b2dcabc7272d1dd58a387e3b8" + "bdac5166b97d51aeb5b2709664ec32c8"
        let hashItem = URLQueryItem(name: "hash", value: hashValue.MD5)
        url.append(queryItems: [apiKeyItem, tsItem, hashItem])
    }
}
