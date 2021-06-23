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
    @Published var film : [Film] = []
    @Published var veicoli : [Veicoli] = []
    
    
    func RecuperoValori(){
        //        Dowload the JSON data
        var indice = 1
        var urlImaggine = ""
        var elencoveicoli : [String] = []
        var elencoFilm : [String] = []
//        variabili
        var nome : String = ""
        var altezza : Int = 0
        var coloreCapelli : String = ""
        var peso = 0
        var colorePelle = ""
        var coloreOcchi = ""
        var sesso = ""
        self.persone = []
        AF.request("https://swapi.dev/api/people").responseData { data in
//            let url = URL(string: "https://swapi.dev/api/people")!
//              if let data = try? Data(contentsOf: url) {
            let json = try! JSON(data: data.data!)
//            let arrayNames = json["results"].arrayValue.map{($0["name"].stringValue)}
            let arrayNames = json["results"].arrayValue
            print(arrayNames)
            for i in arrayNames{
//                print(i)
//                recupero valori
                 nome = i["name"].string!
                 altezza = Int(i["height"].string!)!
                 peso = Int(i["mass"].string!)!
                 coloreCapelli = i["hair_color"].string!
                 colorePelle = i["skin_color"].string!
                 coloreOcchi = i["eye_color"].string!
                 sesso = i["gender"].string!
//                let dataformatter = DateFormatter()
//                let createdDate = dataformatter.date(fromSwapiString: i["birth_year"].string!)
                let dataDinascita = i["birth_year"].string!
//                ottengo gli url per i veicoli
                let macchine = i["vehicles"].array!
                elencoveicoli = []
                for elementi  in macchine {
//                    veicoli.append(self.getVeicoli(indirizzo: elementi.string!))
                    elencoveicoli.append(elementi.string!)
                }
                let films = i["films"].array!
                elencoFilm = []
                for film in films {
                    //                ottengo i film
//                    elencoFilm.append(self.getFilm(indirizzo: film.string!))
                    elencoFilm.append(film.string!)
                }
                print(nome,altezza,peso,coloreCapelli,colorePelle,coloreOcchi, sesso)
                print("data",dataDinascita)
                print(elencoveicoli)
                print(elencoFilm)
                urlImaggine = "https://mobile.aws.skylabs.it/mobileassignments/swapi/" + String(indice)+".png"
                self.persone.append(Persona(name: nome, immagine: urlImaggine, altezza: altezza, peso: peso, coloreCapelli: coloreCapelli, colorePelle: colorePelle, coloreOcchi: coloreOcchi, annoNascita: dataDinascita, sesso: sesso, film: elencoFilm, veicoli: elencoveicoli))
                indice += 1
            }
            print(self.persone)
            
        }

        
        }
    //        funzione che restituisce i veicoli

    func getVeicoli(indirizzo: String) -> Veicoli {
        let url = URL(string: indirizzo)!
        if let datav = try? Data(contentsOf: url) {
                   // we're OK to parse!
            let json = try! JSON(data: datav)
            print(json)
            let nome = json["name"].string!
            let modello = json["model"].string!
            let produttore = json["manufacturer"].string!
            let costo = json["cost_in_credits"].string!
            let lunghezza = Double(json["length"].string!)!
            let velocità = Int(json["max_atmosphering_speed"].string!)!
            let equipaggio = Int(json["crew"].string!)!
            let passegeri = Int(json["passengers"].string!)!
            let capacità = Double(json["cargo_capacity"].string!)!
            let consumo = json["consumables"].string!
            let tipo = json["vehicle_class"].string!
            return Veicoli(nome: nome, modello: modello, produttore: produttore, costo: costo, lunghezza: lunghezza, massimaVelocità: velocità, equipaggio: equipaggio, passeggeri: passegeri, capacità: capacità, materialiConsumo: consumo, classeVeicolo: tipo)
        }
        
        return Veicoli(nome: "", modello: "", produttore: "", costo: "", lunghezza: 0, massimaVelocità: 0, equipaggio: 0, passeggeri: 0, capacità: 0.0, materialiConsumo: "", classeVeicolo: "")
    }
//    funzione che ottiene i film
    func getFilm(indirizzo : String) -> Film {
        let url = URL(string: indirizzo)!
        if let dataf = try? Data(contentsOf: url){
            let json = try! JSON(data: dataf)
            print(json)
            let titolo = json["title"].string!
            let anno = json["release_date"].string!
            let messaggio = json["opening_crawl"].string!
            return Film(titolo: titolo, anno: anno, messaggioApertura: messaggio)
            
        }
        return Film(titolo: "", anno: "", messaggioApertura: "")
    }
    
//    qundo seleziono il personaggio scarico i valori di esso
    func GetOther(persona : Persona) {
//        pulire i filme e i veicoli
        self.film = []
        self.veicoli = []
//        leggo i veicoli:
        for f in persona.film{
            self.film.append(getFilm(indirizzo: f))
        }
        for v in persona.veicoli {
            self.veicoli.append(getVeicoli(indirizzo: v))
        }
        print(film)
        print(veicoli)
    }
}


struct Persona: Identifiable {
    var id = UUID().uuidString
    var name : String
    var immagine : String
    var altezza : Int
    var peso : Int
    var coloreCapelli : String
    var colorePelle : String
    var coloreOcchi: String
    var annoNascita : String
    var sesso : String
    var film : [String]
    var veicoli : [String]
}
struct Film: Identifiable {
    var id = UUID().uuidString
//    titolo del film, anno del film, messaggio di apertura
    var titolo: String
    var anno : String
    var messaggioApertura : String
    
}
struct Veicoli: Identifiable {
    var id = UUID().uuidString
//    nome, modello, produttore, costo, lunghezza,
    var nome : String
    var modello : String
    var produttore : String
    var costo : String
    var lunghezza : Double
    var massimaVelocità : Int
    var equipaggio : Int
    var passeggeri : Int
    var capacità : Double
    var materialiConsumo : String
    var classeVeicolo : String
}
//extension DateFormatter {
//  func date(fromSwapiString dateString: String) -> Date? {
//    // SWAPI dates look like: "2014-12-10T16:44:31.486000Z"
//    self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
//    self.timeZone = TimeZone(abbreviation: "UTC")
//    self.locale = Locale(identifier: "en_US_POSIX")
//    return self.date(from: dateString)
//  }
//}
