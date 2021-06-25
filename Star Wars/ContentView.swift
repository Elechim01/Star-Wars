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
//CONTROLLARE lo stato della conessione anche quando l'app è in esecuzione  e in base a quello verificare se usare coredata... 

import SwiftUI
import Alamofire
import SDWebImageSwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var dati = Gestione()
    @State var seleziona :Bool = false
    @State var selezionato : Bool = false
//    Core data....
    @Environment(\.managedObjectContext) var context
//    Persone
    @FetchRequest(entity: PersonaO.entity(), sortDescriptors: [NSSortDescriptor(key: "nome", ascending: true)]) var pers :FetchedResults<PersonaO>
    
    
    var body: some View {
        NavigationView{
            VStack{
                if seleziona == false{
                    if selezionato == false{
                        //                mostra la lista
                        ListaGenerale(persone: $dati.persone).environmentObject(dati)
                    }else{
                        //                mostra la griglia
                        GrigliaGenerale(persone: $dati.persone).environmentObject(dati)
                    }
                }
                //            bottone per lo switch..
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Star Wars")
            .navigationBarItems(leading:
                                    Menu {
                                        Button(action: {
                                            dati.persone.sort { p1,p2 in
                                                p1.name < p2.name
                                            }
                                            
                                        }, label: {
                                            Text("Crescente ")
                                        })
                                        Button(action: {
                                            dati.persone.sort { p1,p2 in
                                                p1.name > p2.name
                                            }
                                        }, label: {
                                            Text("Decrescente")
                                        })
                                        
                                    } label: {
                                        Text("Ordina")
                                    }
                                ,trailing: Button(action: {
                                    selezionato.toggle()
                                }, label: {
                                    Image(systemName: selezionato ? "list.triangle" :"circle.grid.2x2.fill")
                                })
                                
                                
            )
            //            .navigationBarItems(leading:
        }
        .onAppear(perform: {
            if Connectivity.isConnectedToInternet == false{
                print(" 🤖offline")
                dati.LetturaPersona(pers: pers)
            }else{
                print("🤖 online")
                dati.RecuperoValori(context: context, pers: pers)
            }
            
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
//        .alert(item: Binding<Identifiable?>, content: <#T##(Identifiable) -> Alert#>)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
           
    }
}
