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
    @Published var film : [Film] = []
    @Published var veicoli : [Veicoli] = []
    //    Alert per connessione
    //    @Published var alert
    
    
    func RecuperoValori(context: NSManagedObjectContext,pers : FetchedResults<PersonaO>,vei: FetchedResults<VeicoloO>,fil : FetchedResults<FilmO>, sincronizza : Bool){
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
        //        in sincronizza non serve azzerare persone :
        //        var persone1: [Persona] = []
        if sincronizza == false{
            DispatchQueue.main.async {
                self.persone = []
                self.film = []
                self.veicoli = []
            }
        }
        var indirizzo : String? = "https://swapi.dev/api/people"
        var trovaid : String = ""
        
        while indirizzo != nil {
            print("\n🤖",film,"\n🤖",veicoli)
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
                    //                    Recupero  tutti gli elementi
                    for elementi  in macchine {
                        //                    veicoli.append(self.getVeicoli(indirizzo: elementi.string!))
                        //                    Recuper l'url e lo inserisco nelle persone...
                        print("🤖macchine",elementi.string!)
                        elencoveicoli.append(elementi.string!)
                        //                        Recupero i veicoli e li inserisco nell'array veicolo..
                        //                        implementare la sincronizzazione
                        //                            devo  leggere i veicoli da internet...
                        //                        controllare che l'ulr non sia già presenta
                        var presente : Bool = false
                        for v in self.veicoli{
                            if v.url == elementi.string!{
                                presente = true
                            }
                        }
                        
                        if presente == false{
                            let v  = getVeicoli(str: elementi.string!,context: context,vei: vei)
                            if sincronizza == true{
                                //  devo sicronizzare gli elementi,devo cercare l'elemento e se non lo trovo aggiungerlo nell'array e in coredata..
                                var trovato : Bool = false
                                for veicolot in veicoli{
                                    if veicolot == v{
                                        trovato.toggle()
                                    }
                                }
                                if trovato == false{
                                    //                            setto il cambiamento nel main thread...
                                    DispatchQueue.main.async {
                                        self.veicoli.append(v)
                                    }
                                    //                    Aggiungere il valore nel core data....
                                }
                            }else{
                                // Se non sincronizzo devo aggiungere l'elmento....
                                DispatchQueue.main.async {
                                    self.veicoli.append(v)
                                }
                            }
                            self.AggiungiVeicoli(context: context, veicolo: v, veic: vei)
                        }
                    }
                    //                    Aggiungo anche le navi spaziali
                    let naveSpaziale = i["starships"].array!
                    for nave in naveSpaziale{
                        elencoveicoli.append(nave.string! + "O")
                        
                        var presente : Bool = false
                        for v in self.veicoli{
                            if v.url == nave.string! + "O"{
                                presente = true
                            }
                        }
                        if presente == false{
                            let n  = getVeicoli(str: nave.string! + "O",context: context,vei: vei)
                            if sincronizza == true{
                                //                            devo sicronizzare gli elementi,devo cercare l'elemento e se non lo trovo aggiungerlo nell'array e in coredata..
                                var trovato : Bool = false
                                for veicolot in veicoli{
                                    if veicolot == n{
                                        trovato.toggle()
                                    }
                                }
                                if trovato == false{
                                    //                            setto il cambiamento nel main thread...
                                    DispatchQueue.main.async {
                                        self.veicoli.append(n)
                                    }
                                }
                            }else{
                                // Se non sincronizzo devo aggiungere l'elmento....
                                DispatchQueue.main.async {
                                    self.veicoli.append(n)
                                }
                            }
                            //                    Aggiungere il valore nel core data....
                            self.AggiungiVeicoli(context: context, veicolo: n, veic: vei)
                        }
                    }
                    
                    let films = i["films"].array!
                    elencoFilm = []
                    for film in films {
                        //                ottengo i film
                        //                    elencoFilm.append(self.getFilm(indirizzo: film.string!))
                        elencoFilm.append(film.string!)
                        var presente : Bool = false
                        for f in self.film{
                            if f.url == film.string!{
                                presente = true
                            }
                        }
                        if presente == false{
                            let f = getFilm(indirizzo: film.string!, context: context, fil: fil)
                            if sincronizza == true{
                                //                            devo sicronizzare gli elementi,devo cercare l'elemento e se non lo trovo aggiungerlo nell'array e in coredata..
                                var trovato : Bool = false
                                for filmt in self.film{
                                    if filmt == f{
                                        trovato.toggle()
                                    }
                                }
                                if trovato == false{
                                    //                            setto il cambiamento nel main thread...
                                    DispatchQueue.main.async {
                                        self.film.append(f)
                                    }
                                }
                            }else{
                                // Se non sincronizzo devo aggiungere l'elmento....
                                DispatchQueue.main.async {
                                    self.film.append(f)
                                }
                            }
                            self.AggiungiFilm(context: context, film: f, fil: fil)
                        }
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
                    //                    in sincronizzazioe controllare che la persona non sia presente prima di aggiungerla
                    if sincronizza == true{
                        //                    uso trovato
                        var trovato : Bool = false
                        for per in persone{
                            if per == p{
                                trovato.toggle()
                            }
                        }
                        if trovato == false{
                            //                            setto il cambiamento nel main thread...
                            DispatchQueue.main.async {
                                self.persone.append(p)
                            }
                            //                    Aggiungere il valore nel core data....
                            //                            self.AggiungiPersona(context: context, persona: p, pers: pers)
                        }
                        
                        
                    }else{
                        //                        Basta ogni cambiamento va inserito ne main thread..
                        DispatchQueue.main.async {
                            self.persone.append(p)
                        }
                        
                        //                    Aggiungere il valore nel core data....
                        self.AggiungiPersona(context: context, persona: p, pers: pers)
                    }
                    
                    //                    indice += 1
                }
                print(self.persone)
            }
        }
    }
        //        crah offline
        
        func TrovaId(url : String) -> String {
            let start = url.index(url.startIndex,offsetBy: 29)
            let end = url.index(url.endIndex,offsetBy: -1)
            let range = start..<end
            let mysubstring = url[range]
            return String(mysubstring)
        }
        
        //        funzione che restituisce i veicoli
        
        func getVeicoli(str: String,context : NSManagedObjectContext, vei: FetchedResults<VeicoloO> ) -> Veicoli {
            
            //        se c'è una nave spaziale l'ultima lettera èo
            var navespaziale : Bool = false
            var indirizzo : String = ""
            //        controllare se è una nave spaziale :
            let index = str.index(str.endIndex, offsetBy: -1)
            let mySubstring = str.suffix(from: index)
            if mySubstring == "O"{
                navespaziale = true
                let cont = str.count
                let start = str.index(str.startIndex,offsetBy: cont-1)
                let mystring  = str[..<start]
                indirizzo = String(mystring)
            }
            else{
                indirizzo = str
            }
            //        recupero l'indirizzo :
            print("🤖",indirizzo)
            let url = URL(string: indirizzo)!
            if let datav = try? Data(contentsOf: url) {
                // we're OK to parse!
                let json = try! JSON(data: datav)
                let nome = json["name"].string!
                let modello = json["model"].string!
                let produttore = json["manufacturer"].string!
                let costo = json["cost_in_credits"].string!
                let lunghezza = Double(json["length"].string!) ?? 0
                let velocità = Int(json["max_atmosphering_speed"].string!) ?? 0
                let equipaggio = Int(json["crew"].string!) ?? 0
                let passegeri = Int(json["passengers"].string!) ?? 0
                let capacità = Double(json["cargo_capacity"].string!) ?? 0
                let consumo = json["consumables"].string!
                var tipo = ""
                if navespaziale == true{
                    print(json["starship_class"])
                    tipo = json["starship_class"].string!
                }else{
                    print(json["vehicle_class"])
                    tipo = json["vehicle_class"].string!
                }
                //            let tipo = navespaziale ? json["starship_class"].string!: json["vehicle_class"].string!
//                controllo che se sia una nave spaziale l'url deve avere la O
                if navespaziale == true{
                    indirizzo = indirizzo + "O"
                }
                
                let veicolo = Veicoli(url: indirizzo,nome: nome, modello: modello, produttore: produttore, costo: costo, lunghezza: lunghezza, massimaVelocità: velocità, equipaggio: equipaggio, passeggeri: passegeri, capacità: capacità, materialiConsumo: consumo, classeVeicolo: tipo)
                //            Aggiugno CoreData
                //            self.AggiungiVeicoli(context: context, veicolo: veicolo, veic: vei)
                return veicolo
                
            }
            
            return Veicoli(url : "",nome: "", modello: "", produttore: "", costo: "", lunghezza: 0, massimaVelocità: 0, equipaggio: 0, passeggeri: 0, capacità: 0.0, materialiConsumo: "", classeVeicolo: "")
        }
        
        //    funzione che ottiene i film
        func getFilm(indirizzo : String,context: NSManagedObjectContext,fil : FetchedResults<FilmO>) -> Film {
            let url = URL(string: indirizzo)!
            if let dataf = try? Data(contentsOf: url){
                let json = try! JSON(data: dataf)
                print(json)
                let titolo = json["title"].string!
                let anno = json["release_date"].string!
                let messaggio = json["opening_crawl"].string!
                let film = Film(url: indirizzo,titolo: titolo, anno: anno, messaggioApertura: messaggio)
                //            inserisco i film dentro coredata
                //            self.AggiungiFilm(context: context, film: film, fil: fil)
                return film
                
            }
            return Film(url: "",titolo: "", anno: "", messaggioApertura: "")
        }
        
        //    qundo seleziono il personaggio scarico i valori di esso
        func Getoffline (pers :FetchedResults<PersonaO>,veic: FetchedResults<VeicoloO>,fil : FetchedResults<FilmO>) {
            //        leggo le persone
            self.persone = []
            self.veicoli = []
            self.film = []
            LetturaPersona(pers: pers)
            
            //        leggo i film
            for pers in self.persone {
                for url in pers.film{
                    if url != ""{
                        var presente : Bool = false
                        for f in self.film{
                            if f.url == url{
                                presente = true
                            }
                        }
                        if presente == false{
                            self.film.append(LetturaFilm(fil: fil, url: url))
                        }
                    }
                }
                print(film)
                //            leggo i veicoli
                for url in pers.veicoli{
                    var presente : Bool = false
                    for v in self.veicoli{
                        if v.url == url{
                            presente = true
                        }
                    }
                    if presente == false{
                        self.veicoli.append(LetturaVeicoli(veic: veic, url: url))
                    }
                }
            }
            ////        pulire i filme e i veicoli
            //        self.film = []
            //        self.veicoli = []
            ////        leggo i veicoli:
            //
            //
            ////        Controllare la connessione:
            //        if Connectivity.isConnectedToInternet == false{
            ////            offline leggo da coredata.....
            //            for f in persona.film{
            //                self.film.append(LetturaFilm(fil: fil, url: f))
            //            }
            //            for v in persona.veicoli {
            //                self.veicoli.append(LetturaVeicoli(veic: veic, url: v))
            //            }
            //            print(veicoli)
            //        }else{
            ////            online leggo da internet...
            //            for f in persona.film{
            //                self.film.append(getFilm(indirizzo: f,context: context,fil: fil))
            //            }
            //            for v in persona.veicoli {
            //                self.veicoli.append(getVeicoli(str: v,context: context,vei: veic))
            //            }
            //        }
            //        print(film)
            //        print(veicoli)
        }
        
        //    Filtri per ricercare gli elementi negli array.....
        func FiltroFilm(persona : Persona) -> [Film] {
            var elementifilm :[Film] = []
            for fil in film {
                for url in persona.film{
                    if url == fil.url {
                        elementifilm.append(fil)
                    }
                }
            }
            return elementifilm
        }
        func FiltroVeicoli(persona : Persona) -> [Veicoli] {
            var elementiveicolo :[Veicoli] = []
            for url in persona.veicoli{
                for vei in self.veicoli {
                    print(url, vei.url)
                    if url == vei.url {
                        elementiveicolo.append(vei)
                    }
                }
            }
            return elementiveicolo
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
        //    Scrittura Veicoli
        func AggiungiVeicoli(context : NSManagedObjectContext, veicolo: Veicoli, veic: FetchedResults<VeicoloO>){
            let veicolon = VeicoloO(context: context)
            //        controllare che la persona sia presente del databse:
            var vuoto : Bool = true
            for ve in veic {
                if Veicoli(url: ve.url ?? "", nome: ve.nome ?? "", modello: ve.modello ?? "", produttore: ve.produttore ?? "", costo: ve.costo ?? "", lunghezza: ve.lunghezza, massimaVelocità: Int(ve.maxVelo), equipaggio: Int(ve.equipaggio), passeggeri: Int(ve.passeggeri), capacità: ve.capacita, materialiConsumo: ve.matCons ?? "", classeVeicolo: ve.classeVeic ?? "") == veicolo{
                    vuoto = false
                }
            }
            if vuoto == true{
                print("🤖",veicolo)
                veicolon.url = veicolo.url
                veicolon.nome = veicolo.nome
                veicolon.modello = veicolo.modello
                veicolon.produttore = veicolo.produttore
                veicolon.costo = veicolo.costo
                veicolon.lunghezza = veicolo.lunghezza
                veicolon.maxVelo = Double(veicolo.massimaVelocità)
                veicolon.equipaggio = Double(veicolo.equipaggio)
                veicolon.passeggeri = Double(veicolo.passeggeri)
                veicolon.capacita = veicolo.capacità
                veicolon.matCons = veicolo.materialiConsumo
                veicolon.classeVeic = veicolo.classeVeicolo
                do {
                    try context.save()
                } catch  {
                    print(error.localizedDescription)
                }
            }
        }
        func AggiungiFilm(context: NSManagedObjectContext, film: Film, fil : FetchedResults<FilmO>){
            let newf = FilmO(context: context)
            var vuoto : Bool = true
            for fi in fil {
                if Film(url: fi.url ?? "", titolo: fi.titolo ?? "", anno: fi.anno ?? "", messaggioApertura: fi.messaggioAp ?? "") == film{
                    vuoto = false
                }
            }
            if vuoto == true{
                newf.url = film.url
                newf.titolo = film.titolo
                newf.anno  = film.anno
                newf.messaggioAp = film.messaggioApertura
                do {
                    try context.save()
                } catch  {
                    print(error.localizedDescription)
                }
            }
        }
        
        
        //    Lettura delle persone :
        func LetturaPersona(pers : FetchedResults<PersonaO>){
            self.persone = []
            print(pers)
            for per in pers{
                //            Controllo se non ci sono persone vuote
                print(per.nome)
                if per.nome != nil{
                    self.persone.append(Persona(name: per.nome ?? "", immagine: per.immagine ?? "", altezza: Int(per.altezza), peso: Int(per.peso), coloreCapelli: per.coloreCapelli ?? "", colorePelle: per.colorePelle ?? "", coloreOcchi: per.coloreOcchi ?? "", annoNascita: per.nascita ?? "", sesso: per.sesso ?? "", film: per.films ?? [], veicoli: per.veicoli ?? []))
                }
            }
            print(persone)
        }
        //    Rifare la lettrua e a scrittura per i film e i veicoli
        
        func LetturaVeicoli(veic: FetchedResults<VeicoloO>,url: String) -> Veicoli{
            var veicoli: Veicoli = Veicoli(url: "", nome: "", modello: "", produttore: "", costo: "", lunghezza: 0, massimaVelocità: 0, equipaggio: 0, passeggeri: 0, capacità: 0, materialiConsumo: "", classeVeicolo: "")
            var indirizzo : String = ""
            //        controllare se è una nave spaziale :
            let index = url.index(url.endIndex, offsetBy: -1)
            let mySubstring = url.suffix(from: index)
            if mySubstring == "O"{
                //            navespaziale = true
                let cont = url.count
                let start = url.index(url.startIndex,offsetBy: cont-1)
                let mystring  = url[..<start]
                indirizzo = String(mystring)
            }
            else{
                indirizzo = url
            }
            for ve in veic{
                //            controllo che sia quello che cerco, prevedere il caso di navi spaziali, strigha che termina con la O, rimoverla:
                if ve.url != nil{
                    print(ve.url!)
                    if ve.url! == indirizzo{
                        if ve.url != ""{
                            veicoli = (Veicoli(url: ve.url ?? "", nome: ve.nome ?? "", modello: ve.modello ?? "", produttore: ve.produttore ?? "", costo: ve.costo ?? "", lunghezza: ve.lunghezza, massimaVelocità: Int(ve.maxVelo), equipaggio: Int(ve.equipaggio), passeggeri: Int(ve.passeggeri), capacità: ve.capacita, materialiConsumo: ve.matCons ?? "", classeVeicolo: ve.classeVeic ?? ""))
                            return veicoli
                        }
                    }
                }
            }
            return veicoli
        }
        
        func LetturaFilm(fil : FetchedResults<FilmO>, url : String) -> Film{
            var film = Film(url: "", titolo: "", anno: "", messaggioApertura: "")
            
            for fi in fil {
                //            controllo che sia quello che cerco
                if fi.url != nil{
                    if fi.url! == url{
                        if fi.url != ""{
                            film = Film(url: fi.url ?? "", titolo: fi.titolo ?? "", anno: fi.anno ?? "", messaggioApertura: fi.messaggioAp ?? "")
                            return film
                        }
                    }
                }
            }
            return film
        }
    
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
