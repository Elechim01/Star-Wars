//
//  GrigliaGenerale.swift
//  Star Wars
//
//  Created by Michele Manniello on 23/06/21.
//

import SwiftUI
import Alamofire
import SDWebImageSwiftUI

struct GrigliaGenerale: View {
    let columns = [
        GridItem(.adaptive(minimum: 130))
    ]
    @Binding var persone : [Persona]
    @EnvironmentObject var dati : Gestione
    var body: some View {
        VStack{
            Spacer()
            ScrollView{
                LazyVGrid(columns: columns,spacing: 10){
                    ForEach(persone,id: \.id){ persona in
                        NavigationLink(
                            destination: DettaglioView(persona: persona).environmentObject(dati)
                                .onAppear{
                                    dati.GetOther(persona: persona)
                                },
                            label: {
                                VStack{
                                    AnimatedImage(url: URL(string: persona.immagine))
                                        .resizable()
                                        .placeholder{
                                            AnimatedImage(url:URL(string:"https://mobile.aws.skylabs.it/mobileassignments/swapi/placeholder.png"))
                                                .resizable()
                                        }
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle()).shadow(radius: 20)
                                    
                                    Text(persona.name)
                                        .fontWeight(.heavy)
                                }
                            })
                            .padding(.top)
                            .animation(.easeInOut(duration: 2))
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
                
            }
            
        }
    }
}

struct GrigliaGenerale_Previews: PreviewProvider {
    @State static var pers : [Persona] = []
    static var previews: some View {
        GrigliaGenerale(persone: $pers)
            .environmentObject(Gestione())
    }
}
