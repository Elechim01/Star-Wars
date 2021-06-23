//
//  Model.swift
//  Star Wars
//
//  Created by Michele Manniello on 22/06/21.
//

import Foundation
import SwiftUI
import Alamofire
import SwiftyJSON
class Gestione: ObservableObject{
    @Published var persone : [Persona] = []
    func RecuperoValori(){
        //        Dowload the JSON data
        var indice = 1
        var urlImaggine = ""
        self.persone = []
        AF.request("https://swapi.dev/api/people").responseData { data in
            let json = try! JSON(data: data.data!)
            let arrayNames = json["results"].arrayValue.map{($0["name"].stringValue)}
            for i in arrayNames{
                urlImaggine = "https://mobile.aws.skylabs.it/mobileassignments/swapi/" + String(indice)+".png"
                self.persone.append(Persona(name: i, immagine: urlImaggine))
                indice += 1
            }
            print(self.persone)
            
        }
        
        
        //        if let url = URL(string: "https://swapi.dev/api/people"){
        //            URLSession.shared.dataTask(with: url){ data, response, error in
        //                if let data = data{
        //                 let jsonDecoder = JSONDecoder()
        //                    do {
        //                        let parsedJson = try jsonDecoder.decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: <#T##Data#>)
        //                    } catch <#pattern#> {
        //                        <#statements#>
        //                    }
        //                }
        //            }.resume()
    }
}
struct Persona: Identifiable {
    var id = UUID().uuidString
    var name : String
    var immagine : String
}
