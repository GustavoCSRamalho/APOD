//
//  APODApp.swift
//  APOD
//
//  Created by Gustavo Ramalho on 12/09/25.
//

import SwiftUI

@main
struct APODApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
