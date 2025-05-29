//
//  ContentView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 26/05/2025.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(
        entity: Team.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Team.name, ascending: true)]
    ) var teams: FetchedResults<Team>

    var body: some View {
        NavigationView {
            List(teams, id: \.self) { team in
                VStack(alignment: .leading) {
                    Text(team.name ?? "Unknown Team")
                        .font(.headline)
                    Text("Country: \(team.country ?? "-")")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Teams")
        }
    }
}
