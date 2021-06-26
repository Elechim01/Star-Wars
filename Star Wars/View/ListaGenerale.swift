//
//  ListaGenerale.swift
//  Star Wars
//
//  Created by Michele Manniello on 23/06/21.
//

import SwiftUI
import Alamofire
import SDWebImageSwiftUI

struct ListaGenerale: View {
    @Binding var persone : [Persona]
    @EnvironmentObject var dati : Gestione
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: FilmO.entity(), sortDescriptors: [NSSortDescriptor(key: "titolo", ascending: true)]) var filmcoredata : FetchedResults<FilmO>
    @FetchRequest(entity: VeicoloO.entity(), sortDescriptors: [NSSortDescriptor(key: "nome", ascending: true)]) var veicolocoredata : FetchedResults<VeicoloO>
    var body: some View {
        VStack {
            List(persone, id: \.id){ persona in
                NavigationLink(
                    destination: DettaglioView(persona: persona).environmentObject(dati)
                        .onAppear{
                            dati.GetOther(persona: persona,veic:veicolocoredata , fil: filmcoredata,context:context)
                        },
                    label: {
                        HStack{
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
//                    .onDisappear{
//                       
//                    }
                
            }
        }
    }
}

struct ListaGenerale_Previews: PreviewProvider {
     @State static var pers : [Persona] = []
    static var previews: some View {
        ListaGenerale(persone: $pers)
            .environmentObject(Gestione())
    }
}
