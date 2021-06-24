//
//  InformazioniFilm.swift
//  Star Wars
//
//  Created by Michele Manniello on 24/06/21.
//

import SwiftUI

struct InformazioniFilm: View {
    var film :Film
    @Binding var chiudi : Bool
    var body: some View {
        HStack{
            ScrollView{
                HStack{
                    Spacer()
                    Button(action: {
                        withAnimation {
                            chiudi.toggle()
                        }
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 15, height: 15)
                        //                        .foregroundColor(Color("bginfo"))
                    })
                }
                .frame(height: 5)
                .padding()
                Text("\(film.titolo)")
                Text("Anno di uscita")
                    .padding(.top)
                Text("\(film.anno)")
                    .frame(alignment: .center)
                    .padding(.top)
                Text("Messaggio di apertura ")
                    .padding(.top)
                Text("\(film.messaggioApertura)")
                    .frame(maxHeight: .infinity)
                    .padding(.top)
                Spacer()
            }
        }
//        .frame(width: 300, height: 500)
//        .background(Color("bginfo"))
        .background(Color("bginfo"))
    }
}

struct InformazioniFilm_Previews: PreviewProvider {
    static var film = Film(titolo: "prova1", anno: "2021-05-21", messaggioApertura: "in una galassia lontana lontana...")
    @State static var chiudi = false
    static var previews: some View {
        InformazioniFilm(film: film,chiudi: $chiudi)
    }
}
