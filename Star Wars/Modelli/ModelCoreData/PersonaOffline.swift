//
//  PersonaOffline.swift
//  Star Wars
//
//  Created by Michele Manniello on 25/06/21.
//

import Foundation
import CoreData

@objc(PersonaO)
public class PersonaO: NSManagedObject{

}
extension PersonaO{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonaO> {
          return NSFetchRequest<PersonaO>(entityName: "PersonaO")
      }
    @NSManaged public  var nome : String?
    @NSManaged public  var immagine : String?
    @NSManaged public  var altezza : Double
    @NSManaged public  var peso : Double
    @NSManaged public var coloreCapelli : String?
    @NSManaged public var colorePelle : String?
    @NSManaged public  var coloreOcchi: String?
    @NSManaged public  var nascita : String?
    @NSManaged public  var sesso : String?
    @NSManaged public  var films : [String]?
    @NSManaged public  var veicoli : [String]?
}
extension PersonaO : Identifiable{
    
}
