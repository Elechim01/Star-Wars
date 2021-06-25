//
//  Star_WarsApp.swift
//  Star Wars
//
//  Created by Michele Manniello on 22/06/21.
//

import SwiftUI
import  CoreData
@main
struct Star_WarsApp: App {
    let persistanceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistanceController.container.viewContext)
        }
    }
}
