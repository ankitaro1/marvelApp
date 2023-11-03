//
//  DataBaseHelper.swift
//  iOS_Marvel_App
//
//  Created by Ankit Sharma on 01/11/23.
//

import Foundation
import UIKit
import CoreData

protocol DataBaseProtocol {
    
}

class DataBaseHelper: DataBaseProtocol {
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func save(marvelCharacters: [MarvelCharacterUIModel]) {
        for marvelCharacter in marvelCharacters {
            let character = NSEntityDescription.insertNewObject(forEntityName: "CharacterMarvel", into: context!) as! CharacterMarvel
            character.name = marvelCharacter.name
            character.descriptionValue = marvelCharacter.description
            character.thumbnail = marvelCharacter.thumbnail
//            var comics: [ComicMarvel] = []
//            for item in marvelCharacter.comics {
//                let comic = NSEntityDescription.insertNewObject(forEntityName: "ComicMarvel", into: context!) as! ComicMarvel
//                comic.name = item.name
//                comics.append(comic)
//            }
//            character.comics = NSOrderedSet(array: comics)
        }
        do {
            try context?.save()
            print("Success")
        } catch {
            print("data not saved")
        }
    }
    
    func getMarvelCharacterList() -> [CharacterMarvel] {
        var characters: [CharacterMarvel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CharacterMarvel")
        do {
            characters = try context?.fetch(fetchRequest) as! [CharacterMarvel]
        } catch {
            print("can not fetch data")
        }
        return characters
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CharacterMarvel")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context?.execute(deleteRequest)
            try context?.save()
        } catch {
            print("can not delete")
        }
    }
}
