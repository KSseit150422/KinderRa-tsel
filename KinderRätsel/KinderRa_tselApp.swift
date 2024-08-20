//
//  KinderRa_tselApp.swift
//  KinderRätsel
//
//  Created by Karlheinz on 20.08.24.
//

import SwiftUI

@main
struct KinderRa_tselApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
