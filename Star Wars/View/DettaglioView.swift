//
//  DettaglioView.swift
//  Star Wars
//
//  Created by Michele Manniello on 23/06/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct DettaglioView: View {
    var persona : Persona
    @EnvironmentObject var dati : Gestione
    @State var mostra : Bool = false
    @State var mostrav : Bool = false
    @State var filmv : Film = Film(titolo: "", anno: "", messaggioApertura: "")
    @State var veicolov : Veicoli = Veicoli(nome: "", modello: "", produttore: "", costo: "", lunghezza: 0, massimaVelocità: 0, equipaggio: 0, passeggeri: 0, capacità: 0, materialiConsumo: "", classeVeicolo: "")
    var body: some View {
        ZStack {
            ScrollView{
            VStack {
                Intestazione(persona: self.persona)
                Divider()
                Text("Film")
                    .fontWeight(.bold)
                    .padding(.top)
                ScrollView{
                    ForEach(dati.film, id: \.id){ film in
                        
                        Button(action: {
                            self.filmv = film
                            print(filmv)
                            withAnimation{
                                self.mostra.toggle()
                            }
                        }, label: {
                            
                            DetailList(testo: film.titolo)
                        })
                        //                        Text(film.messaggioApertura)
                    }
                    Divider()
                        .frame( height: 2)
                    Text("Veicoli")
                        .fontWeight(.bold)
                        .padding(.top)
                    ForEach(dati.veicoli, id: \.id){ veicolo in
                        Button(action: {
                            self.veicolov = veicolo
                            withAnimation{
                                self.mostrav.toggle()
                                
                            }
                        }, label: {
                            DetailList(testo: veicolo.nome)
                        })
                    }
                }
                Spacer()
            }
            }
            if mostra == true{
                InformazioniFilm(film: filmv, chiudi: $mostra)
                  .cornerRadius(30)
            }
            if mostrav == true{
                InformazioniVeicoli(mostra: $mostrav, veicolo: veicolov)
                    .cornerRadius(30)
            }
        }
    }
}

struct DettaglioView_Previews: PreviewProvider {
     static var pers : Persona = Persona(name: "luke ", immagine: "https://mobile.aws.skylabs.it/mobileassignments/swapi/1.png", altezza: 3, peso: 2, coloreCapelli: "w", colorePelle: "w", coloreOcchi: "w", annoNascita: "q", sesso: "w", film: [""], veicoli: [""])
    
    static var previews: some View {
        Group {
            DettaglioView(persona: pers)
                .environmentObject(Gestione())
        }
    }
}

struct Intestazione: View {
    var persona : Persona
    var body: some View {
        HStack{
            Spacer()
            AnimatedImage(url: URL(string: persona.immagine))
                .resizable()
                .placeholder{
                    AnimatedImage(url:URL(string:"https://mobile.aws.skylabs.it/mobileassignments/swapi/placeholder.png"))
                        .resizable()
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle()).shadow(radius: 20)
            Spacer()
            VStack{
                Text("Nome \(persona.name)\nAltezza \(persona.altezza)m\nPeso \(persona.peso)Kg\nColore Capelli \(persona.coloreCapelli)\nColore pelle \(persona.colorePelle)\nColore occhi \(persona.coloreOcchi)\nData di nascita \(persona.annoNascita)\nSesso \(persona.sesso)")
                    .fontWeight(.light)
                
                //                    var altezza : Int
                //                    var peso : Int
                //                    var coloreCapelli : String
                //                    var colorePelle : String
                //                    var coloreOcchi: String
                //                    var annoNascita : String
                //                    var sesso : String
            }
            .padding(.top)
            Spacer()
        }
    }
}

struct DetailList: View {
    var testo : String
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 350, height:50)
                .foregroundColor(.gray.opacity(0.2))
                .cornerRadius(20)
            Text("\(testo)")
                .fontWeight(.medium)
            //                                        .foregroundColor(.black)
            //                                    Text("Anno: \(film.anno)")
            
        }
    }
}
