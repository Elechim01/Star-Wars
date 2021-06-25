//
//  VeicoloOffline.swift
//  Star Wars
//
//  Created by Michele Manniello on 26/06/21.
//

import Foundation
import CoreData
@objc(VeicoloO)
public class VeicoloO : NSManagedObject{
    
}
extension VeicoloO{
    @nonobjc public class  func fetchRequest() -> NSFetchRequest<VeicoloO>{
        return NSFetchRequest<VeicoloO>(entityName: "VeicoloO")
    }
    @NSManaged public  var url: String?
    @NSManaged public  var nome : String?
    @NSManaged public  var modello : String?
    @NSManaged public  var produttore : String?
    @NSManaged public  var costo : String?
    @NSManaged public  var lunghezza : Double
    @NSManaged public  var maxVelo : Double
    @NSManaged public  var equipaggio : Double
    @NSManaged public  var passeggeri : Double
    @NSManaged public  var capacita : Double
    @NSManaged public  var matCons : String?
    @NSManaged public  var classeVeicolo : String?
}
extension VeicoloO: Identifiable{
    
}
