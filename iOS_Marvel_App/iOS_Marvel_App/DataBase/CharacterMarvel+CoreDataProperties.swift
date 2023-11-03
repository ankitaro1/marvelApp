//
//  CharacterMarvel+CoreDataProperties.swift
//  iOS_Marvel_App
//
//  Created by Ankit Sharma on 02/11/23.
//
//

import Foundation
import CoreData


extension CharacterMarvel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterMarvel> {
        return NSFetchRequest<CharacterMarvel>(entityName: "CharacterMarvel")
    }

    @NSManaged public var descriptionValue: String?
    @NSManaged public var name: String?
    @NSManaged public var thumbnail: URL?

}

extension CharacterMarvel : Identifiable {

}
