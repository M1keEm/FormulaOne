//
//  TeamListView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//


import SwiftUI

struct TeamListView: View {
    @StateObject private var viewModel = TeamViewModel()

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
            }
        }
    }
}