//
//  Utilities.swift
//  iOS_Marvel_App
//
//  Created by Ankit Sharma on 28/10/23.
//

import Foundation
import CryptoKit
import UIKit

extension String {
    static let empty = ""

var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImageFromUrl(url: URL)  {
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage{
            self.image = imageFromCache
            return
        } else {
            self.image = nil
            URLSession.shared.dataTask(with: URLRequest(url: url)) { data,response,error in
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200,
                   let data = data {
                    DispatchQueue.main.async {
                        if let imageToCache = UIImage(data: data) {
                            imageCache.setObject(imageToCache, forKey: url as AnyObject)
                            self.image = imageToCache
                        }
                    }
                }
            }.resume()
        }
    }

}
