//
//  FilmOffline.swift
//  Star Wars
//
//  Created by Michele Manniello on 26/06/21.
//

import Foundation
import CoreData

@objc(FilmO)
public class FilmO : NSManagedObject{
    
}
extension FilmO{
    @nonobjc public class  func fetchRequest() -> NSFetchRequest<FilmO> {
        return NSFetchRequest<FilmO>(entityName: "FilmO")
    }
    @NSManaged public var url: String?
    @NSManaged public var titolo: String?
    @NSManaged public var anno : String?
    @NSManaged public var messaggioAp : String?
}
extension FilmO: Identifiable{
    
}
