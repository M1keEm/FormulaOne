//
//  FormulaOneApp.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 26/05/2025.
//

import SwiftUI

@main
struct FormulaOneApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
