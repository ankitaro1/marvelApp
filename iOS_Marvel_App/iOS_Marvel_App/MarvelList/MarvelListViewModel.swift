//
//  MarvelListViewModel.swift
//  iOS_Marvel_App
//
//  Created by Ankit Sharma on 28/10/23.
//

import Foundation

protocol MarvelListDiplayLogic: AnyObject {
    var viewModel: MediaListViewModelProtocol? { get }
    func refreshUI()
    func showError(error: ErrorModel)
}

class MarvelListViewModel: MediaListViewModelProtocol {
    
    var baseUrl: URL
    var marvelCharacterList: [MarvelCharacterUIModel] = []
    var serviceProvider: ServiceProvider?
    var textFieldActionCompletion: ((String) -> Void)?
    weak var view: MarvelListDiplayLogic?
    private var queryParams: [String: String]?
    var workItem: DispatchWorkItem?
    let databaseHelper = DataBaseHelper()
    
    init(baseUrl: URL, serviceProvider: ServiceProvider? = nil) {
        self.baseUrl = baseUrl
        self.serviceProvider = serviceProvider
        marvelCharacterList = fetchFromDataBase()
    }
    
    func observeSearchBarTypingEvent() {
        // Search Bar typing event
        textFieldActionCompletion = { [weak self] value in
            guard let self = self else { return }
            self.workItem?.cancel()
            if value.isEmpty {
                queryParams?.removeValue(forKey: "nameStartsWith")
            } else {
                if queryParams != nil {
                    self.queryParams?["nameStartsWith"] = value
                } else {
                    self.queryParams = ["nameStartsWith": value]
                }
            }
            let searchWorkItem = DispatchWorkItem {
                self.fetchMediaList()
            }
            self.workItem = searchWorkItem
            if let workItem = self.workItem {
                let backgroundQueue = DispatchQueue(label: "com.searchItem.queue", qos: .background)
                backgroundQueue.asyncAfter(deadline: .now() + .milliseconds(1000), execute: workItem)
            }
        }
    }
    
    func fetchMediaList() {
        let queryItems = {
            var items: [URLQueryItem] = []
            for (key,value) in self.queryParams ?? [:] {
                items.append(URLQueryItem(name: key, value: value))
            }
            return items
        }
        var url = baseUrl
        url.append(queryItems: queryItems())
        let request = URLRequest(url: url)
        serviceProvider?.handleGetNetworkCall(responseModel: MediaListResponseModel.self,
                                              requestURL: request,
                                              successCallBack: { response in
            guard let results = response.data?.results else {
                self.view?.showError(error: ErrorModel(errorMessage: "No Character Found"))
                return
            }
            self.databaseHelper.deleteAll()
            self.handleMarvelListResponse(response: results)
            self.marvelCharacterList = self.fetchFromDataBase()
            self.view?.refreshUI()
            print("REsponse received")
            print(results.count)
        },
                                              errorCallBack: { error in
            print(error.localizedDescription)
            self.view?.showError(error: ErrorModel(errorMessage: error.localizedDescription))
        })
    }
    
    private func handleMarvelListResponse(response: [MediaListCharacterResponseModel]) {
        var characterList: [MarvelCharacterUIModel] = []
        for item in response {
            var url: URL?
            let thumbnail = item.thumbnail
            if let path = thumbnail?.path,
               let extenstion = thumbnail?.extensionType, !path.isEmpty, !extenstion.isEmpty  {
                url = URL(string: path + "." + extenstion)
            }
            var comics: [ComicsUIModel] = []
            for comic in item.comics?.items ?? [] {
                comics.append(ComicsUIModel(name: comic.name ?? String.empty))
            }
            let character = MarvelCharacterUIModel(name: item.name ?? String.empty,
                                               description: item.description ?? nil,
                                               thumbnail: url,
                                               comics: comics)
            characterList.append(character)
        }
        databaseHelper.save(marvelCharacters: characterList)
    }
    
    func fetchFromDataBase() -> [MarvelCharacterUIModel] {
       let characters = databaseHelper.getMarvelCharacterList()
       var characterList: [MarvelCharacterUIModel] = []
        for item in characters {
            var comics: [ComicsUIModel] = []
//            for comic in item.comics ?? [] {
//                let comicItem = comic as? ComicMarvel
//                comics.append(ComicsUIModel(name: comicItem?.name ?? String.empty))
//            }
            let character = MarvelCharacterUIModel(name: item.name ?? String.empty,
                                                   description: item.descriptionValue ,
                                                   thumbnail: item.thumbnail,
                                               comics: [])
            characterList.append(character)
        }
        return characterList
    }
}

struct MarvelCharacterUIModel {
    let name: String
    let description: String?
    let thumbnail: URL?
    let comics: [ComicsUIModel]
}

struct ComicsUIModel {
    let name: String
}

struct ErrorModel {
    let errorMessage: String
}
