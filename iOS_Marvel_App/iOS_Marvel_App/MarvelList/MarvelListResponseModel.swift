//
//  MarvelListResponseModel.swift
//  iOS_Marvel_App
//
//  Created by Ankit Sharma on 28/10/23.
//

import Foundation

struct MediaListResponseModel: Decodable {
    let data: MediaListDataResponseModel?
}

struct MediaListDataResponseModel: Decodable {
    let results: [MediaListCharacterResponseModel]?
}

struct MediaListCharacterResponseModel: Decodable {
    let id: Int?
    let name, description: String?
    let thumbnail: MediaListThumbnailResponseModel?
    let comics: MediaListComicsResponseModel?
}

struct MediaListThumbnailResponseModel: Decodable {
    let path, extensionType: String?
    
    enum CodingKeys: String, CodingKey {
        case extensionType = "extension"
        case path
    }
}

struct MediaListComicsResponseModel: Decodable {
    let items: [MediaListComicSummaryResponseModel]
}

struct MediaListComicSummaryResponseModel: Decodable {
    let name, resourceURI: String?
}
