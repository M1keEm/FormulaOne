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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(teams) { team in
                    NavigationLink(destination: TeamDetailView(team: team)) {
                        HStack {
                            AsyncImageLoader(
                                url: URL(string: team.logoURL ?? ""),
                                placeholder: Image(systemName: "photo")
                            )
                            .frame(width: 40, height: 40)
                            
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
        }
    }
}

struct TeamListView_Previews: PreviewProvider {
    static var previews: some View {
        TeamListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
