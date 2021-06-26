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
import CoreData
class Gestione: ObservableObject{
    @Published var persone : [Persona] = []
//
    @Published var film : [Film] = [Film(url: "", titolo: "prova1", anno: "2021-05-21", messaggioApertura: "in una galassia lontana lontana...")]
    @Published var veicoli : [Veicoli] = [Veicoli(url: "" ,nome: "sottomarino", modello: "e", produttore: "e", costo: "ee", lunghezza: 34, massimaVelocità: 345, equipaggio: 2, passeggeri: 2, capacità: 34, materialiConsumo: "werty", classeVeicolo: "ssss")]
//    Alert per connessione
//    @Published var alert
    func RecuperoValori(context: NSManagedObjectContext,pers : FetchedResults<PersonaO>){
        //        Dowload the JSON data
//        var indice = 1
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
        var indirizzo : String? = "https://swapi.dev/api/people"
        var trovaid : String = ""
        
        while indirizzo != nil {
            let url = URL(string: indirizzo!)!
//        AF.request("https://swapi.dev/api/people").responseData { data in
              if let data = try? Data(contentsOf: url) {
//            Gestisco offline
            print(data)
//            if data.data != nil{
                let json = try! JSON(data: data)
                //            let arrayNames = json["results"].arrayValue.map{($0["name"].stringValue)}
//                Carico l'indirizzo :
                indirizzo = json["next"].string
                print(indirizzo)
                let arrayNames = json["results"].arrayValue
                print(arrayNames)
                for i in arrayNames{
                    //                print(i)
                    //                recupero valori
                    nome = i["name"].string!
                    altezza = Int(i["height"].string!) ??  0
                    peso = Int(i["mass"].string!) ?? 0
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
//                    Aggiungo anche le navi spaziali
                    let naveSpaziale = i["starships"].array!
                    for nave in naveSpaziale{
                        elencoveicoli.append(nave.string! + "O")
                    }
                    
                    let films = i["films"].array!
                    elencoFilm = []
                    for film in films {
                        //                ottengo i film
                        //                    elencoFilm.append(self.getFilm(indirizzo: film.string!))
                        elencoFilm.append(film.string!)
                    }
//                    print(nome,altezza,peso,coloreCapelli,colorePelle,coloreOcchi, sesso)
//                    print("data",dataDinascita)
//                    print(elencoveicoli)
//                    print(elencoFilm)
//                    per recuperare l'id il cont non funziona
                    trovaid = i["url"].string!
                    urlImaggine = "https://mobile.aws.skylabs.it/mobileassignments/swapi/" + TrovaId(url: trovaid)+".png"
                    print("🤖",nome, indirizzo)
                    let p = Persona(name: nome, immagine: urlImaggine, altezza: altezza, peso: peso, coloreCapelli: coloreCapelli, colorePelle: colorePelle, coloreOcchi: coloreOcchi, annoNascita: dataDinascita, sesso: sesso, film: elencoFilm, veicoli: elencoveicoli)
                    self.persone.append(p)
//                    Aggiungere il valore nel core data....
                    self.AggiungiPersona(context: context, persona: p, pers: pers)
                    
//                    indice += 1
                }
                print(self.persone)
                
//            }
//            else{
//                leggiamo i valori da coredata.....
                
//            }
        }
        }
//        crah offline
        }
    func TrovaId(url : String) -> String {
        let start = url.index(url.startIndex,offsetBy: 29)
        let end = url.index(url.endIndex,offsetBy: -1)
        let range = start..<end
        let mysubstring = url[range]
        return String(mysubstring)
    }
    
    //        funzione che restituisce i veicoli

    func getVeicoli(str: String) -> Veicoli {
//        se c'è una nave spaziale l'ultima lettera èo
        var navespaziale : Bool = false
        var indirizzo : String = ""
//        controllare se è una nave spaziale :
        let index = str.index(str.endIndex, offsetBy: -1)
        let mySubstring = str.suffix(from: index)
        if mySubstring == "o"{
            navespaziale = true
        }
//        recupero l'indirizzo :
        let cont = str.count
        let start = str.index(str.startIndex,offsetBy: cont-1)
        let mystring  = str[..<start]
        indirizzo = String(mystring)
        
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
            let tipo = navespaziale ?  json["vehicle_class"].string! : json["starship_class"].string!
            
            return Veicoli(url: indirizzo,nome: nome, modello: modello, produttore: produttore, costo: costo, lunghezza: lunghezza, massimaVelocità: velocità, equipaggio: equipaggio, passeggeri: passegeri, capacità: capacità, materialiConsumo: consumo, classeVeicolo: tipo)
        }
        
