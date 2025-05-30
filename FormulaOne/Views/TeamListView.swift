//
//  TeamListView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//


import SwiftUI
import CoreData

struct TeamListView: View {
    @StateObject private var viewModel = TeamViewModel()
    @Environment(\.managedObjectContext) private var context
    
    var body: some View {
        NavigationStack {
            List(viewModel.teams, id: \.self) { team in
                NavigationLink(destination: TeamDetailView(team: team)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(team.name ?? "Unknown Team")
                                .font(.headline)
                            Text(team.country ?? "")
                                .font(.subheadline)
                        }
                        Spacer()
                        if team.isFavourite {
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                        }
                    }
                }
            }
            .navigationTitle("Teams")
            .onAppear {
                viewModel.fetchTeams()
                checkAndCreateQuiz()
            }
        }
    }
    
    private func checkAndCreateQuiz() {
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", "Team 1")
        
        do {
            let teams = try context.fetch(request)
            if let team1 = teams.first, team1.quiz == nil {
                PersistenceController.shared.createSampleQuiz(for: team1)
            }
        } catch {
            print("Failed to check for Team 1: \(error)")
        }
    }
}
