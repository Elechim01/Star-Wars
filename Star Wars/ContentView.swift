//
//  ContentView.swift
//  Star Wars
//
//  Created by Michele Manniello on 22/06/21.
// Cose da fare:
// Nella lista/griglia mostrare: avatar, nome
//Nella schermata di dettaglio, visualizzare:
//- i dettagli del personaggio (foto, altezza, peso, colore capelli, etc)
//- la lista dei film nei quali figura il personaggio (titolo del film, anno del film, messaggio di
//apertura)
//- la lista dei veicoli che il personaggio ha pilotato (nome, modello, produttore, costo, lunghezza,
//etc)
//Chiedere se nella schermata di dettaglio è possibile implementare l'onclick ? 


import SwiftUI
import Alamofire
import SDWebImageSwiftUI


struct ContentView: View {
    @ObservedObject var dati = Gestione()
    @State var seleziona :Bool = false
    @State var selezionato : Bool = false
    var body: some View {
        NavigationView{
            VStack{
                if seleziona == false{
                if selezionato == false{
                    //                mostra la lista
                    ListaGenerale(persone: $dati.persone)
                }else{
                    //                mostra la griglia
                    GrigliaGenerale(persone: $dati.persone)
                }
                }
                //            bottone per lo switch..
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Star Wars")
            .navigationBarItems(leading:
                                    Button(action: {
                                        selezionato.toggle()
                                    }, label: {
                                        Text("Cambia")
                                    })
            )
        }
        
        .onAppear(perform: {
            dati.RecuperoValori()
            self.seleziona = true
        })
        .alert(isPresented: $seleziona, content: {
            
            let lista = Alert.Button.default(Text("Lista")){
                self.selezionato = false
            }
            let griglia = Alert.Button.default(Text("Griglia")){
                self.selezionato = true
            }
            return Alert(title: Text("Seleziona la visualizzazione"), primaryButton: lista, secondaryButton: griglia)
        })
//        alert  per la scelta...
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
