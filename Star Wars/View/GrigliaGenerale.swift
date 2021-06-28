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
        GridItem(.adaptive(minimum: 100))
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible())
    ]
    @Binding var persone : [Persona]
    @EnvironmentObject var dati : Gestione
//    gestione coredata
    @State var ordinamento : Int = 0
    @State var selezionato : Bool = false
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: FilmO.entity(), sortDescriptors: [NSSortDescriptor(key: "titolo", ascending: true)]) var filmcoredata : FetchedResults<FilmO>
    @FetchRequest(entity: VeicoloO.entity(), sortDescriptors: [NSSortDescriptor(key: "nome", ascending: true)]) var veicolocoredata : FetchedResults<VeicoloO>
    var body: some View {
        //        NavigationView{
        VStack{
            Spacer()
            //            GeometryReader{ proxy  in
            ScrollView{
                //columns: columns,spacing: 10
                //columns: proxy.size.width > proxy.size.height ? Array(repeating: GridItem(.flexible(), spacing: 15, alignment: .top), count: 5) : Array(repeating: GridItem(.flexible(), alignment: .top), count: 3)
                LazyVGrid(columns: columns,spacing: 10){
                    ForEach(persone,id: \.id){ persona in
                        Elemnto(persona: persona).environmentObject(dati)
                            .padding(.top)
                        //                    .animation(.easeInOut(duration: 1))
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
                
            }
            //                        }
            
        }
    }
}
struct Elemnto : View {
    var persona :Persona
    @State private var isActive = false
    @EnvironmentObject var dati : Gestione
    var body: some View{
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
        .onTapGesture {
            self.isActive = true
        }
        .shadow(radius: isActive ? 9:0)
        .background(
            NavigationLink (
                destination: DettaglioView(persona: persona).environmentObject(dati), isActive: $isActive,
                label: {
                    EmptyView()
                }
            ))
    }
}



struct GrigliaGenerale_Previews: PreviewProvider {
    @State static var pers : [Persona] = []
    static var previews: some View {
        GrigliaGenerale(persone: $pers)
            .environmentObject(Gestione())
    }
}