        return Veicoli(url : "",nome: "", modello: "", produttore: "", costo: "", lunghezza: 0, massimaVelocità: 0, equipaggio: 0, passeggeri: 0, capacità: 0.0, materialiConsumo: "", classeVeicolo: "")
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
            return Film(url: indirizzo,titolo: titolo, anno: anno, messaggioApertura: messaggio)
            
        }
        return Film(url: "",titolo: "", anno: "", messaggioApertura: "")
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
            self.veicoli.append(getVeicoli(str: v))
        }
        print(film)
        print(veicoli)
    }
    
    
//  💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾💾
//    Core data, integrato in maniera che dopo il primo accesso lui legga
    func AggiungiPersona(context: NSManagedObjectContext, persona : Persona,pers : FetchedResults<PersonaO>){
        let newp = PersonaO(context: context)
        //        Controllare che la persona sia presnete nel detabase :
        var vuoto : Bool = true
        for per in pers{
            
            if Persona(name: per.nome ?? "", immagine: per.immagine ?? "", altezza: Int(per.altezza), peso: Int(per.peso), coloreCapelli: per.coloreCapelli ?? "", colorePelle: per.colorePelle ?? "", coloreOcchi: per.coloreOcchi ?? "", annoNascita: per.nascita ?? "", sesso: per.sesso ?? "", film: per.films ?? [], veicoli: per.veicoli ?? []) == persona{
                vuoto = false
            }
        }
        //        carico i valori
        if vuoto == true{
            newp.nome = persona.name
            newp.immagine = persona.immagine
            newp.peso = Double(persona.peso)
            newp.altezza = Double(persona.altezza)
            newp.coloreCapelli = persona.coloreCapelli
            newp.coloreOcchi = persona.coloreOcchi
            newp.colorePelle = persona.colorePelle
            newp.nascita = persona.annoNascita
            newp.sesso = persona.sesso
            newp.films = persona.film
            newp.veicoli = persona.veicoli
            do {
                try context.save()
            }catch{
                print(error.localizedDescription)
            }
        }
        
    }
//    Lettura delle persone :
    func LetturaPersona(pers : FetchedResults<PersonaO>){
        self.persone = []
        for per in pers{
            self.persone.append(Persona(name: per.nome ?? "", immagine: per.immagine ?? "", altezza: Int(per.altezza), peso: Int(per.peso), coloreCapelli: per.coloreCapelli ?? "", colorePelle: per.colorePelle ?? "", coloreOcchi: per.coloreOcchi ?? "", annoNascita: per.nascita ?? "", sesso: per.sesso ?? "", film: per.films ?? [], veicoli: per.veicoli ?? []))
        }
    }
//    Rifare la lettrua e a scrittura per i film e i veicoli 
    
    
    
    
    
    
    
}


struct Persona: Identifiable,Equatable {
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
//   Implementazione Equitable  controllo che gli elemeni siano ugguali
    static func == (lhs: Persona, rhs: Persona) -> Bool{
        if (lhs.name == rhs.name) && (lhs.immagine == rhs.immagine) && (lhs.altezza == rhs.altezza) &&
            (lhs.peso == rhs.peso) && (lhs.coloreCapelli == rhs.coloreCapelli) && (lhs.colorePelle == rhs.colorePelle) &&
            (lhs.coloreOcchi == rhs.coloreOcchi) && (lhs.annoNascita == rhs.annoNascita){
            return true
        }
        else{
            return false
        }
    }
}

struct Film: Identifiable,Equatable {
    var id = UUID().uuidString
//    titolo del film, anno del film, messaggio di apertura
    var url: String
    var titolo: String
    var anno : String
    var messaggioApertura : String
//    per controllare la presenza
    static func == (lhs:Film, rhs: Film)-> Bool{
        if (lhs.url == rhs.url) && (lhs.titolo == rhs.titolo) && (lhs.anno == rhs.anno) && (lhs.messaggioApertura == rhs.messaggioApertura){
            return true
        }else{
            return false
        }
    }
}

struct Veicoli: Identifiable,Equatable {
    var id = UUID().uuidString
//    nome, modello, produttore, costo, lunghezza,
    var url: String
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
    
    static func == (lhs: Veicoli, rhs: Veicoli)-> Bool{
        if (lhs.nome == rhs.nome) && (lhs.modello == rhs.modello) && (lhs.produttore == rhs.produttore) && (lhs.costo == rhs.costo)
            && (lhs.lunghezza == rhs.lunghezza) && (lhs.massimaVelocità == rhs.massimaVelocità) && (lhs.equipaggio == rhs.equipaggio) &&
            (lhs.passeggeri == rhs.passeggeri) && (lhs.capacità == rhs.capacità) && (lhs.capacità == rhs.capacità) && (lhs.materialiConsumo == rhs.materialiConsumo) && (lhs.classeVeicolo == rhs.classeVeicolo){
            return true
        }else{
            return false
        }
    }
    
    
    
}
//Controllo la connessione ad internet 
struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet: Bool{
        return self.sharedInstance.isReachable
    }
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
