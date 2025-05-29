//
//  TeamViewModel.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//

import Foundation
import CoreData

class TeamViewModel: ObservableObject {
    @Published var teams: [Team] = []
    private let context = PersistenceController.shared.container.viewContext

    func fetchTeams() {
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        do {
            teams = try context.fetch(request)
        } catch {
            print("Failed to fetch teams: \(error)")
        }
    }

    func toggleFavourite(_ team: Team) {
        team.isFavourite.toggle()
        saveContext()
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Saving context failed: \(error)")
        }
    }
}
