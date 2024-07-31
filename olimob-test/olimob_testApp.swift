//
//  olimob_testApp.swift
//  olimob-test
//
//  Created by Amal Zakirov on 31.07.2024.
//

import SwiftUI

@main
struct olimob_testApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
