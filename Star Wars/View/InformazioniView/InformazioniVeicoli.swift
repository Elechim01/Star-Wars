//
//  InformazioniVeicoli.swift
//  Star Wars
//
//  Created by Michele Manniello on 24/06/21.
//

import SwiftUI

struct InformazioniVeicoli: View {
    @Binding var mostra : Bool
    var veicolo : Veicoli
    var body: some View {
        VStack{
            ScrollView{
                HStack{
                    Spacer()
                    Button(action: {
                        withAnimation {
                            mostra.toggle()
                        }
                        
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 15, height: 15)
                    })
//                    .padding(.trailing)
                }
                .frame(height: 5)
                .padding()
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        Text("\(veicolo.nome)")
                        Text("Produttore: \(veicolo.produttore)")
                            .padding(.top,5)
                        Text("Costo:  \(veicolo.costo)")
                            .padding(.top,5)
                        Text("Lunghezza: \(veicolo.lunghezza)metri")
                            .padding(.top,5)
                        Text("Velocità Massima: \(veicolo.massimaVelocità)Km/h")
                            .padding(.top,5)
                        Text("N° Equipaggio: \(veicolo.equipaggio)")
                            .padding(.top,5)
                        Text("N° Passeggeri: \(veicolo.passeggeri)")
                            .padding(.top,5)
                    }
                    VStack(alignment: .leading){
                        Text("Capacità: \(veicolo.capacità)L")
                            .padding(.top,5)
                        Text("Materiali:\(veicolo.materialiConsumo)")
                            .padding(.top,5)
                        Text("Classe: \(veicolo.classeVeicolo)")
                            .padding(.top,5)
                    }
                }
                Spacer()
            }
        }
//        .frame(width: 270, height: 400)
        //        .background(Color("bginfo"))
        .background(Color("bginfo"))
    }
}

struct InformazioniVeicoli_Previews: PreviewProvider {
    static var v = Veicoli(nome: "sottomarino", modello: "e", produttore: "e", costo: "ee", lunghezza: 34, massimaVelocità: 345, equipaggio: 2, passeggeri: 2, capacità: 34, materialiConsumo: "werty", classeVeicolo: "ssss")
    @State static var mostra = true
    static var previews: some View {
        InformazioniVeicoli(mostra: $mostra, veicolo: v)
    }
}
//var nome : String
//var modello : String
//var produttore : String
//var costo : String
//var lunghezza : Double
//var massimaVelocità : Int
//var equipaggio : Int
//var passeggeri : Int
//var capacità : Double
//var materialiConsumo : String
//var classeVeicolo : String
