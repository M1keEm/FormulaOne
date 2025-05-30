//
//  TeamListView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//

import SwiftUI
import CoreData

struct TeamListView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Team.name, ascending: true)],
        animation: .default
    ) var teams: FetchedResults<Team>
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(teams) { team in
                    NavigationLink(destination: TeamDetailView(team: team)) {
                        HStack {
                            AsyncImage(url: URL(string: team.logoURL ?? "")) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            VStack(alignment: .leading) {
                                Text(team.name ?? "Unknown Team")
                                    .font(.headline)
                                Text(team.country ?? "")
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            if team.isFavourite {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                }
            }
            .navigationTitle("F1 Teams")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: refreshData) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
            }
        }
    }
    
    private func refreshData() {
        PersistenceController.shared.createRealTeamsIfNeeded()
    }
}

struct TeamListView_Previews: PreviewProvider {
    static var previews: some View {
        TeamListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
