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
    var body: some View {
        VStack {
            Text("film \(dati.film.count) \(dati.veicoli.count)")
            ScrollView{
                ForEach(dati.film, id: \.id){ film in
                        Text("\(film.anno),\(film.titolo)")
//                        Text(film.messaggioApertura)
                }
            Divider()
                Text("Veicoli")
                ForEach(dati.veicoli, id: \.id){ veicolo in
                    VStack {
                        Text("\(veicolo.classeVeicolo)")
                        Text("\(veicolo.nome)")
                    }
            }
            }
            Spacer()
        }
    }
}

struct DettaglioView_Previews: PreviewProvider {
     static var pers : Persona = Persona(name: "l", immagine: "https://mobile.aws.skylabs.it/mobileassignments/swapi/1.png", altezza: 3, peso: 2, coloreCapelli: "w", colorePelle: "w", coloreOcchi: "w", annoNascita: "q", sesso: "w", film: [""], veicoli: [""])
    
    static var previews: some View {
        DettaglioView(persona: pers)
            .environmentObject(Gestione())
    }
}
